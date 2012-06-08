

%global hub__local_rev      4
%global debug_package       %{nil}


%global hub__exe            alex
%global hub__pkg            alex
%global hub__pkg_vrn        %{hub__pkg}-%{hub__alx_version}
%global hub__doc_pkg        %{hub__doc}/%{hub__pkg_vrn}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__tl_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Alex %{hub__alx_version} for The Haskell Hub
Source0:        %{hub__alx_tarball}
URL:            http://hackage.haskell.org/package/alex
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}

%{hub__requires_plug}


%description
The Haskell Scanner Generator, Alex %{hub__alx_version}

This package is part of the JustHub distribution.


%prep
%setup -q -n %{hub__pkg_vrn}
%{hub__setup}

hub load build-alex <<EOF
^=7.4.1
QuickCheck-2.4.2
random-1.0.1.1
EOF
hub set build-alex
hub comment "for building Alex (%{hub__alx_version})"

hub info

cabal configure --bindir=%{hub__tools} --datadir=%{hub__root}/share 


%build
cabal build


%install
cabal copy --destdir=${RPM_BUILD_ROOT}


%files
%defattr(-,root,root,-)
%{hub__tools}/%{hub__exe}
%{hub__root}/share/alex-%{hub__alx_version}
%doc %{hub__root}/share/doc/alex-%{hub__alx_version}


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed Oct 12 2011 Chris Dornan <chris@chrisdornan.com>
- start
