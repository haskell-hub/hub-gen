--
-- >>> HubGen.Package <<<
--
-- The central module, defining the packages that make up the archive and the
-- arguments to the spec files that generate them.
--
-- (c) 2011-2012 Chris Dornan


module HubGen.Package
    ( Package(..)
    , PackageName
    , packageNames
    , lookupPackage
    , mkMacros
    -- new
    , packageName
    , PkgID(..)
    , FxPkgID(..)
    , RpmMacro(..)
    , FxRpmMacro(..)
    , VcRpmMacro(..)
    , CpRpmMacro(..)
    ) where

import           Data.Char
import           Text.Printf
import           Data.Map(Map)
import qualified Data.Map       as Map
import           HubGen.Params



-- Package contain all the information needed to build a package/

data Package = PKG
    { namePKG :: PkgID                  -- the package ID
    , specPKG :: FilePath               -- the name of the SPEC file template
    , prmsPKG :: Map String String      -- the SPEC file macro definitions
    }                                                           deriving (Eq,Show)


type PackageName = String


packageNames :: Params -> [PackageName]
packageNames = map packageName . Map.keys . packages

lookupPackage :: Params -> PackageName -> Maybe Package
lookupPackage pms pnm =
     do pid <- lu_pid pnm
        Map.lookup pid $ packages pms

packages :: Params -> Map PkgID Package
packages pms = Map.fromList
        [ (namePKG pkg,pkg) |
            pkg<-map (gen_package pms) (filter (package_live pms) package_ids) ]


mkMacros :: FilePath -> Params -> Package -> String
mkMacros cwd pms pkg = hdr ++ foldr f ftr (br_p:(Map.toList $ prmsPKG pkg))
      where
        f (ide,rhs) rst = case rhs of
                            "" -> rst
                            _  -> def ide rhs rst

        def ide rhs rst = printf "%%global %-17s %s\n%s" ide rhs rst
        hdr             = printf "\n# Parameters from %s\n\n" $ prog_namePMS pms
        ftr             =        "\n\n"

        br_p            = (,) "hub__buildroot" cwd

packageName :: PkgID -> PackageName
packageName pid =
        case pid of
          FxPID fid    -> fx_package_name fid
          HcPID ih hcv -> hc_package_name ih hcv
          HpPID ih hpv -> hp_package_name ih hpv

-- A PkgID identifies a package

data PkgID
    = FxPID FxPkgID     -- one of the 'fixed' packages
    | HcPID Bool HCV    -- a GHC 'hub' or 'dist' package: True => Hub Package
    | HpPID Bool HPV    -- an HP 'hub' or 'dist' package: Fale => Dist Package
                                                         deriving (Eq,Ord,Show)

data FxPkgID
    = Haskell
    | Haskell_min
    | Haskell_hub
    | Haskell_hub_usr_bin
    | Haskell_hub_cabal_install
    | Haskell_hub_cabal_install_014
    | Haskell_hub_alex
    | Haskell_hub_happy
    | Haskell_hub_gcc
    | Haskell_hub_binutils
    | Fedora_hub
    | Justhub_release
    | Haskell_hub_plug
                                            deriving (Eq,Ord,Bounded,Enum,Show)



-- RpmMacro identifies the macro parameters of the SPEC file templates

data RpmMacro
     = FxRM FxRpmMacro                  -- the 'fixed' macros
     | VcRM VcRpmMacro                  -- the 'version control' macros
     | CpRM CpRpmMacro                  -- the 'GHC/Platfrom' macros
                                                                deriving (Show)

data FxRpmMacro
    = HUB__package_name
    | HUB__repo_name
    | HUB__repo_url
    | HUB__ghc_current
    | HUB__hp_current
    | HUB__hs_version
    | HUB__pr_version
    | HUB__hc_version
    | HUB__hp_version
    | HUB__tl_version
    | HUB__gc_version
    | HUB__bu_version
    | HUB__distro_tag
    | HUB__dist
    | HUB__repo_package
    | HUB__cid_version
    | HUB__cid_tarball
    | HUB__c14_version
    | HUB__c14_tarball
    | HUB__alx_version
    | HUB__alx_tarball
    | HUB__hpy_version
    | HUB__hpy_tarball
    | HUB__hub_version
    | HUB__hub_tarball
    | HUB__gcc_version
    | HUB__gcc_tarball
    | HUB__binutils_version
    | HUB__binutils_tarball
    | HUB__own_tools
    | HUB__with_plug
    | HUB__real_ghc
    | HUB__make_ji
                                            deriving (Eq,Ord,Bounded,Enum,Show)

data VcRpmMacro
    = HUB__vc_haskell_min
    | HUB__vc_hub
    | HUB__vc_ubin
    | HUB__vc_cabal
    | HUB__vc_cabal_014
    | HUB__vc_alex
    | HUB__vc_happy
    | HUB__vc_gcc
    | HUB__vc_binutils
    | HUB__vc_hc
    | HUB__vc_hc_dist
    | HUB__vc_hp
    | HUB__vc_hp_dist
    | HUB__vc_hp_current
                                            deriving (Eq,Ord,Bounded,Enum,Show)

