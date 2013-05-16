---
title: Code Highlighting with OrgRuby 
layout: 'post'
author: 'eggcaker'
date: '2012-02-27'
categories: blog 2012
tags: ['Jekyll','orgmode']
---


Code highlight with org-ruby by [wallyqs](https://github.com/wallyqs/org-
ruby/commit/c4c4817a97f4387df505683060d11ac91308c0c3)

    
    1000.times do |t|
      puts t + ": Hello!"
      html = <<HTML-
      <h1> Html header </h1>
    HTML
    
      puts "Syntax is highlighted"
    end
    
    
    import mapnik
    
    m = mapnik.Map(600, 800)
    

