;;; build-site.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 eggcaker
;;
;; Author: eggcaker <https://github.com/eggcaker>
;; Maintainer: eggcaker <eggcaker@gmail.com>
;; Created: November 07, 2021
;; Modified: November 07, 2021
;; Version: 0.0.1
;; Keywords: blog emacs
;; Homepage: https://github.com/eggcaker/
;; Package-Requires: ((emacs "27.2"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; UTF-8 as default encoding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"

      )

;; Define the publishing project
(setq org-publish-project-alist
      (list
        (list  "posts"
             :recursive t
             :base-directory "./posts"
             :base-extension "org"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./_site"
             :html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" /><link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc nil                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :html-preamble "
  <span><h1 class=\"brand\"><a href=\"/\">大道至簡</a></h1><span class=\"slogen\">咦！錢塘江上潮信來，今日方知我是我。</span></span>
    <nav>
    <ul class=\"menu\">
      <li><a href=\"/\">Home</a></li>
      <li><a href=\"/pages/books\">Books</a></li>
      <li><a href=\"/pages/flags\">Flags</a></li>
      <li><a href=\"/pages/about\">About</a></li>
    </ul>
    <hr/>
    </nav>"
             :html-postamble "
<footer>
  <div class=\"generated\">
     &copy; 2021-2028 Eggcaker, built with %c. | <a href=\"http://beian.miit.gov.cn/\">冀ICP备2020025756号-1</a>
  </div>
</footer>"
             :auto-index t
             :index-title "[ Blogs]"
             :index-filename "blogs.org"
             :time-stamp-file t)

      (list  "pages"
             :recursive t
             :base-directory "./pages"
             :base-extension "org"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./_site/pages"
             :html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" /><link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc nil                ;; Include a table of contents
             :with-title nil
             :section-numbers nil       ;; Don't include section numbers
             :html-preamble "
  <span><h1 class=\"brand\"><a href=\"/\">大道至簡</a></h1><span class=\"slogen\">咦！錢塘江上潮信來，今日方知我是我。</span></span>
    <nav>
    <ul class=\"menu\">
      <li><a href=\"/\">Home</a></li>
      <li><a href=\"/pages/books\">Books</a></li>
      <li><a href=\"/pages/flags\">Flags</a></li>
      <li><a href=\"/pages/about\">About</a></li>
    </ul>
    <hr/>
    </nav>"
             :html-postamble "
<footer>
  <div class=\"generated\">
     &copy; 2021-2028 Eggcaker, built with %c. | <a href=\"http://beian.miit.gov.cn/\">冀ICP备2020025756号-1</a>
  </div>
</footer>"
             :time-stamp-file nil)

        (list "static"
             :recursive t
             :base-directory "./"
             :base-extension (regexp-opt '("txt" "jpg" "gif" "png"))
             :include '("CNAME" "favicon.ico" "style.css")
             :publishing-directory "./_site"
             :publishing-function 'org-publish-attachment)

        ))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")

;;; build-site.el ends here
