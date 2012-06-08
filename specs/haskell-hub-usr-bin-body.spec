

%global hub__local_rev      4
%global debug_package   %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__pr_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        The Haskell Hub Distribution /usr/bin Presence
URL:            http://hub.justhub.org
License:        BSD3
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}

%{hub__requires_plug}


%description
The Haskell Hub system manages multiple versions of the (Glasgow) Haskell
Compiler and the Haskell Platform and multiple user-package databases, each
selectable statically (through a configuration file in the root of the source
tree) or dynamically (through an environment variable).

This package establishes a Haskell Hub presence in /usr/bin.

%build

mkdir -p ${RPM_BUILD_ROOT}/usr/bin

mk() {
cat >${RPM_BUILD_ROOT}/usr/bin/$1 <<EOF
#!/bin/bash
exec %{hub__bin}/$1 "\$@"
EOF
chmod 755 ${RPM_BUILD_ROOT}/usr/bin/$1
}

mk hub
mk ghc
mk ghci
mk ghc-pkg
mk haddock
mk hp2ps
mk hpc
mk hsc2hs
mk runghc
mk runhaskell
mk cabal
mk alex
mk happy

%files
%defattr(-,root,root,-)
/usr/bin/hub
/usr/bin/ghc
/usr/bin/ghci
/usr/bin/ghc-pkg
/usr/bin/haddock
/usr/bin/hp2ps
/usr/bin/hpc
/usr/bin/hsc2hs
/usr/bin/runghc
/usr/bin/runhaskell
/usr/bin/cabal
/usr/bin/alex
/usr/bin/happy

%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Mon Oct 17 2011 Chris Dornan <chris@chrisdornan.com>
- start
