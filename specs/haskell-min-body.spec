

%global hub__local_rev      4
%global debug_package   %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__hs_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        The Haskell Hub Distribution Meta Package
URL:            http://hub.justhub.org
License:        BSD3
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Requires:       %{hub__vc_hp_current}
Requires:       %{hub__vc_binutils}
Requires:       glibc-devel

%{hub__requires_plug}


%description
The Haskell Hub manages multiple versions of the (Glasgow) Haskell Compiler
and the Haskell Platform and multiple user-package databases, each selectable
statically (through a configuration file in the root of the source tree)
or dynamically (through an environment variable).

This Virtual package selects the latest Haskell Platform for installation:

    Haskell Platform %{hub__hp_current} using GHC %{hub__ghc_current} 

This package by itself does not place the utilities in /usr/bin: install
the haskell package if you need a /usr/bin presence.


%install

mkdir -p ${RPM_BUILD_ROOT}%{hub__lib}

cat >${RPM_BUILD_ROOT}%{hub__lib}/version.txt <<EOF
    with haskell-hub-%{hub__pr_version}
        promoting GHC %{hub__ghc_current}
        and the Haskell Plaform %{hub__hp_current}
EOF

cat >${RPM_BUILD_ROOT}%{hub__lib}/sys-default.hub <<EOF
%{hub__hp_current}
EOF


%files
%defattr(-,root,root,-)
%{hub__lib}/version.txt
%{hub__lib}/sys-default.hub

%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Mon Oct 17 2011 Chris Dornan <chris@chrisdornan.com>
- start
