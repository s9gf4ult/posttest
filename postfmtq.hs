{-# LANGUAGE OverloadedStrings #-}

module Main where

import Common
import qualified Data.ByteString.Char8 as B
import Database.PostgreSQL.Simple

main = do
  tdata <- genThings
  c <- connect $ defaultConnectInfo { connectUser = "test"
                                    ,connectPassword = "test"
                                    ,connectDatabase = "test" }

  result <- mapM (formatQuery c "insert into things (a, b, c) values (?, ?, ?)") $ map (\(Thing ta tb tc) -> (ta, tb, tc)) $ take 50000 tdata

  mapM_ B.putStrLn result 