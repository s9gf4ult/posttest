module Common where

import Control.Monad.Random
import System.Random
import Data.Text (pack, Text)
import Data.Int
import Control.Monad.Identity

data Thing = Thing Int32 Int32 Text

randomThing :: (RandomGen g, Monad m) => RandT g m Thing
randomThing = do
  a <- getRandom
  b <- getRandom
  c <- getRandomRs ('a', 'z')
  return $ Thing a b $ pack $ take 10 c

genThings :: IO [Thing]
genThings = do
  g <- newStdGen
  return $ runIdentity $ evalRandT (sequence $ repeat randomThing) g
