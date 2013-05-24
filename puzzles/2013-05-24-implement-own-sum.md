---
title: Implement own sum function in deferent langurages
tags: Haskell, PHP
---

### with Haskell

use fold

~~~~{.haskell}
sum' xs = foldl (\acc x -> acc + x) 0 xs
~~~~

### PHP version

in php there are a function call `array_reduce`, from php doc:
>Iteratively reduce the array to a single value using a callback function

~~~~{.php}

function sum'($arr) {
 return array_reduce($arr, function($n,$w) {$n+= $w; return $n;});
}
~~~~


### the simple for loop with java syntax

~~~~{.java}

int total = 0;

for (int i= 0; i< arr.length();i++) {
  total += arr[i]; 
}

~~~~
