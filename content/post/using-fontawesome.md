---
title: "Using Font Awesome"
date: 2017-11-26T20:09:19-05:00
categories:
- fonts
- macros
tags:
- Font Awesome
- symbols
---

[Font Awesome] is a font that provides pictographic icons and is commonly used
to display icons for email, editing tasks, popular social media website, etc.
It is easy to use Font Awesome in ConTeXt: the font ships with [ConTeXt
Standalone] and ConTeXt includes a `symbolset` to easily access the icons
using names rather than icon numbers. 

To use FontAwesome icons in ConTeXt, simply load the symbolset `fontawesome`
using

<pre><code><span class="Identifier">\usesymbols</span><span class="Delimiter">[</span><span class="Type">fontawesome</span><span class="Delimiter">]</span></code></pre>

and then any icon is accessible using

<pre><code><span class="Statement">\symbol</span><span class="Delimiter">[</span>fontawesome<span class="Delimiter">][</span>...<span class="Delimiter">]</span>

where `...` is the name of the icon is listed in [the Font Awesome icon list][Font Awesome].

<!--more-->

Recently, I wanted to use Font Awesome icons in a document that was typeset
with [CharisSIL] at 11pt and there was a size mismatch between the text
font and font awesome icons. It took me some time to figure out how to scale
the icons so that the result looks good, so I am writing this blog post as a
reference for my future self. 

Almost all Font Awesome symbols are fixed width, so I decided to simply scale
the height of the font to be equal to `1em`. This can be done using

<pre><code><span class="Statement">\scale</span><span class="Delimiter">[</span>height=<span class="Number">1em</span><span class="Delimiter">]{</span>...<span class="Delimiter">}</span>
</code></pre>

The tricky part was to ensure that the symbol sits at the right location on
the baseline. After a bit of trial and error—and skimming through
[supp-box.mkiv]—the best solution was to use:

<pre><code><span class="Statement">\inlinedbox</span><span class="Delimiter">{</span><span class="Statement">\scale</span><span class="Delimiter">[</span>height=<span class="Number">1em</span><span class="Delimiter">]{</span>...<span class="Delimiter">}}</span>
</code></pre>

Here is a complete example:

<!--
\definetypeface[mainfont][rm][specserif][CharisSil][default]
\definetypeface[mainfont][mm][math] [pagellaovereuler][default]
\definetypeface[mainfont][tt][mono] [dejavu][default] [rscale=0.8, features=none]
\setupbodyfont[mainfont,11pt]
\usesymbols[fontawesome]

\define\FA{\dosingleargument\doFA}
\def\doFA[#1]{\inlinedbox
    {\scale[height=1em]{\symbol[fontawesome][#1]}}}

\starttext
Checked box \FA[check-square-o] 
Unchecked box \FA[square-o]
\stoptext
-->

<pre><code><span class="Identifier">\definetypeface</span><span class="Delimiter">[</span><span class="Type">mainfont</span><span class="Delimiter">][</span><span class="Type">rm</span><span class="Delimiter">][</span><span class="Type">specserif</span><span class="Delimiter">][</span><span class="Type">CharisSil</span><span class="Delimiter">][</span><span class="Type">default</span><span class="Delimiter">]</span>
<span class="Identifier">\definetypeface</span><span class="Delimiter">[</span><span class="Type">mainfont</span><span class="Delimiter">][</span><span class="Type">mm</span><span class="Delimiter">][</span><span class="Type">math</span><span class="Delimiter">] [</span><span class="Type">pagellaovereuler</span><span class="Delimiter">][</span><span class="Type">default</span><span class="Delimiter">]</span>
<span class="Identifier">\definetypeface</span><span class="Delimiter">[</span><span class="Type">mainfont</span><span class="Delimiter">][</span><span class="Type">tt</span><span class="Delimiter">][</span><span class="Type">mono</span><span class="Delimiter">] [</span><span class="Type">dejavu</span><span class="Delimiter">][</span><span class="Type">default</span><span class="Delimiter">] [</span><span class="Type">rscale=0.8, features=none</span><span class="Delimiter">]</span>
<span class="Identifier">\setupbodyfont</span><span class="Delimiter">[</span><span class="Type">mainfont,11pt</span><span class="Delimiter">]</span>
<span class="Identifier">\usesymbols</span><span class="Delimiter">[</span><span class="Type">fontawesome</span><span class="Delimiter">]</span>

<span class="Identifier">\define</span><span class="Statement">\FA</span><span class="Delimiter">{</span><span class="Statement">\dosingleargument\doFA</span><span class="Delimiter">}</span>
<span class="Character">\def</span><span class="Statement">\doFA</span><span class="Delimiter">[</span>#1<span class="Delimiter">]{</span><span class="Statement">\inlinedbox</span>
    <span class="Delimiter">{</span><span class="Statement">\scale</span><span class="Delimiter">[</span>height=<span class="Number">1em</span><span class="Delimiter">]{</span><span class="Statement">\symbol</span><span class="Delimiter">[</span>fontawesome<span class="Delimiter">][</span>#1<span class="Delimiter">]}}}</span>

<span class="PreProc">\starttext</span>
Checked box <span class="Statement">\FA</span><span class="Delimiter">[</span>check-square-o<span class="Delimiter">]</span>
Unchecked box <span class="Statement">\FA</span><span class="Delimiter">[</span>square-o<span class="Delimiter">]</span>
<span class="PreProc">\stoptext</span>
</code></pre>

which gives

{{< img src="fontawesome-2.png" class="center" alt="Output showing Font Awesome" >}}


[CharisSIL]: https://software.sil.org/charis/

[Font Awesome]: http://fontawesome.io/icons/
[ConTeXt Standalone]: http://wiki.contextgarden.net/ConTeXt_Standalone
[supp-box.mkiv]:
https://github.com/contextgarden/context-mirror/blob/beta/tex/context/base/mkiv/supp-box.mkiv#L1515
