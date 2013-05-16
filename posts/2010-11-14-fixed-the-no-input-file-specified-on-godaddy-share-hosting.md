---
title: fixed the No input file specified on godaddy share hosting
layout: 'post'
categories: blog 2010
tags: ['Website']
date: '2010-11-14'
--- 

Hello folks,

Recently I has was troubleshooting this errror on godaddy share hosting and
found cool solution for it .When I brose my pages after index.php page, it
give me a error message of no input file specified.

The solution is, add foolowing code to .htaccess file :

    
    RewriteEngine on^M
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ /index.php?$1 [L]
    
    

Cheers!




