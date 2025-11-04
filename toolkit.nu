export def main [] {

}

export def create-post [...titles] {

  let title = $titles |str join ' '
  let file_name = $title | str kebab-case | $"($in).mdx"
  let today = date now |format date '%Y-%m-%d'
  $"---
title: ($title)
date: '($today)'
excerpt: ($title)
---" |save -f $"./src/content/posts/($file_name)"

  zed $"./src/content/posts/($file_name)"

}
