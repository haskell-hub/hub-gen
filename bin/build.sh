#!/bin/bash


# abort if anything fails

set -e


# where to get the source tree tapes 

sources=rpmbuild/SOURCES


# where to put the packages

repo=/hub/arch-repo


usage() {
    printf "usage: $0 --help \n"
    printf "       $0 --version\n"
    printf "       $0 --list \n"
    printf "       $0 --show-params  <package>\n"
    printf "       $0 --show-header  <package>\n"
    printf "       $0 --show-spec    <package>\n"
    printf "       $0 <package> ...\n"
    exit 1
}


hub-gen() {
    libexec/hub-gen.exe "$@"
}


# hub checked-out source tree

hubsrc=/hub/src
hubvrn=$(hub-gen --hub-version)
hubtbl=$(hub-gen --hub-tarball)
hubdir=hub-${hubvrn}

# quick sanity check on tarball filename 

if [ ${hubtbl} != hub-${hubvrn}.tar.gz ]; then
    echo "${hubtbl}: unexpected hub tarball filename"
    exit 1
fi

# location of rpmbuild tarballs

rpmbuild_sources=rpmbuild/SOURCES

x() {
    src=$1
    dir=$2

    archive=${dir}.tar.gz
    
    
    printf "\n\n*** creating ${archive} from ${src} ***\n\n"
    printf "setting up temporary directories\n"
    
    tmpd=${dir}.d
    rm -rf tmp/${tmpd}
    mkdir -p tmp/${tmpd}
    
    printf "copying over ${src} into tmp/${tmpd}/${dir}\n"
    
    cp -a ${src} tmp/${tmpd}/${dir}
    
    printf "cleaning up prep copy\n"
    
    rm -rf tmp/${tmpd}/${dir}/.git
    rm -f  tmp/${tmpd}/${dir}/.project
    rm -rf tmp/${tmpd}/${dir}/build
    rm -rf tmp/${tmpd}/${dir}/dist
    rm -f  tmp/${tmpd}/${dir}/PACKAGE_ME
    
    printf "archiving ${dir} to rpmbuild/SOURCES/${archive}\n"
    
    ( cd tmp/${tmpd}; tar czf ../../${rpmbuild_sources}/${archive} ${dir}; )
    
    printf "removing working copy, ${tmpd}\n"
    
    rm -rf tmp/${tmpd}
    
    printf "done\n\n"
}

test_x()
{
    src=$1
    dir=$2
    
    if [  -d ${src} -a -f ${src}/PACKAGE_ME ]; then
        x ${src} ${dir}
        (cd ${rpmbuild_sources}; sha1sum ${dir}.tar.gz >${dir}.tar.gz.SHA1)
    fi
}


# check CL args

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

if [ $# -eq 1 -a "$1" = --help ]; then
    usage
    exit 0
fi

if [ $# -eq 1 -a "$1" = --list ]; then
    hub-gen --list
    exit 0
fi

show=0
case $1 in
--show-params|--show-header|--show-spec) show=1;;
--version) hub-gen --version; exit 0;;
--*) usage; exit 1;;
esac

if [ ${show} == 1 ]; then
    if [ $# -ne 2 ]; then
        usage
        exit 1
    fi
    hub-gen "$@"
    exit
fi

# OK, we are building packages
   
# create rpmbuild tree (if not done already)

mkdir -p rpmbuild/SPECS
mkdir -p rpmbuild/RPMS
mkdir -p rpmbuild/SRPMS
mkdir -p rpmbuild/BUILD



# build the packages

for p in $*; do

    printf "\n\n *** Building Package ${p} ***\n\n"

    # see if we auto-creating tar ball from checked-out work tree

    case ${p} in
      haskell-hub)                            test_x ${hubsrc}                   ${hubdir}          ;;
      haskell-platform-2011.2.0.1-dist)       test_x /hub/hp/hp-2011.2.0.1       hp-2011.2.0.1      ;;
      haskell-platform-2011.4.0.0-dist)       test_x /hub/hp/hp-2011.4.0.0       hp-2011.4.0.0      ;;
     #haskell-platform-2012.2.0.0-beta2-dist) test_x /hub/hp/hp-2012.2.0.0-beta  hp-2012.2.0.0-beta2;;
      haskell-platform-2012.2.0.0-dist)       test_x /hub/hp/hp-2012.2.0.0       hp-2012.2.0.0      ;;
    esac

    # generate the RPM
    
    hub-gen ${p}

    # clean up
    
    echo cleaning up
    rm   -rf rpmbuild/BUILD
    mkdir -p rpmbuild/BUILD
done


# sign them and copy them into the repo

sign_install() {
    src=$1
    dst=$2
    
    for rpm in ${src}/*; do
        if [ -f ${rpm} ]; then
            printf "\n\nsiging+installing: ${rpm}\n\n"
            hub-rpm-sign.expect ${rpm}
            mv ${rpm} ${dst}
        fi
    done  
}

mkdir -p ${repo}/SRPMS
mkdir -p ${repo}/RPMS/x86_64

sign_install rpmbuild/SRPMS       ${repo}/SRPMS
sign_install rpmbuild/RPMS/x86_64 ${repo}/RPMS/x86_64


# rebuild the repo

createrepo ${repo}
