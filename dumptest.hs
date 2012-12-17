
module Main where

import Common

instance Show Thing where
  show (Thing a b c) = "A: " ++ (show a) ++ " B: " ++ (show b) ++ " C: " ++ (show c)
  
main = do
  ts <- genThings
  mapM print $ take 50000 ts