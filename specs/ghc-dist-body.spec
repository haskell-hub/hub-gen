

%global hub__make_ji        -j8


%global hub__local_rev      4
%global debug_package       %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__hc_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        Glasgow Haskell Compiler (hub distribution)
Source0:        http://www.haskell.org/ghc/dist/%{hub__ghc}/ghc-%{hub__ghc}-src.tar.bz2
URL:            http://haskell.org/ghc/
License:        BSD3
ExclusiveArch:  %{hub__xarch}
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
BuildRequires:  gmp-devel
Requires:       gmp-devel
BuildRequires:  ncurses-devel
BuildRequires:  libxslt, docbook-style-xsl
BuildRequires:  docbook-utils, docbook-utils-pdf, docbook-style-xsl
Requires:       %{hub__vc_gcc}
Requires:       binutils-devel

%{hub__requires_plug}


%description
GHC is a state-of-the-art, open source, compiler and interactive environment
for the functional language Haskell. Highlights:

- GHC supports the entire Haskell 2010 language plus various extensions.
- GHC has particularly good support for concurrency and parallelism,
  including support for Software Transactional Memory (STM).
- GHC generates fast code, particularly for concurrent programs
  (check the results on the "Computer Language Benchmarks Game").
- GHC works on several platforms including Windows, Mac, Linux,
  most varieties of Unix, and several different processor architectures.
- GHC has extensive optimisation capabilities,
  including inter-module optimisation.
- GHC compiles Haskell code either directly to native code or using LLVM
  as a back-end. GHC can also generate C code as an intermediate target for
  porting to new platforms. The interactive environment compiles Haskell to
  bytecode, and supports execution of mixed bytecode/compiled programs.
- Profiling is supported, both by time/allocation and heap profiling.
- GHC comes with core libraries, and thousands more are available on Hackage.


%prep
%setup -q -n ghc-%{hub__ghc}


%build


dblatex --version

HsColour --version
echo ""


unset GHC_PACKAGE_PATH
hub init -n %{hub__ghc} || echo "failed to set a hub: usimng defauilt GHC"

[ %{hub__own_tools} = 1 ] && PATH=%{hub__gcc_bin}:%{hub__bnu_bin}:${PATH}

hub info
./configure --prefix=%{hub__ghc_d} %{hub__with_gcc}

%if %{defined hub__make_ji}
    hub__make_ji=%{hub__make_ji}
%endif
make ${hub__make_ji}


%install
make DESTDIR=${RPM_BUILD_ROOT} install
hub rm $(hub set) || true
hub set -         || true

%if %{defined hub__old_packages}

rm -f ${RPM_BUILD_ROOT}/%{hub__ghc_d}/bin/ghc-pkg
cat >${RPM_BUILD_ROOT}/%{hub__ghc_d}/bin/ghc-pkg <<EOF
#!/bin/sh

if   [ "\$1"x = recachex              ]; then
    exit 0
elif [ "\$1"x = initx    -a \$# -eq 2 ]; then
    echo "[]" >\$2
else
    exec %{hub__ghc_d}/bin/ghc-pkg-6.10.4 "\$@"
fi
EOF
chmod +x ${RPM_BUILD_ROOT}/%{hub__ghc_d}/bin/ghc-pkg

%endif


cat >${RPM_BUILD_ROOT}/%{hub__ghc_d}/bin/which-build-compiler.sh <<EOF
#!/bin/bash
echo Built with: `ghc --version`
EOF
chmod +x ${RPM_BUILD_ROOT}/%{hub__ghc_d}/bin/which-build-compiler.sh

mkdir -p ${RPM_BUILD_ROOT}/%{hub__db_d}
rm -rf ${RPM_BUILD_ROOT}/%{hub__ghc_db}
cp -a ${RPM_BUILD_ROOT}/%{hub__ghc_pkg_db} ${RPM_BUILD_ROOT}/%{hub__ghc_db}


%post
%{hub__ghc_d}/bin/ghc-pkg recache
GHC_PACKAGE_PATH=%{hub__ghc_db} %{hub__ghc_d}/bin/ghc-pkg recache


%files
%defattr(-,root,root,-)
%{hub__ghc_d}/bin
%{hub__ghc_d}/lib
%doc %{hub__ghc_d}/share
%{hub__ghc_db}

%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Tue Sep 13 2011 Chris Dornan <chris@chrisdornan.com>
- start
