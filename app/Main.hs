{-# language OverloadedStrings #-}

import Web.Firefly
import Data.Maybe (fromMaybe)
import qualified Data.Text as T
import Lib


-- movie data server = "www.omdbapi.com"
-- key: 73c2e326
 
main :: IO ()
main = run 3000 app

app :: App ()
app = do
  route "/hello" helloHandler
  route "/movie" getMovieData

-- | Get the 'name' query param from the url, if it doesn't exist use 'Stranger'
helloHandler :: Handler T.Text
helloHandler = do
  name <- fromMaybe "Stranger" <$> getQuery "name"
  return $ "Hello " `T.append` name
  
