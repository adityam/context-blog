---
title     : "Include multi-page PDF"
date  : 2020-08-19
tags  :
  - externalfigure
  - include
categories :
  - luatex
---

As an academic, I often have to write letters and grant applications where I
need to need to prepare a single PDF which includes the letter or the grant
application with one of more research papers "attached" at the end. In
principle, I could generate the letter/grant separately and use a tool such as
`qpdf` to merge multiple files into a single file. But I find it much easier
to generate everything from a single tex file.

<!--more-->

To do so, I need a macro to include all the pages of the PDF. 
ConTeXt provides three commands to include multipage external PDFs:

 * [`\filterpages`](https://wiki.contextgarden.net/Command/filterpages)
 * [`\insertpages`](https://wiki.contextgarden.net/Command/insertpages)
 * [`\copypages`](https://wiki.contextgarden.net/Command/copypages)

but none of them really fit my needs. First, they place the content as a layer
on the current page (so the headers and footer of the current document are
still shown). Second, I need to know the number of pages in the PDF. In
principle, I could circumvent these limitation, but in the end it was much
simpler to just define a new macro `\includePDF` which simply includes all the
pages of the PDF:

<pre><code><span class="Identifier">\startluacode</span>
  includePDF = <span class="Function">function</span>(file)
  <span class="Identifier">print</span>(<span class="String">&quot;&gt;&gt;&gt;&quot;</span>, file)
  <span class="Statement">local</span> document = lpdf.epdf.<span class="Identifier">load</span>(file)
  <span class="Statement">local</span> pages = #document.pages
    <span class="Repeat">for</span> i=1,pages <span class="Statement">do</span>
      context.startTEXpage()
      context.externalfigure(<span class="Structure">{</span>file<span class="Structure">}</span>, <span class="Structure">{</span>page=i<span class="Structure">}</span>)
      context.incrementcounter<span class="Structure">{</span><span class="String">&quot;userpage&quot;</span><span class="Structure">}</span>
      context.stopTEXpage()
    <span class="Statement">end</span>
  <span class="Function">end</span>


  interfaces.implement <span class="Structure">{</span>
      name      = <span class="String">&quot;includePDF&quot;</span>,
      arguments = <span class="Structure">{</span> <span class="String">&quot;string&quot;</span> <span class="Structure">}</span>,
      actions   = includePDF,
  <span class="Structure">}</span>
<span class="Identifier">\stopluacode</span>

<span class="Character">\unprotect</span>
<span class="Character">\unexpanded\def</span><span class="Statement">\includePDF</span><span class="Comment">%</span>
    <span class="Delimiter">{</span><span class="Statement">\dosingleempty\include_PDF</span><span class="Delimiter">}</span>

<span class="Character">\def</span><span class="Statement">\include_PDF</span><span class="Delimiter">[</span>#1<span class="Delimiter">]</span><span class="Comment">%</span>
    <span class="Delimiter">{</span><span class="Statement">\clf_includePDF</span><span class="Delimiter">{</span>#1<span class="Delimiter">}}</span>
<span class="Character">\protect</span>
</code></pre>

The code is almost self explanatory. We load the PDF file with the specified
name, check how many pages it has, and then manually include it page-by-page.

Now I can include a multipage PDF using:

<pre><code><span class="Statement">\includePDF</span><span class="Delimiter">[</span>filename<span class="Delimiter">]</span>
</code></pre>

That was simple!

Henri Menke explained in the comment below that the same macro could have been
written at the TeX end as well: 

<pre><code><span class="Statement">\unexpanded\def\includePDF</span><span class="Comment">%</span>
    <span class="Delimiter">{</span><span class="Statement">\dosingleempty\doincludePDF</span><span class="Delimiter">}</span>

<span class="Statement">\def\doincludePDF</span><span class="Delimiter">[</span>#1<span class="Delimiter">]</span><span class="Comment">%</span>
    <span class="Delimiter">{</span><span class="Statement">\getfiguredimensions</span><span class="Delimiter">[</span>talk.pdf<span class="Delimiter">]</span>
     <span class="Statement">\dorecurse</span><span class="Delimiter">{</span><span class="Statement">\noffigurepages</span><span class="Delimiter">}</span>
        <span class="Delimiter">{</span><span class="Statement">\startTEXpage</span>
            <span class="Statement">\externalfigure</span><span class="Delimiter">[</span>talk.pdf<span class="Delimiter">][</span>page=<span class="Statement">\recurselevel</span><span class="Delimiter">]</span>
         <span class="Statement">\stopTEXpage</span><span class="Delimiter">}}</span>
</code></pre>
