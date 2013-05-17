---
title: Becareful the heredoc!
layout: 'post'
categories: blog 2010
tags: PHP
author: 'eggcaker'
date: '2010-10-20'
--- 

Today , I spent half hour to find a bug, it said , Parse error: syntax error,
unexpected ']', expecting `T_STRING` or `T_VARIABLE` or `T_NUM_STRING` in xx
line, i check that lline all words , on by one , cannot find the problem where
it is , even i remove them , still has some error , check all file line by
line , i found it!

because i run a function of emacs to indent line, so EOQ not in the very begin
of line!

I'm so stupid!

