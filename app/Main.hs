{-# language OverloadedStrings #-}

import Web.Firefly
import Data.Maybe (fromMaybe)
import qualified Data.Text as T
import Network.HTTP.Client
import Lib


-- movie data server = "www.omdbapi.com"
-- key: 73c2e326
-- 
--main :: IO ()
--main = run 3000 app

app :: App ()
app = do
  route "/hello" helloHandler
--  route "/movie" getMovieHandler

-- | Get the 'name' query param from the url, if it doesn't exist use 'Stranger'
helloHandler :: Handler T.Text
helloHandler = do
  name <- fromMaybe "Stranger" <$> getQuery "name"
  return $ "Hello " `T.append` name
  
getMovieHandler :: Handler T.Text
getMovieHandler = do
  text <- getDataTest
  return $ "response: " `T.append` text

--main :: IO ()
--main = getDataTest

getDataTest = do
  body <- getData
  let text = T.pack $ show body
  print text
  return text

getData = do
    let settings = managerSetProxy
            (proxyEnvironment Nothing)
            defaultManagerSettings
    man <- newManager settings
    let key = "73c2e326"
        title = "The Matrix"
        responseType = "JSON"
        url = "http://www.omdbapi.com/?apikey=" ++ key ++ "&r=" ++ responseType ++ "&t=" ++ title
    request <- parseRequest $ "GET " ++ url
    let req = "http://www.omdbapi.com/?apikey=73c2e326&r=JSON&t=The Matrix"
            -- Note that the following settings will be completely ignored.
            { proxy = Just $ Proxy "localhost" 1234 }
--    print url
--    print req
--    print request
    response <- httpLbs request man
    let body = responseBody response 
--    httpLbs req man >>= print
--    print body
    return body

