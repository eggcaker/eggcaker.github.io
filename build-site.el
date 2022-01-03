;;; build-site.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 eggcaker
;;
;; Author: eggcaker <https://github.com/eggcaker>
;; Maintainer: eggcaker <eggcaker@gmail.com>

(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(
                         ("melpa" . "https://melpa.org/packages/")
                         ("nongnu-melpa" . "https://elpa.nongnu.org/nongnu/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ))

(add-to-list 'load-path (concat default-directory "./assets/lisp/"))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'org)
(package-install 'htmlize)

(require 'org)
(require 'htmlize)
(require 'ox-publish)
(require 'ox-html)
(require 'ox-rss)

(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (ditaa . t)
         (python . t)
         (shell . t)
         (js . t)
         (abc . t)
         (org . t)
         (plantuml . t)
         )))

(setq org-plantuml-exec-mode 'jar)
(setq plantuml-default-exec-mode 'jar)
(setq org-plantuml-executable-args '("-charset=UTF-8"))
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-16-le)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")

(setq default-buffer-file-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Load the publishing system
;; <!--<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />
;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      emacs-cc-html-head "<link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
      emacs-cc-html-preamble " <span><h1 class=\"brand\"><a href=\"/\">大道至簡</a></h1><span class=\"slogen\">咦！錢塘江上潮信來，今日方知我是我。</span></span> <nav> <ul class=\"menu\"> <li><a href=\"/\">Home</a></li> <li><a href=\"/pages/books\">Books</a></li><li><a href=\"/pages/about\">About</a></li>  <li><a href=\"/rss.xml\">RSS</a></li> </ul> <hr/> </nav>"
      emacs-cc-html-postamble (concat "<footer> <div class=\"generated\"> &copy; " (format-time-string "%Y" (current-time)) " TZ, built with %c | <a href=\"http://beian.miit.gov.cn/\">冀ICP备2020025756号-1</a> </div> </footer>")
      emacs-cc-comments-html-postamble "<script src=\"https://utteranc.es/client.js\" repo=\"eggcaker/eggcaker.github.io\" issue-term=\"pathname\" theme=\"github-light\" crossorigin=\"anonymous\" async></script> <footer> <div class=\"generated\"> &copy; 2021-2028 TZ, built with %c | <a href=\"http://beian.miit.gov.cn/\">冀ICP备2020025756号-1</a> </div> </footer>"
      org-ditaa-jar-path (if (eq system-type 'windows-nt) "c:/temp/ditaa.jar" "/tmp/ditaa.jar")
      org-plantuml-jar-path  (if (eq system-type 'windows-nt) "c:/temp/plantuml.jar" "/tmp/plantuml.jar")
      org-export-babel-evaluate t
      org-confirm-babel-evaluate nil
      org-html-doctype "html5")

(defun cc/org-publish-org-sitemap(title list)
  "Sitemap generation function."
  (concat "#+TITLE: Sitemap\n\n"
          (org-list-to-subtree list)))

(defun cc/org-publish-org-sitemap-format-entry (entry style project)
  (cond ((not (directory-name-p entry))
         (let* ((date (org-publish-find-date entry project)))
           (format "%s - [[file:%s][%s]]"

                   (format-time-string "%F" date) entry
                   (org-publish-find-title entry project))))
        ((eq style 'tree)
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

(defun cc/org-rss-publish-to-rss (plist filename pub-dir)
  "Publish RSS with PLIST, only when FILENAME is 'rss.org'.
PUB-DIR is when the output will be placed."
  (if (equal "rss.org" (file-name-nondirectory filename))
      (org-rss-publish-to-rss plist filename pub-dir)))

(defun cc/format-rss-feed (title list)
  "Generate RSS feed, as a string.
TITLE is the title of the RSS feed.  LIST is an internal
representation for the files to include, as returned by
`org-list-to-lisp'.  PROJECT is the current project."
  (concat "#+TITLE: " title "\n\n"
          (org-list-to-subtree list 1 '(:icount "" :istart ""))))

(defun cc/format-rss-feed-entry (entry style project)
  "Format ENTRY for the RSS feed.
ENTRY is a file name.  STYLE is either 'list' or 'tree'.
PROJECT is the current project."
  (cond ((not (directory-name-p entry))
         (let* ((file (org-publish--expand-file-name entry project))
                (title (org-publish-find-title entry project))
                (date (format-time-string "%Y-%m-%d" (org-publish-find-date entry project)))
                (link (concat (file-name-sans-extension entry) ".html")))
           (with-temp-buffer
             (insert (format "* %s\n" title))
             (org-set-property "RSS_PERMALINK" link)
             (org-set-property "PUBDATE" date)
             (insert-file-contents file)
             (buffer-string))))
        ((eq style 'tree)
         ;; Return only last subdir.
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

(defun templated-html-create-sitemap-xml (output directory base-url &rest regexp)
  (let* ((rx (or regexp "\\.html")))
    (with-temp-file output
      (insert "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<urlset
      xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\"
      xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
      xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9
            http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\">\n")
      (cl-loop for file in (directory-files-recursively directory rx)
            do (insert (format "<url>\n <loc>%s/%s</loc>\n <priority>0.5</priority>\n</url>\n"
                               base-url (file-relative-name file directory))))
      (insert "</urlset>"))))

;; Define the publishing project
(setq org-publish-project-alist
      `(
        ("posts"
         :recursive t
         :base-directory "./posts"
         :base-extension "org"
         :exclude "rss\\.org\\|sitemap\\.org\\|index\\.org\\|blogs\\.org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "./_site"
         :html-head ,emacs-cc-html-head
         :description "This is my personal website, a place where to me to write anything I want."
         :language en
         :with-date nil
         :with-title t
         :headline-levels 4
         :with-author nil
         :with-creator nil
         :with-toc nil
         :section-numbers nil
         :html-preamble ,emacs-cc-html-preamble
         :html-postamble  ,emacs-cc-comments-html-postamble
         :auto-sitemap t
         :sitemap-sort-files anti-chronologically
         :sitemap-format-entry cc/org-publish-org-sitemap-format-entry
         :htmlized-source t
         :html-doctype "html5"
         :html-html5-fancy t
         :sitemap-title "大道至简 - emacs.cc"
         :sitemap-filename "blogs.org"
         :time-stamp-file t)
        ("commentless"
         :recursive t
         :base-directory "./posts"
         :base-extension "org"
         :exclude "\\.org"
         :include ,'("index.org" "blogs.org")
         :publishing-function org-html-publish-to-html
         :publishing-directory "./_site"
         :html-head ,emacs-cc-html-head
         :description "This is my personal website, a place where to me to write anything I want."
         :language en
         :with-date nil
         :with-title t
         :headline-levels 4
         :with-author nil
         :with-creator nil
         :with-toc nil
         :section-numbers nil
         :html-preamble ,emacs-cc-html-preamble
         :html-postamble ,emacs-cc-html-postamble
         :auto-sitemap nil
         :htmlized-source t
         :html-doctype "html5"
         :html-html5-fancy t
         :time-stamp-file t)

        ("rss"
         :recursive t
         :base-directory "./posts"
         :base-extension "org"
         :exclude "rss\\.org\\|index\\.org\\|sitemap\\.org\\|blogs\\.org"
         :publishing-function cc/org-rss-publish-to-rss
         :publishing-directory "./_site"
         :html-head ,emacs-cc-html-head
         :title "大道至简 - emacs.cc"
         :description "This is my personal website, a place where to me to write anything I want."
         :creator "eggcaker"
         :with-author t
         :with-creator t
         :with-toc nil
         :section-numbers nil
         :html-preamble ,emacs-cc-html-preamble
         :html-postamble ,emacs-cc-html-postamble
         :sitemap-title "大道至简 - emacs.cc"
         :sitemap-function cc/format-rss-feed
         :sitemap-format-entry cc/format-rss-feed-entry
         :auto-sitemap t
         :sitemap-filename "rss.org"
         :sitemap-style list
         :time-stamp-file t)


        ("pages"
         :recursive t
         :base-directory "./pages"
         :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "./_site/pages"
         :html-head ,emacs-cc-html-head
         :with-author nil
         :with-creator t
         :with-toc nil
         :with-title nil
         :section-numbers nil
         :html-preamble ,emacs-cc-html-preamble
         :html-postamble ,emacs-cc-html-postamble
         :time-stamp-file nil)
        ("images"
         :recursive t
         :base-directory "./posts/images"
         :base-extension "txt\\|jpg\\|gif\\|png"
         :publishing-directory "./_site/images/"
         :publishing-function org-publish-attachment)

        ("static"
         :recursive nil
         :base-directory "./assets"
         :include ,'("CNAME" "favicon.ico" "style.css")
         :publishing-directory "./_site"
         :publishing-function org-publish-attachment)

        ))

(org-publish-all t)

(message "Build complete!")

;;; build-site.el ends here
