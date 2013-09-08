

%global hub__local_rev      6
%global debug_package %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__pr_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Haskell Platform (hub wrapper)
URL:            http://hackage.haskell.org/platform/
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Requires:       %{hub__vc_hp_dist}
Requires:       %{hub__vc_hub}
Requires:       %{hub__vc_hc}
%{hub__requires_ci014}
%{hub__requires_ci116}
%{hub__requires_ci118}
%{hub__requires_plug}


%description
The Haskell Platform is a blessed library and tool suite for Haskell
distilled from Hackage.

This wrapper package integrates it into the Haskell Hub system.


%install
mkdir -p ${RPM_BUILD_ROOT}%{hub__hub_d}
cat >${RPM_BUILD_ROOT}%{hub__hp_hub} <<EOF
<hub>
  <comnt>Haskell Platform %{hub__hp}</comnt>
  <hcbin>%{hub__ghc_d}/bin</hcbin>
  <glbdb>%{hub__hp_db}</glbdb>
  %{hub__civrn}
</hub>
EOF


%files
%defattr(-,root,root,-)
%{hub__hp_hub}


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed Oct 12 2011 Chris Dornan <chris@chrisdornan.com>
- start
