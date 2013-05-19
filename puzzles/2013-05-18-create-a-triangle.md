---
title: How to create a triangle?
tags: Triangle, Haskell
---





## Haskell version 
  
  use tuples with filter 

``` haskell
let rightTriangles = [ (a,b,c) | c <- [1..10],b <- [1..c], a <- [1..b], a^2 +b^2 == c^2]
```

## PHP version

``` php
for ($c = 1; $c < 11; $c ++) {
  for ($b =1; $b < $c; $b++) {
    for ($a = 1; $a < $b; $a ++) {
      if (($a*$a + $b*$b)  == $c*$c) {
        echo "($a, $b, $c) ";
      }
    }
  }
}
```


