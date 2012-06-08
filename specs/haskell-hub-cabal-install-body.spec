

%global hub__local_rev      4
%global debug_package       %{nil}


%global hub__exe            cabal
%global hub__pkg            cabal-install
%global hub__pkg_vrn        %{hub__pkg}-%{hub__cid_version}

%global hub__doc_pkg %{hub__doc}/%{hub__pkg_vrn}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__tl_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Cabal Install %{hub__cid_version} for The Haskell Hub
Source0:        %{hub__cid_tarball}
URL:            http://hackage.haskell.org/package/cabal-install
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}

%{hub__requires_plug}


%description
The Haskell Cabal %{hub__cid_version}: Common Architecture for Building
Applications and Libraries.

This package is part of the JustHub distribution.


%prep
%setup -q -n %{hub__pkg_vrn}
%{hub__setup}

hub load build-cabal-install <<EOF
^=7.4.1
HTTP-4000.2.3
mtl-2.1.1
network-2.3.0.14
parsec-3.1.2
random-1.0.1.1
text-0.11.2.1
transformers-0.3.0.0
zlib-0.5.3.3
EOF

hub set build-cabal-install
hub comment "for building Cabal Install (%{hub__cid_version})"

cabal configure --bindir=%{hub__tools} --datadir=%{hub__root}/share 


%build
cabal build


%install
cabal copy --destdir=${RPM_BUILD_ROOT}


%files
%defattr(-,root,root,-)
%{hub__tools}/%{hub__exe}
%doc %{hub__root}/share/doc/cabal-install-%{hub__cid_version}


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed Oct 12 2011 Chris Dornan <chris@chrisdornan.com>
- start
