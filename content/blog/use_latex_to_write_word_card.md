+++
title = "用 Latex 做识字卡片"
author = ["eggcaker"]
date = 2020-03-21T10:08:00+08:00
draft = false
creator = "Emacs 27.0.90 (Org mode 9.4 + ox-hugo)"
+++

最近因为没有什么事，折腾了一下 Latex, 主要的原因也是因为在网上看到了一个人用 Latex
做了[识字卡片](https://c-tan.com/zh/post/latex-hanzi-gezi/)，第一眼看到真心的觉得好漂亮，但是按照作者说的

> 由于是自用， 因此我希望这套排版是独一无二的， 所以也就不放出源码了。
> 其实基本上看到效果就可以猜出用了哪些宏包。

人啊，都是越得不到的越想得到。因为这位朋友不想开源，所以也就想照着图片从零开始撸。
因为电脑里本身就有 MacTex, 安装就省了，直接开始 style 定制，也许过些日子应该好
好整理一下写写 Latex 的环境配置。

其实今天想写个博客记录一下是因为今天早上花了 2 小时解决了个让人抓狂的小 bug, 就是
[tcolorbox](https://ctan.org/pkg/tcolorbox?lang=en) 标题高度问题。这个是有问题的展示

{{< figure src="/ox-hugo/tcolorbox_height_bug.png" >}}

可以看到，第一行的中和下的标题拼音不一样高，因为我在定义高度的时候，给了标题一个
上下的距离，其实后来测试发现，不加这个距离也是一样的，因为标题的高度是根据文字的
高度来的。这里应为 `xia` 所有字的高度都没有 `zhong` 高，导致高度不一致。今天早上
在 SO 里挨着个的看 tcolorbox 的相关的问题。最后找到了[这个](https://tex.stackexchange.com/questions/435486/enforce-total-height-of-tcolorbox-title)。效果：

{{< figure src="/ox-hugo/tcolorbox_height_fix.png" >}}

一部分代码：

```latex
\chapter{方向位置}

\section*{\kaishu{上下左右 }}
\label{sec:lesson01}

\subsection{上下左右}
\label{sec:subsec:l1_s1}

\card{shang4}{上} \card{zhong1}{中} \card{xia4}{下}

\card{ren2}{人} \card{kou3}{口} \card{shou3}{手}
```

[代码](https://github.com/eggcaker/duolingo-with-latex) Yoo!
