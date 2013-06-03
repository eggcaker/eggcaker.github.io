---
title: first the last element of a list
tags: hakell
---
<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">Haskell version</a></li>
</ul>
</div>
</div>


<div id="outline-container-sec-1" class="outline-2">
<h2 id="sec-1">Haskell version</h2>
<div class="outline-text-2" id="text-1">
<pre class="example">
myLast [x] = x
myLast (_:xs) = myLast xs
myLast' = foldr1 (const id)

myLast'' = foldr1 (flip const)
 
myLast''' = head . reverse
 
myLast'''' = foldl1 (curry snd)
 
myLast''''' [] = error "No end for empty lists!"  
myLast''''' x = x !! (length x -1)
</pre>
</div>
</div>
