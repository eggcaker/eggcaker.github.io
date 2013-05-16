---
title: "my first awesome plugin for keyll" 
layout: 'post'
author: 'eggcaker'
date: '2011-12-27'
categories: blog 2011
tags: ['Jekyll']
---


First of all, I like the Emacs, I like to use the org-mode to write some
document, by default Jekyll doesn't support the org-mode,
[some](http://orgmode.org/worg/org-tutorials/org-jekyll.html)
[posts](http://juanreyero.com/open/org-jekyll/) explain you to integrate the
org-mode file with Jekyll, but I think maybe a plugin is better and I don't
need generate the org-mode to html file for jekyll. this is first time I try
write ruby code. check the code below :

    
    require 'rubygems' 
    require 'org-ruby' 
    
    module Jekyll
      class OrgConverter < Converter
        safe true
    
        priority :low
    
        def matches(ext)
          ext =~ /org/i
        end  
    
        def output_ext(ext)
          ".html"   
        end
    
        def convert(content)
          Orgmode::Parser.new(content).to_html 
        end
    
      end 
    
      module Filters
        def restify(input)
          site = @context.registers[:site]
          converter = site.getConverterImpl(Jekyll::OrgConverter)
          converter.convert(input)
        end
      end 
    end
    
    

simple, ha? so how can use this plugin ? save the source code to a file in
`_plugins`, then you need install the gem org-ruby if you have not already.

    
    $ sudo gem install org-ruby
    

then you create the post like create a markdown file just named it with .org,
this all you need to do.

  * `[X]` add code highlight support check out wallyqs's [repo](https://github.com/wallyqs/org-ruby/tree/code_syntax_highlight)
  * `[X]` extract this file to a repo and commit to jekyll plugin list check out : [jekyll-org](http://github.com/eggcaker/jekyll-org)

