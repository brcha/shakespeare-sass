-- ----- BEGIN LICENSE BLOCK -----
-- Version: MPL 2.0
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- ----- END LICENSE BLOCK -----

--
-- Copyright (c) 2016, Filip Brcic <brcha@gna.org>. All rights reserved.
--
-- This file is part of shakespeare-sass
--
module Text.Shakespeare.Sass
    ( wsass'
    , wfsSass
    ) where

import Text.Sass
import Language.Haskell.TH
import qualified Data.Default as DD
import Yesod.Default.Util (WidgetFileSettings, TemplateLanguage (..)
                          ,defaultTemplateLanguages, wfsLanguages)
import Yesod.Core

wsass' :: [FilePath] -> FilePath -> Q Exp
wsass' incPath fileName = do
    css <- runIO $ compileSassFile (Just incPath) fileName
    [| CssBuilder $(stringE css) |]

compileSassFile :: Maybe [FilePath] -> FilePath -> IO String
compileSassFile incPath fileName = do
    result <- compileFile fileName ( DD.def { sassIncludePaths = incPath } )
    case result of
        Left err -> do
            err' <- errorMessage err
            error err'
        Right compiled -> return . resultString $ compiled

wfsSass :: [FilePath] -> WidgetFileSettings
wfsSass sassInclude = def { wfsLanguages = \hset -> defaultTemplateLanguages hset ++
    [ TemplateLanguage True  "sass" wsass wsass
    , TemplateLanguage True  "scss" wsass wsass
    ] }
    where
         wsass = wsass' sassInclude