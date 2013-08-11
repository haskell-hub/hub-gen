--
-- >>> HubGen.Params <<<
--
-- This module defines that basic parameters of the repository,
-- some of which gets autodetected from the system (such as the
-- O/S) while others get declared here.
--
-- (c) 2011-2012 Chris Dornan


module HubGen.Params
    ( params

    , Params(..)
    , Distro(..)
    , distroTag

    , HCV(..)
    , HPV(..)
    , realGHC
    , hcv2str
    , hpv2str
    , hpv2hcv
    ) where

import           Text.Printf
import           Data.Char
import           Data.List
import qualified Data.ByteString    as B
import qualified Control.Exception  as E



params :: IO Params
params = f `fmap` distro
      where
        f p@(d,_) =
                case d of
                  El5  -> el_params p
                  El6  -> el_params p
                  Fc16 -> fc_params p
                  Fc17 -> fc_params p



--
-- General Parameters
--


data Params = PMS
    { prog_namePMS :: String    -- programme name
    , repo_pakgPMS :: String    -- RPM for installing repo
    , repo_namePMS :: String    -- Name of repository
    , repo_url_PMS :: String    -- URL  of repository
    , hp_crrentPMS :: HPV       -- Current Haskell Platform being promoted
    , hs_vrsionPMS :: Int       -- RPM vrn: Haskell          packages
    , pr_vrsionPMS :: Int       -- RPM vrn: haskell-hub      packages
    , tl_vrsionPMS :: Int       -- RPM vrn: Cabal Install    packages
    , hc_vrsionPMS :: Int       -- RPM vrn: GHC              packages
    , hp_vrsionPMS :: Int       -- RPM vrn: Haskell Platform packages
    , gc_vrsionPMS :: Int       -- RPM vrn: GCC              packages
    , bu_vrsionPMS :: Int       -- RPM vrn: binutils         packages
    , gn_revisnPMS :: Int       -- RPM general revion: all   packages
    , distribtnPMS :: Distro    -- El5, El6, FC16, etc
    , own_toolsPMS :: Bool      -- True => use /usr/hs tools
    , cid_versnPMS :: String    -- Cabal Install version
    , cid_tarblPMS :: FilePath  -- Cabal Install src tarball
    , c14_versnPMS :: String    -- Cabal Install 0.14.x version
    , c14_tarblPMS :: FilePath  -- Cabal Install 0.14.x src tarball
    , alx_versnPMS :: String    -- Alex          version
    , alx_tarblPMS :: FilePath  -- Alex          src tarball
    , hpy_versnPMS :: String    -- Happy         version
    , hpy_tarblPMS :: FilePath  -- Happy         src tarball
    , hub_versnPMS :: String    -- Hub           version
    , hub_tarblPMS :: FilePath  -- Hub           src tarball
    , gcc_versnPMS :: String    -- GCC           version
    , gcc_tarblPMS :: FilePath  -- GCC           source tarball
    , bnu_versnPMS :: String    -- Binutils      version
    , bnu_tarblPMS :: FilePath  -- Binutils      source tarball
    , rpmbuildtPMS :: FilePath  -- path to rpmbuild tree
    , makejparmPMS :: String    -- make -ji flag
    }                                                           deriving (Show)


-- Params for Enterprise Linux Distros


el_params :: (Distro,String) -> Params
el_params (d,j) = PMS
    "mk-hub-rpm"
    "justhub-release"
    "justhub"
    url
    HPV_2012_2_0_0
    1                           -- (Haskell)
    1                           -- (haskell-hub)
    1                           -- (Cabal Install)
    1                           -- (GHC)
    1                           -- (Haskell Platform)
    0                           -- (GCC)
    1                           -- (binutils)
    0                           -- (general revision)
    d
    True
    cid_vr
    cid_tb
    c14_vr
    c14_tb
    alx_vr
    alx_tb
    hpy_vr
    hpy_tb
    hub_vr
    hub_tb
    "4.6.1"
    "gcc-4.6.1-full.tar.bz2"
    "2.21"
    "binutils-2.21.tar.bz2"
    rpb_dr
    j
  where
    url = "http://sherkin.justhub.org/" ++ distroTag d


