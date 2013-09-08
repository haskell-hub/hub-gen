

%global hub__local_rev          6
%global debug_package           %{nil}

%global hub__exe                cabal-%{hub__c16_version}
%global hub__pkg                cabal-install
%global hub__pkg_vrn            %{hub__pkg}-%{hub__c16_version}

%global hub__doc_pkg %{hub__doc}/%{hub__pkg_vrn}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__tl_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Cabal Install %{hub__c16_version} for The Haskell Hub
Source0:        %{hub__c16_tarball}
URL:            http://hackage.haskell.org/package/cabal-install
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}

%{hub__requires_plug}


%description
The Haskell Cabal %{hub__c16_version}: Common Architecture for Building
Applications and Libraries.

This package is part of the JustHub distribution.


%prep
%setup -q -n %{hub__pkg_vrn}
%{hub__setup}

hub load build-cabal-install-116 <<EOF
^=7.6.3
HTTP-4000.2.8
mtl-2.1.2
network-2.4.1.2
parsec-3.1.3
random-1.0.1.1
text-0.11.3.1
transformers-0.3.0.0
zlib-0.5.4.1
EOF

hub set build-cabal-install-116
hub comment "for building Cabal Install (%{hub__c16_version})"

cabal configure --bindir=%{hub__tools} --program-suffix=-%{hub__c16_version} --datadir=%{hub__root}/share 


%build
cabal build


%install
cabal copy --destdir=${RPM_BUILD_ROOT}


%files
%defattr(-,root,root,-)
%{hub__tools}/%{hub__exe}
%doc %{hub__root}/share/doc/cabal-install-%{hub__c16_version}


%changelog

* Sun Jun 10 2012 Chris Dornan <chris@chrisdornan.com>
- start
