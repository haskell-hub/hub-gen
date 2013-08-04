

%global hub__local_rev      6
%global debug_package %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__hp_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Standard Haskell distribution (hub distribution)
Source0:        hp-%{hub__hp}.tar.gz
URL:            http://haskell.org/ghc/
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Requires:       %{hub__vc_hc_dist}
BuildRequires:  db4
Requires:       db4
BuildRequires:  zlib-devel
Requires:       zlib-devel
BuildRequires:  freeglut-devel
Requires:       freeglut-devel
%if %{defined hub__libedit}
Requires:       libedit-devel >= 2, libedit-devel < 3 
%endif

%{hub__requires_plug}


%description
The Haskell Platform is a blessed library and tool suite for Haskell
distilled from Hackage.


%prep
%setup -q -n hp-%{hub__hp}
%{hub__setup}
%hub__verify_source %{hub__hub_tarball}


%build
PATH=/usr/hs/gcc/bin:/usr/hs/binutils/bin:${PATH}
HUB=%{hub__ghc} GHC_PACKAGE_PATH=%{hub__ghc_db} ./configure --prefix=%{hub__hp_d}
HUB=%{hub__ghc} GHC_PACKAGE_PATH=%{hub__ghc_db} make


%install
echo ${RPM_BUILD_ROOT} >DESTDIR
HUB=%{hub__ghc} GHC_PACKAGE_PATH=%{hub__ghc_db} make install
mv ${RPM_BUILD_ROOT}/load ${RPM_BUILD_ROOT}%{hub__hp_d} 


%post
mkdir -p %{hub__db_d}
rm -rf %{hub__hp_db}
cp -a %{hub__ghc_db} %{hub__hp_db}
cd %{hub__hp_d}/load
for f in *; do %{hub__ghc_d}/bin/ghc-pkg -v0 --package-conf=%{hub__hp_db} update $f >/dev/null 2>&1; done


#%postun                    # not safe
#rm -rf %{hub__hp_db}       # updates will execute these scripts AFTER running the
                            # %post scipts of the incomming RPMs -- DOH!


%files
%defattr(-,root,root,-)
%{hub__hp_d}


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed Sep 14 2011 Chris Dornan <chris@chrisdornan.com>
- start