-- Params for Fedora Core Distros

fc_params :: (Distro,String) -> Params
fc_params (d,j) = PMS
    "mk-hub-rpm"
    "justhub-release"
    "justhub"
    url
    HPV_2012_2_0_0
    1                           -- (Haskell)
    1                           -- (haskell-hub)
    1                           -- (Cabal Install)
    1                           -- (GHC)
    1                           -- (Haskell Platform)
    (-1)                        -- (GCC)
    (-1)                        -- (binutils)
    0                           -- (general revision)
    d
    False
    cid_vr
    cid_tb
    c14_vr
    c14_tb
    alx_vr
    alx_tb
    hpy_vr
    hpy_tb
    hub_vr
    hub_tb
    ""
    ""
    ""
    ""
    rpb_dr
    j
  where
    url = "http://sherkin.justhub.org/" ++ distroTag d



cid_vr, cid_tb, c14_vr, c14_tb, alx_vr, alx_tb, hpy_vr,
                        hpy_tb, hub_vr, hub_tb, rpb_dr :: String

cid_vr =        "0.10.2"
cid_tb = printf "cabal-install-%s.tar.gz" cid_vr
c14_vr =        "0.14.0"
c14_tb = printf "cabal-install-%s.tar.gz" c14_vr
alx_vr =        "3.0.2"
alx_tb = printf "alex-%s.tar.gz"          alx_vr
hpy_vr =        "1.18.9"
hpy_tb = printf "happy-%s.tar.gz"         hpy_vr
hub_vr =        "1.2.0"
hub_tb = printf "hub-%s.tar.gz"           hub_vr
rpb_dr =        "rpmbuild"




--
-- GHC & HP Versions
--


data HCV
 -- = HCV_6_10_1
 -- | HCV_6_10_2
 -- | HCV_6_10_3
    = HCV_6_10_4
    | HCV_6_12_1
    | HCV_6_12_2
    | HCV_6_12_3
    | HCV_7_0_1
    | HCV_7_0_2
    | HCV_7_0_3
    | HCV_7_0_4
    | HCV_7_2_1
    | HCV_7_2_2
    | HCV_7_4_1
    | HCV_7_4_2
    | HCV_7_6_1
    | HCV_7_6_2
    | HCV_7_6_3
 -- | HCV_7_6_1_RC1
 -- | HCV_7_4_2_RC1
                                            deriving (Show,Eq,Ord,Enum,Bounded)

realGHC :: HCV -> String
realGHC hcv = case hcv of
              -- HCV_7_4_2_RC1 -> "7.4.1.20120508"
              -- HCV_7_6_1_RC1 -> "7.6.0.20120810"
                 _             -> hcv2str hcv

hcv2str :: HCV -> String
hcv2str hcv =
    case hcv of
    --HCV_6_10_1    -> "6.10.1"
    --HCV_6_10_2    -> "6.10.2"
    --HCV_6_10_3    -> "6.10.3"
      HCV_6_10_4    -> "6.10.4"
      HCV_6_12_1    -> "6.12.1"
      HCV_6_12_2    -> "6.12.2"
      HCV_6_12_3    -> "6.12.3"
      HCV_7_0_1     -> "7.0.1"
      HCV_7_0_2     -> "7.0.2"
      HCV_7_0_3     -> "7.0.3"
      HCV_7_0_4     -> "7.0.4"
      HCV_7_2_1     -> "7.2.1"
      HCV_7_2_2     -> "7.2.2"
      HCV_7_4_1     -> "7.4.1"
      HCV_7_4_2     -> "7.4.2"
      HCV_7_6_1     -> "7.6.1"
      HCV_7_6_2     -> "7.6.2"
      HCV_7_6_3     -> "7.6.3"
    --HCV_7_6_1_RC1 -> "7.6.1-RC1"
    --HCV_7_4_2_RC1 -> "7.4.2-RC1"

