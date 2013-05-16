---
title: "How to add new file to svn"
layout: 'post'
categories: blog 2010
tags: ['SNIPPET', 'SVN']
date: '2010-08-18'
author: 'eggcaker'
--- 

Want to know how you add all new file to svn server by 1 command line ?? right
place for you !

    
    $ svn add `svn st |grep ? |awk '{print $2}'`
    $ svn st |grep ? |awk '{print $2}' |xargs svn add 
    

  * the first mehod only ran svn 1 time. 
  * the second need run svn many times 

