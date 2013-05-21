---
title: PELM
---

PELM - a "literate" Emacs Lisp Manager for Emacs (24.0 and greater).

What's the P means? the P can be one of Personal or Public (if you like it) I hope every body like it, but maybe not. any fork is welcome!

## Install

clone source code from github to .emacs.d

~~~~{.bash}
$ cd ~  
$ git clone http://github.com/eggckaer/pelm.git .emacs.d  
$ cd .emacs.d  
$ git submodule init  
$ git submodule update  
~~~~

 or , clone source code to some where in your folder and ln it for example, you want clone to ~/pelm

```{.bash}
$ git clone http://github.com/eggcaker/pelm.git ~/pelm  
$ ln -s ~/pelm ~/.emacs.d   
$ cd ~/pelm  
$ git submodule init  
$ git submodule update  
```

when you start emacs at first time after you cloned the PELM, you may get warning from el-get 
install package, just ignore that, exit emacs and reopen Emacs.


Byte compile (optional but recommented)

~~~~{.lisp}
C-u 0 M-x byte-recompile-directory
~~~~

## Customize

after you clone the PELM, check the init.el, you can add your own code in 2 files :

- pre-init-local.org

    the PELM loaded it before load plugins but after the pre-init.el

- post-init-local.org
  
  the PELM loaded after all plugins
  
  
both of them ignore by git, so can add some experimental code.

## Dpendencies 
 - libtool
 - g++ 
 - libglib2.0-dev
 - libgmime-2.6-dev
 - php5 ( for stock bin)
 - libxapian-dev
 - texinfo

## License
   MIT


## Scripts

### script for import snippet

~~~~{.bash}

#!/bin/bash

for file in *.snippet; do 
    #mv $file "`echo $file|sed -e 's/sublime-//g'`" ;
    desc="`cat $file |grep '</description>'| sed -e 's/<description>\(.*\)<\/description>/\1/g'`";
    key="`cat $file |grep '<\/tabTrigger>'| sed -e 's/<tabTrigger>\(.*\)<\/tabTrigger>/\1/g'`";

    echo "# -*- mode: snippet -*-" > tmp;
    echo "# contributor : eggcaker <eggcaker@gmail.com>" >> tmp;
    echo "# name : $desc" >> tmp;
    echo "# key : $key" >> tmp;
    echo "# --" >> tmp;

    awk '/CDATA\[/,/]]/ {print $1;}' $file |sed -e 's/<content><!\[CDATA\[//g'|sed -e 's/\]\]><\/content>//g'  > tmp2;

    sed '/^$/d' tmp2 >> tmp;

    mv tmp $file;
    rm tmp2

done

~~~~