data HPV
 -- = HPV_2009_2_0
 -- | HPV_2009_2_0_1
 -- | HPV_2009_2_0_2
 -- | HPV_2010_1_0_0
 -- | HPV_2010_2_0_0
 -- | HPV_2011_2_0_0
 -- | HPV_2012_2_0_0_B2
    = HPV_2011_2_0_1
    | HPV_2011_4_0_0
    | HPV_2012_2_0_0
                                            deriving (Show,Eq,Ord,Enum,Bounded)

hpv2str :: HPV -> String
hpv2str = fst . hpv2strHCV

hpv2hcv :: HPV -> HCV
hpv2hcv = snd . hpv2strHCV

hpv2strHCV :: HPV -> (String,HCV)
hpv2strHCV hpv =
    case hpv of
    --HPV_2009_2_0      -> (,) "2009.2.0"          HCV_6_10_2
    --HPV_2009_2_0_1    -> (,) "2009.2.0.1"        HCV_6_10_3
    --HPV_2009_2_0_2    -> (,) "2009.2.0.2"        HCV_6_10_4
    --HPV_2010_1_0_0    -> (,) "2010.1.0.0"        HCV_6_12_1
    --HPV_2010_2_0_0    -> (,) "2010.2.0.0"        HCV_6_12_3
    --HPV_2011_2_0_0    -> (,) "2011.2.0.0"        HCV_7_0_2
    --HPV_2012_2_0_0_B2 -> (,) "2012.2.0.0-beta2"  HCV_7_4_2_RC1
      HPV_2011_2_0_1    -> (,) "2011.2.0.1"        HCV_7_0_3
      HPV_2011_4_0_0    -> (,) "2011.4.0.0"        HCV_7_0_4
      HPV_2012_2_0_0    -> (,) "2012.2.0.0"        HCV_7_4_1



--
-- Distro, distroTag, distros & distro
--


-- distros we are supporting

data Distro
    = El5               -- CentOS/SL/RHEL 5
    | El6               -- CentOS/SL/RHEL 6
    | Fc16              -- Fedora Core 16
    | Fc17              -- Fedora Core 16
                                                                deriving (Show)

-- tag used to identify the ditro on RPM filenames, etc.

distroTag :: Distro -> String
distroTag d =
        case d of
          El5  -> "el5"
          El6  -> "el6"
          Fc16 -> "fc16"
          Fc17 -> "fc17"


-- work out the local distro from /etc/redhat

distros :: [(Int,Distro)]
distros = [(5,El5),(6,El6),(16,Fc16),(17,Fc17)]
                    -- supported releases of RHEL/CentOS/FC
                    --  (i,ds)
                    --  i  => release number found  in /etc/redhat_release
                    --  ds => corresponding distribution: el5, el6, fc16, etc

distro :: IO (Distro,String)
distro = flip E.catch hdl $
     do ji <- flip E.catch hdl_ji $ cln `fmap` readFile "ji.txt"
        bs <- B.readFile "/etc/redhat-release"
        let rh_rel = map (chr.fromEnum) $ B.unpack bs
        case [ ds | (i,ds)   <-distros, is_release rh_rel i ] of
          []   -> oops
          ds:_ -> return (ds,ji)
      where
        is_release rh_rel i = any (rel_i `isPrefixOf`) $ tails rh_rel
              where
                rel_i = "release " ++ show i

        cln     = map (\c->case c of {'\n' -> ' '; _ -> c; })

        hdl    :: IOError -> IO (Distro,String)
        hdl    _ = oops

        hdl_ji :: IOError -> IO String
        hdl_ji _ = return ""

        oops     = ioError $ userError $ "Cannot determine the RHEL/CentOS release"

