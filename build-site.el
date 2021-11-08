;;; build-site.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 eggcaker
;;
;; Author: eggcaker <https://github.com/eggcaker>
;; Maintainer: eggcaker <eggcaker@gmail.com>

(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'org)
(package-install 'htmlize)

(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (ditaa . t)
         (python . t)
         (shell . t)
         (js . t)
         (org . t)
         (plantuml . t)
         )))



(require 'org)
(require 'ox-publish)

;; UTF-8 as default encoding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Load the publishing system

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      emacs-cc-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" /><link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
      emacs-cc-html-preamble " <span><h1 class=\"brand\"><a href=\"/\">大道至簡</a></h1><span class=\"slogen\">咦！錢塘江上潮信來，今日方知我是我。</span></span> <nav> <ul class=\"menu\"> <li><a href=\"/\">Home</a></li> <li><a href=\"/pages/books\">Books</a></li> <li><a href=\"/pages/flags\">Flags</a></li> <li><a href=\"/pages/about\">About</a></li> </ul> <hr/> </nav>"
      emacs-cc-html-postamble "<footer> <div class=\"generated\"> &copy; 2021-2028 TZ, built with %c | <a href=\"http://beian.miit.gov.cn/\">冀ICP备2020025756号-1</a> </div> </footer>"

      org-ditaa-jar-path "./assets/ditaa.jar"
      org-export-babel-evaluate t
      org-confirm-babel-evaluate nil
      org-html-doctype "html5")

;; Define the publishing project
(setq org-publish-project-alist
      `(
        ("posts"
         :recursive t
         :base-directory "./posts"
         :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "./_site"
         :html-head ,emacs-cc-html-head
         :with-author nil           ;; Don't include author name
         :with-creator t            ;; Include Emacs and Org versions in footer
         :with-toc nil                ;; Include a table of contents
         :section-numbers nil       ;; Don't include section numbers
         :html-preamble ,emacs-cc-html-preamble
         :html-postamble ,emacs-cc-html-postamble
         :auto-index t
         :index-title "[ >>>Blogs]"
         :index-filename "blogs.org"
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

;; Generate the site output
(org-publish-all t)

(message "Build complete!")

;;; build-site.el ends here
