

%global hub__local_rev      4
%global debug_package       %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__gc_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Reference GCC for GHC to use 
Source0:        %{hub__gcc_tarball}
URL:            http://gcc.gnu.org/
License:        GPL, LGPL
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}

%{hub__requires_plug}


%description
A GCC distribution ({%hub__gcc_version}) suitable for use with GHC. It is
part of the Haskell Hub distribution.

%prep
%setup -q -n gcc-%{hub__gcc_version}


%build
./configure --prefix=%{hub__gcc_d} --enable-languages="c"
make


%install
make install DESTDIR=$RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%{hub__gcc_d}


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Thu Sep 15 2011 Chris Dornan <chris@chrisdornan.com>
- start
