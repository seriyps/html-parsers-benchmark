{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE CPP #-}

module Main where

import Control.DeepSeq
import Control.Exception
import Data.Time.Clock
import Safe

import Options.Applicative
import Text.HTML.TagSoup hiding (parseTags)
import Text.HTML.TagSoup.Fast
import Text.HTML.TagSoup.Tree

import qualified Data.ByteString as SB

instance NFData a => NFData (Tag a) where
    rnf (TagOpen x y) = rnf x `seq` rnf y
    rnf (TagClose x) = rnf x
    rnf (TagText x) = rnf x
    rnf (TagComment x) = rnf x
    rnf (TagWarning x) = rnf x
    rnf (TagPosition _x _y) = ()

instance NFData a => NFData (TagTree a) where
    rnf (TagLeaf x) = rnf x
    rnf (TagBranch x y z) = rnf x `seq` rnf y `seq` rnf z

#ifndef BYTESTRING_HAS_NFDATA
# ifdef MIN_VERSION_bytestring
#  define BYTESTRING_HAS_NFDATA (MIN_VERSION_bytestring(0,10,0))
# else
#  define BYTESTRING_HAS_NFDATA (__GLASGOW_HASKELL__ >= 706)
# endif
#endif

#if !BYTESTRING_HAS_NFDATA
instance NFData SB.ByteString where
    rnf x = SB.length x `seq` ()
#endif


data Options = Options
    { optFile  :: FilePath
    , optTimes :: Int
    } deriving (Show, Eq, Ord)

options :: ParserInfo Options
options = info (helper <*> parser) fullDesc
  where
    parser = Options
        <$> argument Just ( metavar "FILE" )
        <*> argument readMay ( metavar "TIMES" )              

run :: NFData b => (a -> b) -> a -> Int -> IO ()
run f = go
  where
    go x n
      | n <= 0    = return ()
      | otherwise = evaluate (rnf (f x)) >> go x (n-1)

main :: IO ()
main = do
    Options { .. } <- execParser $ options

    d <- SB.readFile optFile

    t1 <- getCurrentTime
    run benchmark d optTimes
    t2 <- getCurrentTime

    putStr $ init $ show $ diffUTCTime t2 t1
    putStrLn " s"
  where
    benchmark = tagTree . parseTags
