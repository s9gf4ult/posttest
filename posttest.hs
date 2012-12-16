{-# LANGUAGE OverloadedStrings #-}

module Main where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToRow
import Common
               
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