data CpRpmMacro
    = HUB__ghc
    | HUB__hp
    | HUB__old_packages
    | HUB__libedit
    | HUB__hub_ci014
                                            deriving (Eq,Ord,Bounded,Enum,Show)



package_live :: Params -> PkgID -> Bool
package_live pms pid =
        case pid of
          FxPID Haskell_hub_gcc       -> not fdr
          FxPID Haskell_hub_binutils  -> not fdr
          FxPID Fedora_hub            -> fdr
          _                           -> True
      where
        fdr =   case distribtnPMS pms of
                  El5  -> False
                  El6  -> False
                  Fc16 -> True
                  Fc17 -> True

lu_pid :: PackageName -> Maybe PkgID
lu_pid = flip Map.lookup package_name_map

package_name_map :: Map PackageName PkgID
package_name_map = Map.fromList [ (packageName pid,pid) | pid<-package_ids ]

package_ids :: [PkgID]
package_ids = f FxPID $ g HcPID $ g HpPID []
      where
        g k t = f (k False) $ f (k True) t

        f k t = foldr (\i u->k i:u) t [minBound..maxBound]

fx_package_name :: FxPkgID -> String
fx_package_name fid = f_l $ map tr $ show fid
      where
        f_l []     = []
        f_l (c:cs) = toLower c : cs

        tr '_'   = '-'
        tr '\''  = '.'
        tr c     = c

hc_package_name :: Bool -> HCV -> String
hc_package_name ih hcv = printf "ghc-%s-%s" hcs h_d
      where
        hcs = hcv2str hcv
        h_d = if ih then "hub" else "dist"

hp_package_name :: Bool -> HPV -> String
hp_package_name ih hpv = printf "haskell-platform-%s-%s" hps h_d
      where
        hps = hpv2str hpv
        h_d = if ih then "hub" else "dist"


macro_ids :: [RpmMacro]
macro_ids = f FxRM $ f VcRM $ f CpRM []
      where
        f k t = foldr (\i u->k i:u) t [minBound..maxBound]

macro_name :: RpmMacro -> String
macro_name ri =
        case ri of
          FxRM fx_ri -> macro_name_ fx_ri
          VcRM vc_ri -> macro_name_ vc_ri
          CpRM cp_ri -> macro_name_ cp_ri
      where
        macro_name_ x = "hub" ++ drop 3 (show x)





gen_package :: Params -> PkgID -> Package
gen_package pms pid = PKG pid (spec_name pid) $
        Map.fromList [ (macro_name mi,gen_macro pms pid mi) | mi<-macro_ids ]

spec_name :: PkgID -> FilePath
spec_name pid = printf "%s-body.spec" stm
      where
        stm =   case pid of
                  FxPID _       -> packageName pid
                  HcPID True  _ -> "ghc-hub"
                  HcPID False _ -> "ghc-dist"
                  HpPID True  _ -> "haskell-platform-hub"
                  HpPID False _ -> "haskell-platform-dist"

gen_macro :: Params -> PkgID -> RpmMacro -> String
gen_macro pms pid rm =
        case rm of
          FxRM frm -> gen_fx_mac pms pid frm
          VcRM vrm -> gen_vc_mac pms pid vrm
          CpRM crm -> gen_cp_mac pms pid crm

gen_fx_mac :: Params -> PkgID -> FxRpmMacro -> String
gen_fx_mac pms pid frm =
        case frm of
          HUB__package_name     ->               packageName pid
          HUB__repo_name        ->              repo_namePMS pms
          HUB__repo_url         ->              repo_url_PMS pms
          HUB__ghc_current      -> shhc      $  hp_crrentPMS pms
          HUB__hp_current       -> shhp      $  hp_crrentPMS pms
          HUB__hs_version       -> show      $  hs_vrsionPMS pms
          HUB__pr_version       -> show      $  pr_vrsionPMS pms
          HUB__hc_version       -> show      $  hc_vrsionPMS pms
          HUB__hp_version       -> show      $  hp_vrsionPMS pms
          HUB__tl_version       -> show      $  tl_vrsionPMS pms
          HUB__gc_version       -> show      $  gc_vrsionPMS pms
          HUB__bu_version       -> show      $  bu_vrsionPMS pms
          HUB__distro_tag       -> distroTag $  distribtnPMS pms
          HUB__dist             ->                   distPMS pms
          HUB__repo_package     ->              repo_pakgPMS pms
          HUB__cid_version      ->              cid_versnPMS pms
          HUB__cid_tarball      ->              cid_tarblPMS pms
          HUB__c14_version      ->              c14_versnPMS pms
          HUB__c14_tarball      ->              c14_tarblPMS pms
          HUB__alx_version      ->              alx_versnPMS pms
          HUB__alx_tarball      ->              alx_tarblPMS pms
          HUB__hpy_version      ->              hpy_versnPMS pms
          HUB__hpy_tarball      ->              hpy_tarblPMS pms
          HUB__hub_version      ->              hub_versnPMS pms
          HUB__hub_tarball      ->              hub_tarblPMS pms
          HUB__gcc_version      ->              gcc_versnPMS pms
          HUB__gcc_tarball      ->              gcc_tarblPMS pms
          HUB__binutils_version ->              bnu_versnPMS pms
          HUB__binutils_tarball ->              bnu_tarblPMS pms
          HUB__own_tools        -> bool      $  own_toolsPMS pms
          HUB__with_plug        -> ifdf                     True
          HUB__real_ghc         ->                          rghc
          HUB__make_ji          ->              makejparmPMS pms
      where
        shhc = hcv2str . hpv2hcv
        shhp = hpv2str
        bool = \b -> if b then "1" else "0"
        ifdf = \b -> if b then "1" else ""

        rghc = case pid of
                 HcPID _ hcv -> realGHC   hcv
                 HpPID _ hpv -> realGHC $ hpv2hcv hpv
                 _           -> ""

