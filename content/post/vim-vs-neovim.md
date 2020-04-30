---
title     : "t-vim: A tale of two editors"
linktitle : "Vim vs Neovim"
date  : 2020-04-29T17:12:21-04:00
tags  :
  - t-vim
  - efficiency

categories :
  - Formatting
---

Since I am looking at merging a few pull requests for `t-vim`, I thought that
this will also be a good time to implement a simple feature that was on hold
for a while: the ability to use the module with [Neovim] instead of `vim`.

[Neovim]: https://neovim.io/

<!--more-->

Neovim is the new kid on the block, with the tag line of _Rebuilding Vim for
the 21st century_. Neovim modernizes the vim codebase with the objective of
making it easier to write plugins and customizations at the cost of removing
support for old platforms and esoteric features of Vim. I will not go into the
political debate of which philosophy is better. 

For the most part, neovim is backward compatible with vim. So, in principle,
it should be straight forward to use neovim as a backend for `t-vim`. I just
released a new version of `t-vim`, which makes this possible. 

<pre><code><span class="Identifier">\setupvimtyping</span><span class="Delimiter">[</span><span class="Type">vimcommand=nvim</span><span class="Delimiter">]</span></code></pre>

As a side effect, it is now also possible to call the module if `vim` (or
`nvim`) are not in `$PATH`. 

<pre><code><span class="Identifier">\setupvimtyping</span><span class="Delimiter">[</span><span class="Type">vimcommand=/path/to/vim</span><span class="Delimiter">]</span></code></pre>

## Speed tests

So, how do vim and neovim compare in running `2context.vim`. I did a few tests
and it turns out that the startup time of both of them are similar, but `nvim`
is 7-10% faster in processing `2context.vim` for medium sized files. For
example, with a 500 line matlab file, this is the amount of time for `vim` to
process the file:

```
times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.007  000.007: --- VIM STARTING ---
000.141  000.134: Allocated generic buffers
000.239  000.098: locale set
000.269  000.030: GUI prepared
000.274  000.005: clipboard setup
000.280  000.006: window checked
000.777  000.497: inits 1
000.910  000.133: parsing arguments
000.912  000.002: expanding arguments
000.950  000.038: shell init
001.005  000.055: inits 2
001.229  000.224: init highlight
001.231  000.002: sourcing vimrc file(s)
001.252  000.021: inits 3
001.254  000.002: setup clipboard
001.256  000.002: setting raw mode
001.256  000.000: start termcap
001.787  000.531: opening buffers
001.789  000.002: BufEnter autocommands
001.790  000.001: editing files in windows
003.192  001.173  001.173: sourcing /usr/share/vim/vim82/syntax/syncolor.vim
003.362  001.441  000.268: sourcing /usr/share/vim/vim82/syntax/synload.vim
003.408  001.563  000.122: sourcing /usr/share/vim/vim82/syntax/manual.vim
013.617  010.022  010.022: sourcing /usr/share/vim/vim82/syntax/matlab.vim
1184.729  1170.948  1170.948: sourcing /opt/luametatex/texmf-modules/tex/context/third/vim/2context.vim
```
Note that most of the time (1.17 sec out of 1.18 sec) is spent in processing
the `2context.vim` script. Starting up `vim` until that point just takes `0.13
sec`). Now, let's check `nvim`:

```
times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.010  000.010: --- NVIM STARTING ---
000.453  000.442: locale set
000.832  000.380: inits 1
000.855  000.022: window checked
000.949  000.094: parsing arguments
001.011  000.063: expanding arguments
001.017  000.006: inits 2
001.855  000.837: init highlight
001.977  000.123: sourcing vimrc file(s)
001.999  000.022: inits 3
002.001  000.002: reading ShaDa
002.480  000.479: opening buffers
002.483  000.004: BufEnter autocommands
002.485  000.002: editing files in windows
003.040  000.338  000.338: sourcing /usr/share/nvim/runtime/syntax/syncolor.vim
003.192  000.590  000.252: sourcing /usr/share/nvim/runtime/syntax/synload.vim
003.229  000.693  000.103: sourcing /usr/share/nvim/runtime/syntax/manual.vim
003.784  000.379  000.379: sourcing /usr/share/nvim/runtime/syntax/matlab.vim
1014.988  1011.055  1011.055: sourcing /opt/luametatex/texmf-modules/tex/context/third/vim/2context.vim

[^1]: A notable exception is `init highlight` where nvim is about 4 times slower than vim!
