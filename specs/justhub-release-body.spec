

%global hub__local_rev      4
%global debug_package   %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        2.0
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        The Haskell Hub repository installation package
URL:            http://hub.justhub.org
License:        BSD3
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Source1:        RPM-GPG-KEY-justhub-mail


%description
This package installs the Haskell Hub repository (see http://justhub.org).


%prep
%setup -cT
%{hub__setup}
%hub__verify_source RPM-GPG-KEY-justhub-mail


%build
%{__cat} <<EOF >%{hub__repo_name}.yum
### Name: JustHub Repository for %{hub__distro_tag} - CD
### URL: http://justhub.org/
[%{hub__repo_name}]
name = %{hub__distro_tag} - justhub.org - CD
baseurl = %{hub__repo_url}
enabled = 1
protect = 0
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-justhub-mail
gpgcheck = 1
EOF

%install
%{__cp} -a %{SOURCE1} .
%{__install} -Dp -m0644 %{SOURCE1}            ${RPM_BUILD_ROOT}%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-justhub-mail
%{__install} -Dp -m0644 %{hub__repo_name}.yum ${RPM_BUILD_ROOT}%{_sysconfdir}/yum.repos.d/%{hub__repo_name}.repo

%post
rpm -q gpg-pubkey-13fba420-4e6be8fc &>/dev/null || rpm --import %{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-justhub-mail || :

%files
%defattr(-, root, root, 0755)
%pubkey RPM-GPG-KEY-justhub-mail
%dir %{_sysconfdir}/yum.repos.d/
%config(noreplace) %{_sysconfdir}/yum.repos.d/%{hub__repo_name}.repo
%dir %{_sysconfdir}/pki/rpm-gpg/
%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-justhub-mail


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Tue Oct 18 2011 Chris Dornan <chris@chrisdornan.com>
- start
