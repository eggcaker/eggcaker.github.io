---
title: Keyboard not working with Ubuntu 10.04 in VmWare Fusion
layout: 'post'
categories: blog 2010
tags: Linux
date: '2010-10-25'
author: 'eggcaker'
--- 

I just downloaded and installed Ubuntu 10.04 LTS with VMWare Fusion 3. When
the login screen appeared I tried to enter the password but to my great
surprise, nothing happened.

After investigating the matter, it seems like this issue is related to a
vmvare setup script issue.

To fix the problem, first use the on-screen keyboard to log in to Ubuntu.When
you come to the login screen click on the "Universal Access Preferences" (It's
the little guy in the circle) on the bottom toolbar to the left of the date
and time. Then click on the pop-up that says "Universal Access Preferences".
Then put a check mark next to "Use on-screen Keyboard". Reboot and you will
have an on-screen keyboard that works. Once your in to your Gnome desktop the
keyboard works fine.

Then, open up a terminal and type:

    
    $ sudo dpkg-reconfigure console-setup
    

Then follow the on-screen instructions, reboot, and you are good to go!

