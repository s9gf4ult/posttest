{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.Identity
import Control.Monad.Random
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Data.Int
import Data.Text (pack, Text)
import System.Random

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
               
makeDB c = do
  mapM_ (execute_ c) ["drop table if exists things"
                     ,"create table things (a integer, b integer, c text)"]

insertThings c = do
  ts <- genThings
  withTransaction c $ do
    executeMany c "insert into things (a, b, c) values (?, ?, ?)" $ map (\(Thing ta tb tc) -> (ta, tb, tc)) $ take 50000 ts

main = do
  c <- connect $ defaultConnectInfo { connectUser = "test"
                                    ,connectPassword = "test"
                                    ,connectDatabase = "test" }
  makeDB c
  insertThings c
  return ()