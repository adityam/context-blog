---
title     : "Seamlessly switching between different context versions"
linktitle : "Switching between different context versions"
date  : 2019-04-11
tags  :
  - setuptex
  - context standalone
  - luametatex
categories :
  - installation
---

Recently, Hans
[announced](https://www.mail-archive.com/ntg-context@ntg.nl/msg90783.html) the
prerelease of a new version of ConTeXt called LuaMetaTeX or LMTX for short.
LMTX is supposed to a streamlined and stripped down version of LuaTeX where
most of the backend code for writing PDF and images has been removed from the
engine and is handled by macro package using Lua code. Some of the rationale
for the change in discussed [in this
post](https://www.mail-archive.com/ntg-context@ntg.nl/msg90917.html) and more
details including the source code and documentation will be available when
LMTX will be formally released in this year's ConTeXt meeting. Currently just
the binary is available for testing from [Pragma Ade's
website](http://www.pragma-ade.nl/install.htm). There is no change in
user-facing code, so in principle, one can simply switch from ConTeXt MkIV to
LMTX without making any change in the tex file. 

In my tests so far, I could compile all my documents using LMTX without any
noticeable difference. Nonetheless, I want to keep ConTeXt MkIV around for
some critical projects like typesetting material for courses that I teach.
In this post, I'll explain my setup for using ConTeXt MkIV and LMTX in
parallel.

<!--more-->

[ConTeXt standalone
distribution](https://wiki.contextgarden.net/ConTeXt_Standalone) is a portable
distribution (i.e., it can be "installed" in any directory) that works by
`$PATH` munging. In particular, if the installation has been downloaded in say
`<install-dir>`, then all one needs to do (on linux) is set the `$PATH` variable to

```
PATH=<install-dir>/tex/texmf-linux-64/bin:$PATH
```

Then simply call `context filename` to compile a file, and ConTeXt figures out the
location of rest of the `$TEXMF` tree based on the locaiton of the `luatex`
(or `luametatex`) binary. ConTeXt comes with a helper script called `setuptex`
to help with the PATH munging. So, to use ConTeXt standalone, one simply calls

```
source <install-dir>/tex/setuptex
```

and then just call `context filename`. Currently LMTX does't come with a
`setuptex` file but it is straight forward to simply copy the `setuptex` file
that comes with ConTeXt standalone and change the path so that it points at
the LMTX bin directory. 

So far so good. However, when I started using MKIV and LMTX in parallel, it
was easy to forget which `setuptex` file I had sourced and which version of
ConTeXt I was using. To avoid this confusion, I came up with the following
variation of the `setuptex` file:

```
_OLD_PS1=$PS1
_OLD_PATH=$PATH
TEXMFOS=/opt/context-minimals/texmf-linux-64
export TEXMFOS

TEXMFCACHE=$HOME/.cache/context-minimals
export TEXMFCACHE

PATH=$TEXMFOS/bin:$PATH
export PATH

PS1="(ctx) $PS1"
export PS1

OSFONTDIR="$HOME/.fonts;/usr/share/fonts;" 
export OSFONTDIR
resettex () {
    PATH=$_OLD_PATH
    export PATH
    unset _OLD_PATH
    
    PS1=$_OLD_PS1
    export PS1
    unset _OLD_PS1
    
    unset -f resettex
}
```

This has the following additional features. 

1. It adds a tag (I use `ctx` for MKIV and `lmtx` for LMTX) before the
   terminal prompt). So, it is easy to see which which version of ConTeXt I am
   using.

2. It defines a function `resettex` that resets the value of PATH to its
   original value (before `setuptex` was called). 

Both these features are inspired by the virtualenv setup for Python. 

Here is a screencast showing this feature in action.

<link rel="stylesheet" type="text/css" href="/context-blog/css/asciinema-player.css" />
 

<asciinema-player src="setuptex-ascii.cast" cols=84 rows=42 speed=2.5 poster="npt:0:1" theme="monokai"></asciinema-player>

PS: If you use Archlinux that you can install [`context-minimals-git`][context]
and [`luametatex`][lmtx] packages (which I maintain) from AUR and these
packages automatically create the above setuptex file.

<script src="/context-blog/js/asciinema-player.js"></script>

