---
title: "Frame with solid left line"
date: 2017-08-18T00:40:19-04:00
categories:
- visualization
tags:
- backgrounds
- framed

---

Adding a solid line on the left side of a frame, block quote, etc. creates a
simple, clean, and attractive visual effect that I like. 

{{< img src="/context-blog/post/frame-with-solid-left-line/leftframe-0.png" class="center" alt="Simple example" >}}

I don't know when I first came across this style, but it is used commonly on
the Internet to show blockquotes. So, how do we get this style with ConTeXt?

<!--more-->

It is pretty straight-forward to get this effect. All we need is, well,
define a frame with a left border. For example, the above image was obtained
using:

<!--
\definecolor[darkgray]  [s=0.5]
\definecolor[lightgray] [s=0.95]

\defineframedtext
  [leftbartext]
  [
    width=broad,
    frame=off,
    framecolor=darkgray,
    leftframe=on,
    rulethickness=2ex,
    offset=0.25ex,
    loffset=3ex, 
    background=color,
    backgroundcolor=lightgray,
  ]
-->

<pre><code><span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">darkgray</span><span class="Delimiter">]  [</span><span class="Type">s=0.5</span><span class="Delimiter">]</span>
<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">lightgray</span><span class="Delimiter">] [</span><span class="Type">s=0.95</span><span class="Delimiter">]</span>

<span class="Identifier">\defineframedtext</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">leftbartext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    width=broad,</span>
<span class="Type">    frame=off,</span>
<span class="Type">    framecolor=darkgray,</span>
<span class="Type">    leftframe=on,</span>
<span class="Type">    rulethickness=2ex,</span>
<span class="Type">    offset=0.25ex,</span>
<span class="Type">    loffset=3ex, </span>
<span class="Type">    background=color,</span>
<span class="Type">    backgroundcolor=lightgray,</span>
<span class="Type">  </span><span class="Delimiter">]</span>
</code></pre>

and then use it as

<!--
\startleftbartext
...
\stopleftbartext
-->

<pre><code><span class="Keyword">\startleftbartext</span>
...
<span class="Keyword">\stopleftbartext</span>
</code></pre>

It is also straight forward to inherit from the `leftbartext` frame defined
above to get frames with different colors:


<!--
\definecolor[darkred]   [r=0.8]
\definecolor[darkgreen] [g=0.8]
\definecolor[darkblue]  [b=0.8]

\definecolor[lightred]   [0.95(red,white)]
\definecolor[lightgreen] [0.95(green,white)]
\definecolor[lightblue]  [0.95(blue,white)]

\defineframedtext
  [exampletext]
  [leftbartext]
  [
    framecolor=darkgreen,
    backgroundcolor=lightgreen,
  ]

\defineframedtext
  [alerttext]
  [leftbartext]
  [
    framecolor=darkred,
    backgroundcolor=lightred,
  ]

\defineframedtext
  [blocktext]
  [leftbartext]
  [
    framecolor=darkblue,
    backgroundcolor=lightblue,
  ]

-->

<pre><code><span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">darkred</span><span class="Delimiter">]   [</span><span class="Type">r=0.8</span><span class="Delimiter">]</span>
<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">darkgreen</span><span class="Delimiter">] [</span><span class="Type">g=0.8</span><span class="Delimiter">]</span>
<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">darkblue</span><span class="Delimiter">]  [</span><span class="Type">b=0.8</span><span class="Delimiter">]</span>

<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">lightred</span><span class="Delimiter">]   [</span><span class="Type">0.95(red,white)</span><span class="Delimiter">]</span>
<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">lightgreen</span><span class="Delimiter">] [</span><span class="Type">0.95(green,white)</span><span class="Delimiter">]</span>
<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">lightblue</span><span class="Delimiter">]  [</span><span class="Type">0.95(blue,white)</span><span class="Delimiter">]</span>

<span class="Identifier">\defineframedtext</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">exampletext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span><span class="Type">leftbartext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    framecolor=darkgreen,</span>
<span class="Type">    backgroundcolor=lightgreen,</span>
<span class="Type">  </span><span class="Delimiter">]</span>

<span class="Identifier">\defineframedtext</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">alerttext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span><span class="Type">leftbartext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    framecolor=darkred,</span>
<span class="Type">    backgroundcolor=lightred,</span>
<span class="Type">  </span><span class="Delimiter">]</span>

<span class="Identifier">\defineframedtext</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">blocktext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span><span class="Type">leftbartext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    framecolor=darkblue,</span>
<span class="Type">    backgroundcolor=lightblue,</span>
<span class="Type">  </span><span class="Delimiter">]</span>
</code></pre>

which give the following three frames

{{< img src="leftframe-2.png" class="center" alt="Green colored left frame" >}}
{{< img src="leftframe-1.png" class="center" alt="Red colored left frame" >}}
{{< img src="leftframe-3.png" class="center" alt="Blue colored left frame" >}}

