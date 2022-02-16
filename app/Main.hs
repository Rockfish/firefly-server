{-# language OverloadedStrings #-}

import Web.Firefly
import Web.Firefly.Handler
import Web.Firefly.Types
import Data.ByteString.Lazy
import Data.Maybe (fromMaybe)
import qualified Data.Text as T
import Network.HTTP.Client as C
import Control.Monad.Reader

import Lib

-- movie data server = "www.omdbapi.com"
-- key: 73c2e326

main :: IO ()
main = run 3000 app

app :: App ()
app = do
  route "/hello" helloHandler
  route "/movie" getMovieHandler

-- | Get the 'name' query param from the url, if it doesn't exist use 'Stranger'
helloHandler :: Handler T.Text
helloHandler = do
  name <- fromMaybe "Stranger" <$> getQuery "name"
  return $ "Hello " `T.append` name

--  
-- type MonadTrans :: ((* -> *) -> * -> *) -> Constraint
-- class MonadTrans t where
--   lift :: Monad m => m a -> t m a
--   -- Defined in ‘Control.Monad.Trans.Class’

getMovieHandler :: Handler T.Text
getMovieHandler = do
  title <- fromMaybe "" <$> getQuery "title"
  let str = show (T.unpack title)
  text <- lift (getDataTest str)
  return ("response: " `T.append` text)

getDataTest :: String -> IO T.Text
getDataTest title = do
  response <- getResponse title
  let body = responseBody response 
  let text = T.pack $ show body
  return text

getUrl :: String -> String
getUrl title = 
    let key = "73c2e326"
        responseType = "JSON"
    in "http://www.omdbapi.com/?apikey=" ++ key ++ "&r=" ++ responseType ++ "&t=" ++ title

getResponse :: String -> IO (Response ByteString)
getResponse title = do
    let settings = managerSetProxy
            (proxyEnvironment Nothing)
            defaultManagerSettings
    man <- newManager settings
    request <- parseRequest $ "GET " ++ getUrl title
    httpLbs request man

