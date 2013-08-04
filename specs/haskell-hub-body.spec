

%global hub__local_rev      7
%global debug_package       %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__pr_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        The JustHub Distribution with Hub %{hub__hub_version}
Source0:        %{hub__hub_tarball}
URL:            http://hub.justhub.org
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Requires:       %{hub__vc_cabal}
Requires:       %{hub__vc_alex}
Requires:       %{hub__vc_happy}

%{hub__requires_plug}


%description
The Haskell Hub (%{hub__hub_version}) integrates multiple releases
of the Glasgow Haskell Compiler and Haskell Platform into a single
installation with a simple mechanism for selecting between
the installations. A sandbox mechanism, allowing users to install
packages on a per-project basis is also provided.


%prep
%setup -q -n hub-%{hub__hub_version}
%{hub__setup}
%hub__verify_source %{hub__hub_tarball}


%build
make


%install
make DESTDIR=${RPM_BUILD_ROOT} install

cd ${RPM_BUILD_ROOT}%{hub__bin}

mk() { rm -f $1; ln -s hub $1; }

mk ghc
mk ghci
mk ghc-pkg
mk hp2ps
mk hpc
mk hsc2hs
mk runghc
mk runhaskell
mk cabal
mk alex
mk happy
mk haddock


%files
%defattr(-,root,root,-)
%{hub__bin}
/usr/share/man/man1/hub.1.gz
/usr/share/man/man5/hub.5.gz

%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed Oct 12 2011 Chris Dornan <chris@chrisdornan.com>
- start
