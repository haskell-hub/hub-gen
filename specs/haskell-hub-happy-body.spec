

%global hub__local_rev      4
%global debug_package       %{nil}


%global hub__exe            happy
%global hub__pkg            happy
%global hub__pkg_vrn        %{hub__pkg}-%{hub__hpy_version}

%global hub__doc_pkg        %{hub__doc}/%{hub__pkg_vrn}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__tl_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Happy %{hub__hpy_version} for The Haskell Hub
Source0:        %{hub__hpy_tarball}
URL:            http://hackage.haskell.org/package/happy
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}

%{hub__requires_plug}


%description
The Haskell Parser Generator, Happy %{hub__hpy_version}

This package is part of the JustHub distribution.


%prep
%setup -q -n %{hub__pkg_vrn}
%{hub__setup}

hub load build-happy <<EOF
^=7.4.1
mtl-2.1.1
transformers-0.3.0.0
EOF
hub set build-happy
hub comment "for building Happy (%{hub__hpy_version})"


cabal configure --bindir=%{hub__tools} --datadir=%{hub__root}/share 


%build
cabal build


%install
cabal copy --destdir=${RPM_BUILD_ROOT}


%files
%defattr(-,root,root,-)
%{hub__tools}/%{hub__exe}
%{hub__root}/share/happy-%{hub__hpy_version}
%doc %{hub__root}/share/doc/happy-%{hub__hpy_version}


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed Oct 12 2011 Chris Dornan <chris@chrisdornan.com>
- start
