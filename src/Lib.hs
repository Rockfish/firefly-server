{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( getMovieData
    ) where

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Lazy.Char8 as LC
import Network.HTTP.Simple

getMovieData = do 
  request <- parseRequest $ "GET " ++ url 
  response <- httpJSON request
  return response
  where key = "73c2e326"
        title = "The Matrix"
        responseType = "JSON"
        url = "http://www.omdbapi.com/?apikey=" ++ key ++ "&r=" ++ responseType ++ "&t=" ++ title
