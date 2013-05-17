---
title: How stupid I am ? 
layout: 'post'
author: 'eggcaker'
date: '2011-12-13'
categories: blog 2011
tags: Java
---


I just spent 10 minutes to debuging these code below (I reformated the code
better to found where's awesome error I did):

    
    Comparator comparator = new Comparator<Task>() {
    
      @Override
      public int compare(Task t1, Task t2) {
          return Integer.valueOf(t1.getOrder())
      .compareTo(Integer.valueOf(t1.getOrder()));
      }
     };
    
    

just put it here and avoid do this again …

