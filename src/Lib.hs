{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( getMovieData
    ) where

import Network.HTTP.Client


getMovieData = do 
  let settings = managerSetProxy
              (proxyEnvironment Nothing)
              defaultManagerSettings
  man <- newManager settings
  let req = "http://httpbin.org"
              -- Note that the following settings will be completely ignored.
              { proxy = Just $ Proxy "localhost" 1234
              }
--  request <- parseRequest $ "GET " ++ url 
--  return httpJSON request
  return $ httpLbs req man
  where key = "73c2e326"
        title = "The Matrix"
        responseType = "JSON"
        url = "http://www.omdbapi.com/?apikey=" ++ key ++ "&r=" ++ responseType ++ "&t=" ++ title
--              { proxy = Just $ Proxy "localhost" 1234 }
