

%global hub__local_rev      9
%global debug_package       %{nil}


Buildroot:      ${RPM_BUILD_ROOT}
Name:           %{hub__package_name}
Version:        %{hub__hs_version}
Release:        %{hub__local_rev}.%{hub__dist}
Summary:        The Haskell Hub Distribution
Source0:        haskell.tar.gz
URL:            http://hub.justhub.org
License:        BSD3
Group:          %{hub__group}
Vendor:         %{hub__vendor}
Packager:       %{hub__packager}
Requires:       %{hub__vc_haskell_min}
Requires:       %{hub__vc_ubin}

%{hub__requires_plug}


%description
The Haskell Hub system manages multiple versions of the Glasgow Haskell
Compiler (GHC) and the Haskell Platform and multiple user-package databases.

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

The Haskell Platform is a blessed library and tool suite for Haskell
distilled from Hackage.

This package includes the latest Haskell Platform:

    Haskell Platform %{hub__hp_current} using GHC %{hub__ghc_current} 

and places the Haskell Hub driver programs in /usr/bin.


%prep
%setup -q -n haskell


%install

# a little naughty, but...

install -D ghc.1.gz ${RPM_BUILD_ROOT}/usr/share/man/man1/ghc.1


%files
/usr/share/man/man1/ghc.1.gz

%changelog

* Fri May 18 2012 Chris Dornan <chris@chrisdornan.com>
- (3) sherkin release

* Mon Oct 17 2011 Chris Dornan <chris@chrisdornan.com>
- start
