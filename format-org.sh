#!/bin/bash

file="`git status -s |grep "posts/"|awk '{print $2}'`"
for file in $file; do 
  cat $file |sed -e 's/title: /title: test-format-/g' > tmp; mv tmp $file;
done

