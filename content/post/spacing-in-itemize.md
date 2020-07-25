---
title     : "Adjust spacing in itemize environments"
linktitle : "Spacing in itemize"
date  : 2020-07-25
tags  :
  - itemize
  - spacing
categories :
  - Formatting
---

Today I was working on a LaTeX doc and needed to adjust spacing around the
LaTeX itemize environment. I wanted a list of item with no space before the
list environment and the list of items, no space between the items, but space
after the environment. The [TeX FAQ][FAQ] has a summary of how to adapt
spacing around itemize environment in LaTeX. Reading that made me appreciate
the control provided by ConTeXt. So, I thought that it is worthwhile to show
that.

[FAQ]: https://www.texfaq.org/FAQ-complist

<!--more-->

Let's start with the default spacing. I am going to use the following sample
document. 

<pre><code><span class="Identifier">\usemodule</span><span class="Delimiter">[</span><span class="Type">visual</span><span class="Delimiter">]</span>
<span class="PreProc">\starttext</span>
<span class="Statement">\fakewords</span><span class="Delimiter">{</span>20<span class="Delimiter">}{</span>25<span class="Delimiter">}</span>
<span class="Keyword">\startitemize</span>
  <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>4<span class="Delimiter">}{</span><span class="Statement">\item</span> <span class="Statement">\fakewords</span><span class="Delimiter">{</span>10<span class="Delimiter">}{</span>15<span class="Delimiter">}}</span>
<span class="Keyword">\stopitemize</span>
<span class="Statement">\fakewords</span><span class="Delimiter">{</span>20<span class="Delimiter">}{</span>25<span class="Delimiter">}</span>
<span class="PreProc">\stoptext</span></code></pre>

which gives:

{{< img src="list-default.png" class="center" alt="Itemize with default spacing" >}}

Notice the space before and after the itemize environment and the space
between the items. 

Now, to get no spacing between the items, use:
<pre><code><span class="Keyword">\startitemize</span><span class="Delimiter">[</span><span class="Type">packed</span><span class="Delimiter">]</span>
  <span class="Statement">. . .</span>
<span class="Keyword">\stopitemize</span></code></pre>

which gives:

{{< img src="list-packed.png" class="center" alt="Itemize with packed option" >}}

To get no spacing between the items and no spacing around the environment, use:
<pre><code><span class="Keyword">\startitemize</span><span class="Delimiter">[</span><span class="Type">nowhite</span><span class="Delimiter">]</span>
  <span class="Statement">. . .</span>
<span class="Keyword">\stopitemize</span></code></pre>

which gives:

{{< img src="list-nowhite.png" class="center" alt="Itemize with nowhite option" >}}

Sometimes, this is too tight. To add spacing after the environment, use
<pre><code><span class="Keyword">\startitemize</span><span class="Delimiter">[</span><span class="Type">nowhite, after</span><span class="Delimiter">]</span>
  <span class="Statement">. . .</span>
<span class="Keyword">\stopitemize</span></code></pre>

which gives:

{{< img src="list-nowhite-after.png" class="center" alt="Itemize with nowhite and after option" >}}

Finally, to have space before the environment (but not after), use:

<pre><code><span class="Keyword">\startitemize</span><span class="Delimiter">[</span><span class="Type">nowhite, before</span><span class="Delimiter">]</span>
  <span class="Statement">. . .</span>
<span class="Keyword">\stopitemize</span></code></pre>

which gives:

{{< img src="list-nowhite-before.png" class="center" alt="Itemize with nowhite and before option" >}}

That was simple. Now back to trying to wrap my head around the LaTeX spacing
model. 

