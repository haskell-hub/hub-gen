--
-- >>> Main <<<
--
-- When it is not performing some diagnostic function, this program takes
-- the name of a package, generates the spec file from templates and invokes
-- a script to build the RPM in the rpmbuild sub-tree.
--
-- (c) 2011-2012 Chris Dornan


module Main (main) where

import           Data.Char
import           System.IO
import           System.Exit
import           System.Directory
import           System.Posix.Process
import           Text.Printf
import qualified Data.ByteString    as B
import           HubGen.Params
import           HubGen.Package
import           HubGen.CommandLine
import           HubGen.CheckRepo


main :: IO ()
main =
     do pms <- params
        cl  <- commandLine pms
        case cl of
          ReportCL str       -> putStr str
          BuildCL  nb ns pkg -> build pms nb ns pkg
          CheckCL            -> checkRepo pms
          ErrorCL  str       -> hPutStr stderr str >> exitWith (ExitFailure 1)

build :: Params -> Maybe ShowType -> Bool -> Package -> IO ()
build pms mb ns pkg =
     do (pmh,hdr,bdy) <- gen_spec pms pkg
        let fhd = pmh ++ hdr
            spc = fhd ++ bdy
        case mb of
          Nothing ->
             do write_spec_file (build_spec_path pms pkg) spc
                ec <- rpmbuild pms ns pkg
                exitWith ec
          Just st ->
                case st of
                  PrmsST -> putStr pmh
                  HeadST -> putStr fhd
                  SpecST -> putStr spc


--
-- Building the Package
--


rpmbuild :: Params -> Bool -> Package -> IO ExitCode
rpmbuild pms ns pkg = executeFile cmd False args Nothing
      where
        cmd  = "bin/rpmbuild.sh"
        args = ["-ba",printf "%s%s" sf $ build_spec_path pms pkg]

        sf           = if ns then "" else "--sign "



--
-- Generating the Spec File
--


gen_spec :: Params -> Package -> IO (String,String,String)
gen_spec pms pkg =
     do cwd <- getCurrentDirectory
        pmh <- return $ mkMacros cwd pms pkg
        hdr <- read_spec_file   spec_hdr_path
        bdy <- read_spec_file $ spec_bdy_path pkg
        return (pmh,hdr,bdy)



--
-- Reading and Writing the Spec File
--


read_spec_file :: FilePath -> IO String
read_spec_file pth =
     do bs <- B.readFile pth
        return $ map (chr.fromEnum) $ B.unpack bs

write_spec_file :: FilePath -> String -> IO ()
write_spec_file pth cts =
     do case all isAscii cts of
          True  -> return ()
          False -> ioError $ userError spec_ascii_error
        B.writeFile pth $ B.pack $ map (toEnum.fromEnum) cts
      where
        spec_ascii_error = "Generated spec file contains non-ASCII characters"



--
-- Calculating Spec File Paths
--


build_spec_path :: Params -> Package -> FilePath
build_spec_path pms pkg = printf "%s/SPECS/%s.spec" tree name
      where
        tree = rpmbuildtPMS pms
        name = packageName $ namePKG pkg

spec_hdr_path :: FilePath
spec_hdr_path = "specs/header.spec"

spec_bdy_path :: Package -> FilePath
spec_bdy_path pkg = printf "specs/%s" $ specPKG pkg
