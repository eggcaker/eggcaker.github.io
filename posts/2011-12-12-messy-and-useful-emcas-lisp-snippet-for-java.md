---
title: Messy and useful emcas-lisp snippet for java 
layout: 'post'
author: 'eggcaker'
date: '2011-12-12'
categories: blog 2011
tags: ['Emacs']
---


emacs-lisp is powerful !!! check out the yasnippet for insert a package for in
java project

    
    # -*- mode: snippet -*-
    # contributor : eggcaker <[eggcaker@gmail.com](mailto:eggcaker@gmail.com)>
    # name : package for my project
    # key : pg
    # --
    package `(substring (replace-regexp-in-string "/" "."
    (replace-regexp-in-string 
    (substitute-in-file-name "$HOME/src/Android/projectA/src/") "" 
    (file-name-directory (file-name-sans-extension (buffer-file-name))))) 0 -1)`;
    $0
    

maybe I need learn more about emacs-lisp, and make it more clean and elegant.

