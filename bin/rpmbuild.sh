#!/bin/sh

root=`pwd`

topdir=${root}/rpmbuild

t1="_topdir    ${topdir}"
t2="buildroot  %_topdir/BUILDROOT/%{name}-%{version}-root"

s1="_signature gpg"
s2="_gpg_path  ${HOME}/.gnupg"
s3="_gpg_name  mail@justhub.org"
s4="_gpgbin    /usr/bin/gpg"

exec rpmbuild --define "${t1}" \
              --define "${t2}" \
              --define "${s1}" \
              --define "${s2}" \
              --define "${s3}" \
              --define "${s4}" \
              -bb "$@"
