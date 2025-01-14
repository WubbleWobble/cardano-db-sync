module Test.Cardano.Db.Mock.Unit.Babbage.CommandLineArg.ConfigFile (
  checkConfigFileArg,
)
where

import Cardano.Mock.ChainSync.Server (IOManager)
import Data.Text (Text)
import Test.Cardano.Db.Mock.Config (CommandLineArgs (..), babbageConfigDir, initCommandLineArgs, withCustomConfigAndLogs)
import Test.Tasty.HUnit (Assertion)

-- this test fails as incorrect configuration file given
checkConfigFileArg :: IOManager -> [(Text, Text)] -> Assertion
checkConfigFileArg =
  withCustomConfigAndLogs commandLineConfigArgs babbageConfigDir testLabel $ \_ _ _ -> do
    pure ()
  where
    testLabel = "CLAcheckConfigFileArg"
    commandLineConfigArgs = initCommandLineArgs {claHasConfigFile = False}
