

%global hub__local_rev      5
%global debug_package       %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__pr_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Glasgow Haskell Compiler %{hub__ghc} (hub wrapper)
URL:            http://haskell.org/ghc/
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Requires:       %{hub__vc_hc_dist}
Requires:       %{hub__vc_hub}
%{hub__requires_ci014}
%{hub__requires_ci116}
%{hub__requires_ci118}
%{hub__requires_plug}


%description
GHC is a state-of-the-art, open source, compiler and interactive environment
for the functional language Haskell. 

This is a wrapper on the basic GHC distribution package (ghc--%{hub__ghc}-dist)
that integrates it into the Haskell Hub system. 


%install
mkdir -p ${RPM_BUILD_ROOT}%{hub__hub_d}
cat >${RPM_BUILD_ROOT}%{hub__ghc_hub} <<EOF
<hub>
  <comnt>GHC %{hub__ghc}</comnt>
  <hcbin>%{hub__ghc_d}/bin</hcbin>
  <glbdb>%{hub__ghc_db}</glbdb>
  %{hub__civrn}
</hub>
EOF


%files
%defattr(-,root,root,-)
%{hub__ghc_hub}


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed Oct 12 2011 Chris Dornan <chris@chrisdornan.com>
- start
