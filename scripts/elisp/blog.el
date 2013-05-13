;;; pelm-misc.el --- PELM blog 
;;
;; Copyright (c) 2011-2015 eggcaker
;;
;; Authors: eggcaker <eggcaker@gmail.com>
;; URL: http://iemacs.com/pelm


;; This file is not part of GNU Emacs

;;; Code:

(add-to-list 'load-path "~/.emacs.d/org/lisp");
(add-to-list 'load-path "~/.emacs.d/org/contrib/lisp");
(require 'org)
(require 'org-exp)
(require 'ox-org)
(require 'ox-html)

(setq org-export-default-language "en"
      org-html-extension "html"
      org-export-with-timestamps t
      org-html-inline-images t
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-export-with-section-numbers nil
      org-export-with-tags 'not-in-toc
      org-export-skip-text-before-1st-heading nil
      org-export-with-sub-superscripts '{}
      org-export-with-archived-trees nil
      org-export-highlight-first-table-line nil 
      org-export-latex-listings-w-names nil
      org-export-htmlize-output-type 'css
      org-startup-folded nil
      org-html-doctype "html5"
      org-export-allow-BIND t
      org-html-postamble-format '(("en" "<p class=\"postamble\">&copy; iemacs.com. Last updated: %T by %c</p>"))
      org-publish-list-skipped-files t
      org-publish-use-timestamps-flag nil  ; nil for dev and t for prod
      org-export-babel-evaluate t
      org-confirm-babel-evaluate nil)


(defun set-org-publish-project-alist ()
  (interactive)
  (setq org-publish-project-alist
	`(("iemacs"
           :components ("iemacs-pages" "iemacs-assets-dir" ))
	  ("iemacs-pages"
	   :base-directory ,iemacs-base-directory
	   :base-extension "org"
	   :exclude "scripts"
	   :makeindex t
	   :auto-sitemap t
	   :sitemap-ignore-case t
	   :html-extension "html"
	   :publishing-directory ,iemacs-publish-directory
           :publishing-function org-html-publish-to-html
	   :htmlized-source t 
	   :section-numbers nil
	   :table-of-contents t 
	   :html-head "<link rel=\"stylesheet\" href=\"/assets/css/bootstrap.min.css\" type=\"text/css\" />
<link rel=\"stylesheet\" href=\"/assets/css/iemacs.css\" type=\"text/css\" />"
	   :recursive t
	   :html-preamble ,(org-get-file-contents "~/src/personal/iemacs.com/assets/html/preamble.html")
	   :html-postamble t
	   )
	  ("iemacs-assets-dir"
	   :base-directory ,iemacs-base-assets-directory
	   :base-extension "png\\|jpg\\|gif\\|pdf\\|cvs\\|css"
	   :publishing-directory "/var/www/iemacs.com/public/assets/"
	   :recursive t
	   :publishing-function org-publish-attachment)
          )))

(setq iemacs-base-directory "~/src/personal/iemacs.com/")
(setq iemacs-base-assets-directory "~/src/personal/iemacs.com/assets/")
(setq iemacs-publish-directory "/var/www/iemacs.com/public/")
(set-org-publish-project-alist)

(defun iemacs-fix-symbol-table ()
  (when (string-match "org-symbols\\.html" buffer-file-name)
    (goto-char (point-min))
    (while (re-search-forward "<td>&amp;\\([^<;]+;\\)" nil t)
      (replace-match (concat "<td>&" (match-string 1)) t t))))

(defun publish-iemacs nil
   "Publish iEmacs.com"
   (interactive)
   ;(add-hook 'org-publish-after-export-hook 'iemacs-fix-symbol-table)
   (let ((org-format-latex-signal-error nil)
	 (iemacs-base-directory "~/src/personal/iemacs.com/")
	 (iemacs-base-assets-directory "~/src/personal/iemacs.com/assets/")
	 (iemacs-publish-directory "/var/www/iemacs.com/public/"))
     (set-org-publish-project-alist)
     (org-publish-project "iemacs")))

(provide 'pelm-blog)
;;; pelm-blog ends here
