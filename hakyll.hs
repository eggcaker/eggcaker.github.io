--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid        (mappend, mconcat)
import           Prelude            hiding (id)
import           System.Cmd         (system)
import           System.FilePath    (replaceExtension, takeDirectory)
import qualified Text.Pandoc        as Pandoc
-------------------------------------------------------------------------------
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
    match "assets/**" $ do
        route   idRoute
        compile copyFileCompiler

    -- Build tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html"    (postCtx tags)
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls


    match (fromList ["search.md", "reviews.md","puzzles.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match (fromList ["resume/index.md","resume/index-zh.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext

    -- render rss RSS feed
    create ["rss.xml"] $ do
        route idRoute
        compile $ do
           loadAllSnapshots "posts/*" "content"
               >>= fmap (take 10) . recentFirst
               >>= renderAtom (feedConfiguration "All posts") feedCtx

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            list <- postList tags "posts/*" recentFirst
            let archiveCtx =
                    constField "title" "Archives" `mappend`
                    constField "posts" list       `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls
    
   -- post tags
    tagsRules tags $ \tag pattern -> do 
        let title = "Posts tagged " ++ tag

        -- copied from posts, need to refactor
        route idRoute
        compile $ do 
          list <- postList tags pattern recentFirst
          let ctx = constField "title" title `mappend`
                    constField "posts" list `mappend`
                    defaultContext
          makeItem ""
              >>= loadAndApplyTemplate "templates/archive.html" ctx
              >>= loadAndApplyTemplate "templates/default.html" ctx
              >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            list <- postList tags "posts/*" $ fmap (take 10) . recentFirst
            let indexCtx = constField "posts" list `mappend`
                 field "tags" (\_ -> renderTagList tags ) `mappend`
                 defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Tags -> Context String
postCtx tags = mconcat
    [ modificationTimeField "mtime" "%U"
    , dateField "date" "%Y-%m-%d"
    , tagsField "tags" tags
    , defaultContext
    ]
-------------------------------------------------------------------------------
feedCtx :: Context String
feedCtx = mconcat
  [
    bodyField "description"
    , defaultContext
  ]
-----------------------------------------------------------------------------
feedConfiguration :: String -> FeedConfiguration
feedConfiguration title = FeedConfiguration
  {
    feedTitle       = "iemacs - " ++ title
  , feedDescription = "Personal blog of iemacs"
  , feedAuthorName  = "eggcaker"
  , feedAuthorEmail = "eggcaker@gmail.com"
  , feedRoot        = "http://iemacs.com"
  }
-------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
  {
     deployCommand = "make publish"
  }
-------------------------------------------------------------------------------
postList :: Tags -> Pattern ->([Item String] -> Compiler [Item String]) -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/post-item.html"
    posts       <- preprocess' =<< loadAll pattern
    applyTemplateList postItemTpl (postCtx tags) posts
