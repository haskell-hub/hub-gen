

%global hub__local_rev      4
%global debug_package   %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__hs_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Plug to remove all of the Haskell Hub packages
URL:            http://hub.justhub.org
License:        BSD3
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}

%{hub__requires_plug}


%description
The Haskell Hub system manages multiple versions of the Glasgow Haskell
Compiler (GHC) and the Haskell Platform and multiple user-package databases.

This is a psuedo package on which all of the other packages depend: remove
this package to remove all of the others.


%install


%files

%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed May 16 2012 Chris Dornan <chris@chrisdornan.com>
- start
