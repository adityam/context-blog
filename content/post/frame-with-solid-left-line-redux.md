---
title: "Frame With Solid Left Line Redux"
date: 2019-03-24T12:07:55-04:00
categories:
  - visualization
tags:
  - backgrounds
  - framed
---

As I had [posted earlier](../frame-with-solid-left-line), I like the visual
effect of placing a solid line on the left side of a block:

{{< img src="/context-blog/post/frame-with-solid-left-line/leftframe-0.png" class="center" alt="Simple example" >}}

I use this for displaying short code snippets in the lecture notes of a course
that I teach. Typically these are a few lines of Matlab code but recently I
needed to post a bigger code snippet where the frame should break across the
page. In principle, this should have been a simple change—replace the `framed`
with a `textbackground`—but that did not work out of the box. This blog post
explains a simple solution.

<!--more-->

First, let's start with the naive solution:

<!--
\definecolor[darkgray]  [s=0.5]
\definecolor[lightgray] [s=0.95]

\definetextbackground
  [leftbartext]
  [
    location=paragraph,
    frame=on,
    framecolor=darkgray,
    rulethickness=2ex,
    leftoffset=5.25ex,
    rightoffset=2.25ex,
    topoffset=2.25ex,
    bottomoffset=2.25ex,
    background=color,
    backgroundcolor=lightgray,
  ]
-->

<pre><code><span class="Statement">\definecolor</span><span class="Delimiter">[</span>darkgray<span class="Delimiter">]</span>  <span class="Delimiter">[</span>s=0.5<span class="Delimiter">]</span>
<span class="Statement">\definecolor</span><span class="Delimiter">[</span>lightgray<span class="Delimiter">]</span> <span class="Delimiter">[</span>s=0.95<span class="Delimiter">]</span>

<span class="Statement">\definetextbackground</span>
  <span class="Delimiter">[</span>leftbartext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>
    location=paragraph,
    frame=on,
    framecolor=darkgray,
    rulethickness=<span class="Number">2ex</span>,
    leftoffset=<span class="Number">5.25ex</span>,
    rightoffset=<span class="Number">2.25ex</span>,
    topoffset=<span class="Number">2.25ex</span>,
    bottomoffset=<span class="Number">2.25ex</span>,
    background=color,
    backgroundcolor=lightgray,
  <span class="Delimiter">]</span>
</code></pre>

`Frame` and `textbackground` handle the offsets differently. Frame adds the
`rulethickness` to the offset, while textbackground does not. So, I have 
manually set the offset in each direction. The above code gives the following
output:

{{< img src="left-frame-0.png" class="center" alt="Frame generated using textbackground" >}}

So far, so good. So, all that we need is to replace `frame=on` with
`frame=off, leftframe=on`. Unfortunately, that does not work. 

<!-- 
\definetextbackground
  [leftbartext]
  [
    location=paragraph,
    frame=off,
    leftframe=on,
    framecolor=darkgray,
    rulethickness=2ex,
    leftoffset=5.25ex,
    rightoffset=2.25ex,
    topoffset=2.25ex,
    bottomoffset=2.25ex,
    background=color,
    backgroundcolor=lightgray,
  ]
-->

<pre><code><span class="Statement">\definetextbackground</span>
  <span class="Delimiter">[</span>leftbartext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>
    ...
    frame=off,
    leftframe=on,
    ...
  <span class="Delimiter">]</span>
</code></pre>

gives

{{< img src="left-frame-1.png" class="center" alt="Frame generated using textbackground" >}}

