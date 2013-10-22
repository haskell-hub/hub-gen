

%global hub__local_rev      9
%global debug_package %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__pr_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        ghc-7.6.3/cabal-install-1.18 hub
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Requires:       ghc-7.6.3-dist
Requires:       haskell-hub-cabal-install-118

%{hub__requires_plug}


%description
Combines GHC-7.6.3 and cabal-install 1.18

%build
%global hub__nm 7.6.3-1.18
%global hub__pd $(pwd)/%{hub__nm}.d
cp -a /usr/hs/db/7.6.3.d %{hub__pd}
PATH=/usr/hs/gcc/bin:/usr/hs/binutils/bin:/usr/hs/ghc/7.6.3/bin:/usr/hs/tools:${PATH}
cabal-1.16.0.2 --package-db=%{hub__pd} --prefix=/usr/hs/ghc/7.6.3-1.18 install Cabal-1.18.1.1

%install
mkdir -p ${RPM_BUILD_ROOT}/usr/hs/ghc
cp -a /usr/hs/ghc/7.6.3-1.18 ${RPM_BUILD_ROOT}/usr/hs/ghc/7.6.3-1.18
mkdir -p ${RPM_BUILD_ROOT}%{hub__db_d}
cp -a %{hub__pd} ${RPM_BUILD_ROOT}%{hub__db_d}/%{hub__nm}.d
mkdir -p ${RPM_BUILD_ROOT}%{hub__hub_d}
cat >${RPM_BUILD_ROOT}%{hub__hub_d}/%{hub__nm}.xml <<EOF
<hub>
  <comnt>GHC 7.6.3 with Cabal 1.18</comnt>
  <hcbin>/usr/hs/ghc/7.6.3/bin</hcbin>
  <glbdb>/usr/hs/db/7.6.3-1.18.d</glbdb>
  <civrn>1.18.0.1</civrn>
</hub>
EOF

%post
GHC_PACKAGE_PATH=%{hub__db_d}/%{hub__nm}.d /usr/hs/ghc/7.6.3/bin/ghc-pkg recache

%files
%defattr(-,root,root,-)
/usr/hs/ghc/7.6.3-1.18
%{hub__db_d}/%{hub__nm}.d
%{hub__hub_d}/%{hub__nm}.xml

%changelog

* Wed Oct 20 2013 Chris Dornan <chris@chrisdornan.com>
- start
