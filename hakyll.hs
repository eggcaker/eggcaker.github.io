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
    match ( fromList ["bdunion.txt", "CNAME", "README.md"]) $ do 
        route   idRoute
        compile copyFileCompiler

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

    puzzleTags <- buildTags "puzzles/*"  (fromCapture "puzzles/tags/*.html")
    reviewTags <- buildTags "reviews/**"  (fromCapture "reviews/tags/*.html")

    match "puzzles/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/puzzle.html"    (puzzleCtx puzzleTags)
            >>= loadAndApplyTemplate "templates/puzz-default.html" defaultContext
            >>= relativizeUrls

    match "reviews/**" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/review.html"    (reviewCtx reviewTags)
            >>= loadAndApplyTemplate "templates/review-default.html" defaultContext
            >>= relativizeUrls

    match (fromList ["reading.md","search.md","puzzles/index.md","projects/index.md",
                     "projects/pelm.md", "resume/index.md",
                     "resume/index-zh.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls
            
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

    -- puzzle tags
    tagsRules puzzleTags $ \tag pattern -> do 
        let title = "Puzzles tagged " ++ tag

        -- copied from posts, need to refactor
        route idRoute
        compile $ do 
          list <- puzzleList puzzleTags pattern recentFirst
          let ctx = constField "title" title `mappend`
                    constField "posts" list `mappend`
                    defaultContext
          makeItem ""
              >>= loadAndApplyTemplate "templates/archive.html" ctx
              >>= loadAndApplyTemplate "templates/puzz-default.html" ctx
              >>= relativizeUrls

    -- review tags
    tagsRules reviewTags $ \tag pattern -> do 
        let title = "Reviews tagged " ++ tag

        -- copied from posts, need to refactor
        route idRoute
        compile $ do 
          list <- reviewList reviewTags pattern recentFirst --fmap (tak 20) . recentFirst
          let ctx = constField "title" title `mappend`
                    constField "posts" list `mappend`
                    defaultContext
          makeItem ""
              >>= loadAndApplyTemplate "templates/archive.html" ctx
              >>= loadAndApplyTemplate "templates/review-default.html" ctx
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
    match "puzzles.html" $ do
        route idRoute
        compile $ do
            list <- postList tags "puzzles/*" $ recentFirst --fmap (take 10) . recentFirst
            let indexCtx = constField "puzzles" list `mappend`
                 field "tags" (\_ -> renderTagList puzzleTags ) `mappend`
                 defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "reviews.html" $ do
        route idRoute
        compile $ do
            list <- postList tags "reviews/2013/*" $ fmap (take 20) . recentFirst
            let indexCtx = constField "reviews" list `mappend`
                 field "tags" (\_ -> renderTagList reviewTags ) `mappend`
                 defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler
-------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
  {
     deployCommand = "make publish"
  }
-------------------------------------------------------------------------------
reviewList :: Tags -> Pattern ->([Item String] -> Compiler [Item String]) -> Compiler String
reviewList  tags pattern preprocess' = do
   reviewItemTpl <- loadBody "templates/review-item.html"
   reviews       <- preprocess' =<< loadAll pattern
   applyTemplateList reviewItemTpl (reviewCtx tags) reviews
-------------------------------------------------------------------------------
reviewCtx :: Tags -> Context String
reviewCtx tags = mconcat
    [ modificationTimeField "mtime" "%U"
    , dateField "date" "%Y-%m-%d"
    , tagsField "tags" tags
    , defaultContext
    ]
-------------------------------------------------------------------------------
puzzleList :: Tags -> Pattern ->([Item String] -> Compiler [Item String]) -> Compiler String
puzzleList  tags pattern preprocess' = do
   puzzleItemTpl <- loadBody "templates/puzzle-item.html"
   puzzles       <- preprocess' =<< loadAll pattern
   applyTemplateList puzzleItemTpl (puzzleCtx tags) puzzles 
-------------------------------------------------------------------------------
puzzleCtx :: Tags -> Context String
puzzleCtx tags = mconcat
    [ modificationTimeField "mtime" "%U"
    , dateField "date" "%Y-%m-%d"
    , tagsField "tags" tags
    , defaultContext
    ]
-------------------------------------------------------------------------------
postList :: Tags -> Pattern ->([Item String] -> Compiler [Item String]) -> Compiler String
postList tags pattern preprocess' = do
    postItemTpl <- loadBody "templates/post-item.html"
    posts       <- preprocess' =<< loadAll pattern
    applyTemplateList postItemTpl (postCtx tags) posts

-------------------------------------------------------------------------------
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

