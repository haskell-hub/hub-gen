--
-- >>> HubGen.CheckRepo <<<
--
-- Check repository against expected packages.
--
-- (c) 2011-2012 Chris Dornan


module HubGen.CheckRepo
    ( checkRepo
    ) where

import           System.Directory
import qualified Data.Map           as M
import           Data.List
import           HubGen.Params
import           HubGen.Package


checkRepo :: Params -> IO ()
checkRepo pms =
     do rpms <- filter rpm_fn `fmap` getDirectoryContents "."
        check (packageNames pms) rpms

check :: [PackageName] -> [FilePath] -> IO ()
check pkgs rpms =
     do report "Missing Packages"      mps
        report "Duplicate Packages"    dps
        report "Unrecognized Packages" eps
      where
        mps      = [ pnm | (pnm,[]   ) <- M.toList mp ]
        dps      = [ pnm | (pnm,_:_:_) <- M.toList mp ]

        (mp,eps) = calc pkgs rpms

report :: String -> [String] -> IO ()
report _   []  = return ()
report hdg lns = putStr $ unlines $ hdg : map ("    "++) lns


calc :: [PackageName] -> [FilePath] -> (M.Map PackageName [FilePath],[FilePath])
calc pnms0 rpms =
            ( pmp, rpms \\ concat (M.elems pmp)
            )
      where
        pmp        = M.fromList [(pnm,filter (lu pnm) rpms) | pnm<-pnms ]

        lu pnm rpm = M.lookup rpm rmp == Just pnm

        rmp        = M.fromList [(rpm,pnm) |
                                    rpm<- rpms, Just pnm <- [match rpm pnms] ]

        pnms       = sortBy ol pnms0

        ol x y     = compare (length y) (length x)

-- Note packes must be listed in descending order of name length

match :: FilePath -> [PackageName] -> Maybe PackageName
match rpm pnms =
        case filter (`isPrefixOf` rpm) pnms of
          []       -> Nothing
          mx_pnm:_ -> Just mx_pnm

rpm_fn :: FilePath -> Bool
rpm_fn fnm = ".rpm" `isSuffixOf` fnm && length fnm>4
