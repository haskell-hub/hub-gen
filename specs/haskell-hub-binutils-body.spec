

%global hub__local_rev      4
%global debug_package       %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__bu_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Reference GNU Binutils for GHC to use 
Source0:        %{hub__binutils_tarball}
URL:            http://www.gnu.org/software/binutils/
License:        GPL
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}

%{hub__requires_plug}


%description
A GNU Binutils distribution ({%hub__binutils_version}) suitable for use with
GHC. It is an (optional) part of the Haskell Hub distribution.

%prep
%setup -q -n binutils-%{hub__binutils_version}


%build
./configure --prefix=%{hub__binutils_d} --enable-languages="c"
make


%install
make DESTDIR=${RPM_BUILD_ROOT} install


%files
%defattr(-,root,root,-)
%{hub__binutils_d}


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Sun Oct 23 2011 Chris Dornan <chris@chrisdornan.com>
- start
