

%global hub__local_rev      4
%global debug_package       %{nil}


%global hub__fedora_ghc     7.0.4
%global hub__the_lib        /usr/lib64
%global hub__ghc_fedora     %{hub__fedora_ghc}-fedora
%global hub__fedora_ghc_d   /usr/hs/ghc/%{hub__ghc_fedora}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__pr_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Haskell Hub for Fedora GHC-%{hub__fedora_ghc}
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Requires:       ghc == %{hub__fedora_ghc}
Requires:       %{hub__vc_hub}

%{hub__requires_plug}

%description
GHC is a state-of-the-art, open source, compiler and interactive environment
for the functional language Haskell. 

This package connects the Fedora GHC distribution into the Haskell Hub
framework.


%install
mkdir -p ${RPM_BUILD_ROOT}%{hub__hub_d}
cat >${RPM_BUILD_ROOT}%{hub__hub_d}/%{hub__ghc_fedora}.xml <<EOF
<hub>
  <comnt>Fedora GHC %{hub__fedora_ghc}</comnt>
  <hcbin>%{hub__fedora_ghc_d}/bin</hcbin>
  <glbdb>%{hub__the_lib}/ghc-%{hub__fedora_ghc}/package.conf.d</glbdb>
</hub>
EOF

mkdir -p ${RPM_BUILD_ROOT}%{hub__lib}
cat >${RPM_BUILD_ROOT}%{hub__lib}/distro-default.hub <<EOF
%{hub__ghc_fedora}
EOF


%post

mkdir -p %{hub__fedora_ghc_d}/bin
cd %{hub__fedora_ghc_d}/bin

mkv() { rm -f $1; ln -s /usr/bin/$1-%{hub__fedora_ghc} $1; }
mk()  { rm -f $1; ln -s /usr/bin/$1                    $1; }

mkv ghc
mkv ghci
mkv ghc-pkg
mk  hp2ps
mk  hpc
mk  hsc2hs
mk  runghc
mk  runhaskell


%preun

cd %{hub__fedora_ghc_d}/bin
rm -f ghc
rm -f ghci
rm -f ghc-pkg
rm -f hp2ps
rm -f hpc
rm -f hsc2hs
rm -f runghc
rm -f runhaskell
rmdir --ignore-fail-on-non-empty %{hub__fedora_ghc_d}/bin
rmdir --ignore-fail-on-non-empty %{hub__fedora_ghc_d}


%files
%defattr(-,root,root,-)
%{hub__hub_d}/%{hub__ghc_fedora}.xml
%{hub__lib}/distro-default.hub


%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Wed Oct 12 2011 Chris Dornan <chris@chrisdornan.com>
- start
