
#
# standard RPM macros
#

#
# The following macros are set according to the version of GHC and
# Haskell Platform concerned. (If a Haskell Platform package is being
# built then hub__ghc is set to the version of GHC that the platform
# uses. For all non-H.P. packages hub__hp is set to %{nil}. For all
# non-GHC, non-H.P. packages, hub__ghc and hub__hp are set to %{nil}.
#
# hub__ghc => GHC Version              (e.g., 7. 0. 3   )
# hub__hp  => Haskell Platform Version (e.g., 2011.2.0.1)
# 
# The macro hub__old_packages will be defined iff the GHC uses the old
# package.conf package management (i.e., GHC 6.10.*).
#
# hub__own_tools => using gcc/ld in /usr/hs [0/1]


%global hub__xarch              %{ix86} x86_64
%global hub__group              Development/Languages
%global hub__vendor             mail@justhub.org
%global hub__packager           http://justhub.org


%global hub__root               /usr/hs
%global hub__bin                %{hub__root}/bin
%global hub__lib                %{hub__root}/lib
%global hub__tools              %{hub__root}/tools
%global hub__doc                %{hub__root}/doc
%global hub__ghc_ud             %{hub__root}/ghc
%global hub__ghc_d              %{hub__root}/ghc/%{hub__ghc}
%global hub__hp_ud              %{hub__root}/hp
%global hub__hp_d               %{hub__root}/hp/%{hub__hp}
%global hub__hub_d              %{hub__root}/hub
%global hub__db_d               %{hub__root}/db
%global hub__ghc_hub            %{hub__hub_d}/%{hub__ghc}.xml
%global hub__hp_hub             %{hub__hub_d}/%{hub__hp}.xml
%global hub__ghc_pkg            %{hub__db_d}/%{hub__ghc}
%global hub__hp_pkg             %{hub__db_d}/%{hub__hp}
%global hub__ghc_lib            %{hub__ghc_d}/lib/ghc-%{hub__real_ghc}
%global hub__ghc_pkg_pkg        %{hub__ghc_lib}/package.conf
%global hub__gcc_d              %{hub__root}/gcc
%global hub__binutils_d         %{hub__root}/binutils


%if %{defined hub__old_packages}

%global hub__ghc_db             %{hub__ghc_pkg}
%global hub__hp_db              %{hub__hp_pkg}
%global hub__ghc_pkg_db         %{hub__ghc_pkg_pkg}

%else

%global hub__ghc_db             %{hub__ghc_pkg}.d
%global hub__hp_db              %{hub__hp_pkg}.d
%global hub__ghc_pkg_db         %{hub__ghc_pkg_pkg}.d

%endif


%if %{hub__own_tools}
%global hub__gcc_bin            %{hub__gcc_d}/bin
%global hub__bnu_bin            %{hub__binutils_d}/bin
%else
%global hub__gcc_bin            /usr/bin
%global hub__bnu_bin            /usr/bin
%endif

%if %{defined hub__with_plug}
%global hub__requires_plug      Requires: haskell-hub-plug
%else
%global hub__requires_plug      %{nil}
%endif


%global hub__civrn              %{nil}
%if %{defined hub__hub_ci010}
%global hub__requires_ci010     Requires: %{hub__vc_cabal_010}
%global hub__civrn              <civrn>%{hub__c10_version}</civrn>
%else
%global hub__requires_ci010     %{nil}
%endif
%if %{defined hub__hub_ci014}
%global hub__requires_ci014     Requires: %{hub__vc_cabal_014}
%global hub__civrn              <civrn>%{hub__c14_version}</civrn>
%else
%global hub__requires_ci014     %{nil}
%endif
%if %{defined hub__hub_ci116}
%global hub__requires_ci116     Requires: %{hub__vc_cabal_116}
%global hub__civrn              <civrn>%{hub__c16_version}</civrn>
%else
%global hub__requires_ci116     %{nil}
%endif
%if %{defined hub__hub_ci118}
%global hub__requires_ci118     Requires: %{hub__vc_cabal_118}
%global hub__civrn              <civrn>%{hub__c18_version}</civrn>
%else
%global hub__requires_ci118     %{nil}
%endif

%global hub__with_gcc           --with-gcc=%{hub__gcc_bin}/gcc


%global hub__setup              %{hub__buildroot}/libexec/prep_build.sh

%global hub__verify_source()    ( cd %{hub__buildroot}/rpmbuild/SOURCES && \
                                    sha1sum --check %{1}.SHA1 )


#
# the RPM specfile proper
#