Notice that the output has no frame! To understand why this happens, we need
to dig a bit into how `textbackground`s work. Most of the heavy lifting for
drawing the background is done by Metapost. The default setting of
textbackground has (in
[`anch-bck.mkvi`](https://github.com/contextgarden/context-mirror/blob/5794d8b0c845aad2ab4cf36dc14201b21ef5a784/tex/context/base/mkiv/anch-bck.mkvi#L515)

<pre><code><span class="Statement">\setuptextbackground</span>
  <span class="Delimiter">[</span>
    ...
    mp=mpos:region:draw,
    ...
  <span class="Delimiter">]</span>
</code></pre>

where `mpos:region:draw` is defined as

<!--
\startuseMPgraphic{mpos:region:draw}
    draw_multi_pars
\stopuseMPgraphic
-->

<pre><code><span class="Statement">\startuseMPgraphic</span><span class="Delimiter">{</span>mpos:region:draw<span class="Delimiter">}</span>
    draw_multi_pars
<span class="Statement">\stopuseMPgraphic</span>
</code></pre>

which simply calls `draw_multi_pars` defined in
[`mp-abck.mpiv`](https://github.com/contextgarden/context-mirror/blob/052a096e160508ddbbbfcbf1522eb8ddbfc3b1cd/metapost/context/base/mpiv/mp-abck.mpiv#L130). The reason that we don't get anything when `frame=off` is because `draw_multi_pars` does not include the code to selectively draw the boundary. `mp-abck.mpiv` also includes another macro called `draw_multi_side` to draw *only* the left boundary. So, we can define the left-bar textbackground as follows:

<!--
\definetextbackground
  [leftbartext]
  [
    location=paragraph,
    mp=mpos:region:leftbar,
    width=broad,
    frame=off,
    framecolor=darkgray,
    rulethickness=2ex,
    leftoffset=5ex,
    rightoffset=2.25ex,
    topoffset=2.25ex,
    bottomoffset=2.25ex,
    background=color,
    backgroundcolor=lightgray,
  ]


\startuseMPgraphic{mpos:region:leftbar}
  draw_multi_pars;
  draw_multi_side;
\stopuseMPgraphic
-->

<pre><code><span class="Statement">\definetextbackground</span>
  <span class="Delimiter">[</span>leftbartext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>
    ..
    mp=mpos:region:leftbar,
    frame=off,
    ..
  <span class="Delimiter">]</span>


<span class="Statement">\startuseMPgraphic</span><span class="Delimiter">{</span>mpos:region:leftbar<span class="Delimiter">}</span>
  draw_multi_pars;
  draw_multi_side;
<span class="Statement">\stopuseMPgraphic</span>
</code></pre>

We don't need to specify `leftframe=on` because `draw_multi_side` only draws
the leftframe. To conclude, here is the complete code:

<pre><code><span class="Statement">\definetextbackground</span>
  <span class="Delimiter">[</span>leftbartext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>
    location=paragraph,
    mp=mpos:region:leftbar,
    width=broad,
    frame=off,
    framecolor=darkgray,
    rulethickness=<span class="Number">2ex</span>,
    leftoffset=<span class="Number">5ex</span>,
    rightoffset=<span class="Number">2.25ex</span>,
    topoffset=<span class="Number">2.25ex</span>,
    bottomoffset=<span class="Number">2.25ex</span>,
    background=color,
    backgroundcolor=lightgray,
  <span class="Delimiter">]</span>


<span class="Statement">\startuseMPgraphic</span><span class="Delimiter">{</span>mpos:region:leftbar<span class="Delimiter">}</span>
  draw_multi_pars;
  draw_multi_side;
<span class="Statement">\stopuseMPgraphic</span>
</code></pre>

As in the case of the definition using `framedtext`, it is straight forward to
inherit from `leftbartext` text background to get backgrounds with different
color:

<!--
\definecolor[lightred]   [0.95(red,white)]
\definecolor[lightgreen] [0.95(green,white)]
\definecolor[lightblue]  [0.95(blue,white)]

\definetextbackground
  [exampletext]
  [leftbartext]
  [
    framecolor=darkgreen,
    backgroundcolor=lightgreen,
  ]

\definetextbackground
  [alerttext]
  [leftbartext]
  [
    framecolor=darkred,
    backgroundcolor=lightred,
  ]

\definetextbackground
  [blocktext]
  [leftbartext]
  [
    framecolor=darkblue,
    backgroundcolor=lightblue,
  ]
-->

<pre><code><span class="Statement">\definecolor</span><span class="Delimiter">[</span>lightred<span class="Delimiter">]</span>   <span class="Delimiter">[</span>0.95(red,white)<span class="Delimiter">]</span>
<span class="Statement">\definecolor</span><span class="Delimiter">[</span>lightgreen<span class="Delimiter">]</span> <span class="Delimiter">[</span>0.95(green,white)<span class="Delimiter">]</span>
<span class="Statement">\definecolor</span><span class="Delimiter">[</span>lightblue<span class="Delimiter">]</span>  <span class="Delimiter">[</span>0.95(blue,white)<span class="Delimiter">]</span>

<span class="Statement">\definetextbackground</span>
  <span class="Delimiter">[</span>exampletext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>leftbartext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>
    framecolor=darkgreen,
    backgroundcolor=lightgreen,
  <span class="Delimiter">]</span>

<span class="Statement">\definetextbackground</span>
  <span class="Delimiter">[</span>alerttext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>leftbartext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>
    framecolor=darkred,
    backgroundcolor=lightred,
  <span class="Delimiter">]</span>

<span class="Statement">\definetextbackground</span>
  <span class="Delimiter">[</span>blocktext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>leftbartext<span class="Delimiter">]</span>
  <span class="Delimiter">[</span>
    framecolor=darkblue,
    backgroundcolor=lightblue,
  <span class="Delimiter">]</span>
</code></pre>

which gives

{{< img src="left-frame-2.png" class="center" alt="text backgrounds with different colors" >}}
