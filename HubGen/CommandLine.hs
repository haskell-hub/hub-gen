--
-- >>> HubGen.CommandLine <<<
--
-- Parse the command line and generate --help.
--
-- (c) 2011-2012 Chris Dornan


module HubGen.CommandLine
    ( CommandLine(..)
    , ShowType(..)
    , commandLine
    ) where

import           Data.List
import           System.Environment
import           Text.Printf
import           HubGen.Params
import           HubGen.Package



data CommandLine
    = ReportCL String
    | CheckCL
    | BuildCL  (Maybe ShowType) Bool Package
    | ErrorCL  String
                                                                deriving (Show)
data ShowType
    = PrmsST
    | HeadST
    | SpecST
                                                                deriving (Show)

commandLine :: Params -> IO CommandLine
commandLine pms = command_line pms
    [ help_cl
    , version_cl
    , list_cl
    , hub_vrn_cl
    , hub_tbl_cl
    , check_cl
    , build_cl
    ]



type Ctx = (Params,PackageName->Maybe Package)



help_cl, version_cl, list_cl, hub_vrn_cl, hub_tbl_cl, check_cl,
                            build_cl :: Ctx -> [String] -> Maybe CommandLine

help_cl     ctx  args = case args of
                          ["--help"]        -> Just $ ReportCL $ usage_str         ctx
                          _                 -> Nothing

version_cl  ctx  args = case args of
                          ["--version"]     -> Just $ ReportCL $ version_str       ctx
                          _                 -> Nothing

list_cl     ctx  args = case args of
                          ["--list"]        -> Just $ ReportCL $ list_packages     ctx
                          _                 -> Nothing

hub_vrn_cl  ctx  args = case args of
                          ["--hub-version"] -> Just $ ReportCL $ hub_versnPMS (fst ctx) ++"\n"
                          _                 -> Nothing

hub_tbl_cl  ctx  args = case args of
                          ["--hub-tarball"] -> Just $ ReportCL $ hub_tarblPMS (fst ctx) ++"\n"
                          _                 -> Nothing
check_cl    _    args = case args of
                          ["--check-repo"]  -> Just   CheckCL
                          _                 -> Nothing

build_cl    ctx  args = build_args ctx (Nothing,True) args


build_args :: Ctx -> (Maybe ShowType,Bool) -> [String] -> Maybe CommandLine
build_args _   _       []         = Nothing
build_args ctx (nb,ns) (arg:args) =
        case arg of
          "--show-params" -> build_args ctx (Just PrmsST,ns   ) args
          "--show-header" -> build_args ctx (Just HeadST,ns   ) args
          "--show-spec"   -> build_args ctx (Just SpecST,ns   ) args
          "--sign"        -> build_args ctx (nb         ,False) args
          _               -> BuildCL nb ns `fmap` snd ctx arg

version_str :: Ctx -> String
version_str (pms,_) = unlines
    [ printf "%s for Haskell %d"                        prg vrn
    , printf "    Hub       RPM version : %d"           prv
    , printf "      Hub vrn             : %s"           hbv
    , printf "      Hub src             : %s"           hbs
    , printf "    Tools     RPM version : %d"           tlv
    , printf "      Cabal Install vrn   : %s"           civ
    , printf "      Cabal Install src   : %s"           cis
    , printf "      Alex          vrn   : %s"           axv
    , printf "      Alex          src   : %s"           axs
    , printf "      Happy         vrn   : %s"           hyv
    , printf "      Happy         src   : %s"           hys
    , printf "    GHC       RPM Version : %d"           hcv
    , printf "    HP        RPM Version : %d"           hpv
    , printf "    GCC       RPM Version : %d"           gpv
    , printf "      GCC           vrn   : %s"           gcv
    , printf "      GCC           src   : %s"           gcs
    , printf "    Binutils  RPM Version : %d"           bpv
    , printf "      GCC           vrn   : %s"           buv
    , printf "      GCC           src   : %s"           bus
    , printf "    General Revision #    : %d"           grv
    , printf "    Distribution          : %s for %s"    eld rpo
    ]
      where
        eld       = distroTag    dst

        prg       = prog_namePMS pms
        vrn       = hs_vrsionPMS pms
        prv       = pr_vrsionPMS pms
        hbv       = hub_versnPMS pms
        hbs       = hub_tarblPMS pms
        tlv       = tl_vrsionPMS pms
        civ       = cid_versnPMS pms
        cis       = cid_tarblPMS pms
        axv       = alx_versnPMS pms
        axs       = alx_tarblPMS pms
        hyv       = hpy_versnPMS pms
        hys       = hpy_tarblPMS pms
        hcv       = hc_vrsionPMS pms
        hpv       = hp_vrsionPMS pms
        gpv       = gc_vrsionPMS pms
        gcv       = gcc_versnPMS pms
        gcs       = gcc_tarblPMS pms
        bpv       = bu_vrsionPMS pms
        buv       = bnu_versnPMS pms
        bus       = bnu_tarblPMS pms
        dst       = distribtnPMS pms
        grv       = gn_revisnPMS pms
        rpo       = repo_pakgPMS pms

list_packages :: Ctx -> String
list_packages (pms,_) = unlines $ sort $ packageNames pms

command_line :: Params -> [Ctx->[String]->Maybe CommandLine] -> IO CommandLine
command_line pms l =
     do args <- getArgs
        case [ cl | Just cl <- map (\f->f ctx args) l ] of
          []   -> return $ ErrorCL $ usage_str ctx
          cl:_ -> return   cl
      where
        ctx  = (pms,lookupPackage pms)

usage_str :: Ctx -> String
usage_str (pms,_) = unlines
        [ prg ++ " --help"
        , ldr ++ " --version"
        , ldr ++ " --list"
        , ldr ++ " --hub-version"
        , ldr ++ " --hub-tarball"
        , ldr ++ "[--show-params|--show-header|--show-spec|--sign] <package>"
        ]
      where
        ldr = map (const ' ') prg
        prg = prog_namePMS pms
