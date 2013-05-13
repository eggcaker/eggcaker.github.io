---
title: "How unescape a string in php"
layout: 'post'
categories: blog 2010
tags: ['PHP']
date: '2010-10-15'
author: 'eggcaker'
---
  
check out the code below: 

    function utf8_urldecode($str)
    {
        $str = preg_replace("/%u([0-9a-f]{3,4})/i","&#x\\1;",urldecode($str));
        return html_entity_decode($str,null,'UTF-8');;
    }
    
    

