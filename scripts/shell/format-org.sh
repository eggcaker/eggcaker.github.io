#!/bin/bash

file="`git status -s |grep "posts/"|awk '{print $2}'`"
for file in $file; do 

ls="`cat $file | grep -n "^\-\-\-" |awk -F: '{print $1}'`";
sl=$(echo $ls|awk '{print $1}');
el=$(echo $ls|awk '{print $2}');
tl=$(cat $file |wc -l );

cat $file |head -n $(expr $sl - 1) > toc;
cat $file |head -n $el |tail -n $(expr $el - $sl + 1)  > meta
cat $file |tail -n $(expr $tl - $el) > content

cat meta > tmp;
cat toc >> tmp;
cat content >> tmp;

mv tmp $file;

rm meta; 
rm toc;
rm content;

done