distPMS :: Params -> String
distPMS pms = printf "%d.%s" (gn_revisnPMS pms) (distroTag $ distribtnPMS pms)

gen_vc_mac :: Params -> PkgID -> VcRpmMacro -> String
gen_vc_mac pms pid vrm =
        case vrm of
          HUB__vc_haskell_min   -> vcm   Haskell_min                hs_vrsionPMS
          HUB__vc_hub           -> vcm   Haskell_hub                pr_vrsionPMS
          HUB__vc_ubin          -> vcm   Haskell_hub_usr_bin        pr_vrsionPMS
          HUB__vc_cabal         -> vcm   Haskell_hub_cabal_install  tl_vrsionPMS
          HUB__vc_cabal_014     -> vcm   Haskell_hub_cabal_install_014 tl_vrsionPMS
          HUB__vc_alex          -> vcm   Haskell_hub_alex           tl_vrsionPMS
          HUB__vc_happy         -> vcm   Haskell_hub_happy          tl_vrsionPMS
          HUB__vc_gcc           -> vcm_g Haskell_hub_gcc            gc_vrsionPMS
          HUB__vc_binutils      -> vcm_b Haskell_hub_binutils       bu_vrsionPMS
          HUB__vc_hc            -> vcm_h (HcPID True )              pr_vrsionPMS
          HUB__vc_hc_dist       -> vcm_h (HcPID False)              hc_vrsionPMS
          HUB__vc_hp            -> vcm_p (HpPID True )              pr_vrsionPMS
          HUB__vc_hp_dist       -> vcm_p (HpPID False)              hp_vrsionPMS
          HUB__vc_hp_current    -> vcm'  (HpPID True  hpc)          pr_vrsionPMS
      where
        vcm_g       = vcm_t "gcc"
        vcm_b       = vcm_t "binutils"

        vcm_t s p k = case own_toolsPMS pms of
                          True  -> vcm p k
                          False -> s

        vcm_h   p k  = vcm' (p hcv) k
        vcm_p   p k  = vcm' (p hpv) k

        vcm     p k  = vcm' (FxPID p) k

        vcm'         :: PkgID -> (Params->Int) -> String
        vcm'    q k  = printf "%s >= %d, %s < %d" nm (k pms) nm (k pms + 1)
                          where
                            nm = packageName q

        hpc          = hp_crrentPMS pms

        (hcv,hpv)    = case pid of
                         FxPID _      -> (minBound    ,minBound)
                         HcPID _ hcv_ -> (hcv_        ,minBound)
                         HpPID _ hpv_ -> (hpv2hcv hpv_,hpv_    )

gen_cp_mac :: Params -> PkgID -> CpRpmMacro -> String
gen_cp_mac _ pid crm =
        case crm of
          HUB__ghc              -> fx_nil   hc_s
          HUB__hp               -> fx_nil   hp_s
          HUB__old_packages     -> fx_nul $ flg op
          HUB__libedit          -> fx_nul $ flg le
          HUB__hub_ci014        -> flg    $ c014_hub pid
      where
        flg b      = if b then "1" else ""

        (hp_s,le)  = either hc hp ei

        hc _       = ("%{nil}"   ,False     )

        hp hpv     = (hpv2str hpv,tst_le hpv)

        hc_s       = hcv2str hcv_
        op         = tst_op  hcv_

        -- if no HP version then pick arbitrary (minimum) hpv_
        --       on the assumption it shouldn't be needed

        hcv_       = either id             hpv2hcv ei

        tst_op hcv = hcv <  HCV_6_12_1
        tst_le _   = False -- hpv <= HPV_2009_2_0_2

        fx_nil r   = if fx then "%{nil}" else r
        fx_nul r   = if fx then ""       else r

        (fx,ei)    = case pid of
                       FxPID _     -> (True ,Left  minBound)
                       HcPID _ hcv -> (False,Left  hcv     )
                       HpPID _ hpv -> (False,Right hpv     )

c014_hub :: PkgID -> Bool
c014_hub pid = case pid of
                 HcPID _ hcv -> hcv >= HCV_7_4_1
                 HpPID _ hpv -> hpv >= HPV_2012_2_0_0
                 _           -> False


--
-- Spec File Template Filename Stems
--

