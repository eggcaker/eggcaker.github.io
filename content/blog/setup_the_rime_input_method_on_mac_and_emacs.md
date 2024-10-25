+++
title = "折腾一下输入法"
author = ["eggcaker"]
date = 2020-03-07T22:25:00+08:00
draft = false
creator = "Emacs 26.3 (Org mode 9.4 + ox-hugo)"
+++

印象中应该是 99 年暑假的时候，在县城的一个学校里开始学的五笔，一直到现在大概有二
十年了，有一段时间还把手机里的输入法设置成了五笔。那时候的感觉就是一时用一时爽、
一直用一直爽。但是最近两年也许是年纪大了的缘故，总感觉有时候很熟悉的一个字突然想
不起来了，是那种一点也想不起来什么样子的。所以想着重新试试拼音类输入法

既然说的是要折腾那就得找个有玩儿头的东西[Rime](https://rime.im)，这个东西可以说是个输入法框架，所有
的东西都是可配置的，每个平台有自己相应的输入法实现，我用到人就是 mac 和 Emacs 了。搞
起来才知道真的坑啊！


## mac 系統 {#mac-系統}

苹果系统下还算简单，苹果下的官方输入法实现叫【鼠鬚管】。基本上按照[安装指南](https://github.com/rime/squirrel/blob/master/INSTALL.md)，基本
上没有什么坑就可以使用了。然后按照官方的提示可以用[plum](https://github.com/rime/plum)，基本上就按照默认安装就
可以用了。其实就是多了一些默认的配置文件，然后在配置文件里把
`default_custom.yaml` 改成自己需要的就可以了。

```yaml
 patch:
  menu:
    page_size: 8
  schema_list:
  - schema: luna_pinyin_simp     # 朙月拼音 简化字
  - schema: luna_pinyin_fluency   # 语句流
  - schema: double_pinyin_flypy   # 小鶴雙拼
  - schema: wubi_pinyin          # 五笔拼音混合輸入
```

这里的配置是相当于顺序开启配置是相当于顺序开启了 4 种输入法方案，默认是简体中文输入法。


## Emacs 配置 {#emacs-配置}

Emacs 的配置相对来说就要复杂一些了，需要安装的东西有：

-   [pyim](https://tumashu.github.io/pyim/)
-   [fcitx](https://github.com/cute-jumper/fcitx.el)
-   [liberime](https://github.com///merrickluo/liberime)
-   [fcitx-remote-fox-osx](https://github.com/xcodebuild/fcitx-remote-for-osx)

我现在用的是 doom emacs，所以创建了个 [private module](https://github.com/eggcaker/.doom.d/blob/develop/modules/private/my-chinese/) 来配置 pyim，大部分的代码都
是从 doom 的 chinese module 里抄过来的。从 pyim 的作者那里也抄了一些，只是绑定了个
新的快捷键用来切换英文到中文

```elisp
(map! "C-M-s-i" 'pyim-convert-code-at-point)
```

这里的 `C-M-s` 其实是 Capslock, 只是做了个 mappping, 用到的软件是
Karabiner-Elements, 所有配置好后，发现了个问题就是在切换打开输入法后只能输入英语，
后来发现是 fcitx-remote-for-osx 的原因，就像文档里说的，不能用 brew 安装，只能自己
编译。
