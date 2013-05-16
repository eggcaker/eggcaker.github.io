---
title: 自己寻开心 
layout: 'post'
author: 'eggcaker'
date: '2012-03-26'
categories: blog 2012
tags: ['Emacs']
---


无聊一会儿，自己逗自己开心下^_^

    
    (defun hello_caker() 
      "show hi mesage "
      (interactive)
      (animate-string  "hi , I am caker, how are you ?" 6))
    
    (global-set-key (kbd "\C-c h i i a m c a k e r h o w a r e y o u") 'hello_caker)
    
    

