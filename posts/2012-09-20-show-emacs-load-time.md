---
title: Show emacs load time 
layout: 'post'
author: 'eggcaker'
date: '2012-09-20'
categories: blog 2012
tags: Emacs
---


Some time you may want to show the loading time , there is how you can do :

    
    ;; start time 
    (defvar *pelm-start-time* (current-time))
    
    ;; show 
    (message (format "PELM loaded in %ds" (destructuring-bind (hi lo ms rs) (current-time)
                               (- (+ hi lo) (+ (first *pelm-start-time*) (second *pelm-start-time*))))))
    

