---
title     : Externalizing Metapost graphics
date  : 2018-10-08
tags  :
  - externalizing graphics
  - metapost
  - efficiency
categories :
  - metapost
---

TikZ has a library `external` that converts a TikZ picture to a separate PDF.
The TikZ documentation provides three reasons of why external images are
useful:

1. Compiling large images takes a lot of time. However, most images do not
   change from run to run. So, it can save time to export finished images and
   include them as external figures.
2. Sometimes, it is desirable to have separate graphics, for example to
   include them in third party programs (think XHTML export). 
3. It may be necessary to typeset a file in an environment where PGF or TikZ
   are not available. 

The third and to a large extent the first point are moot for Metapost+ConTeXt.
Metapost is integrated with LuaTeX, so there is no issue of Metapost not being
available. Moreover, Metapost is extremely fast so compiling Metapost figures
has very little overhead.

There was a recent question on the ConTeXt mailing list by Mikael
Sundqvist about [plotting an implicit function][question]. He wanted to plot
something equivalent to the following Mathematica code

<pre><code><span class="Function">ContourPlot</span>[<span class="Type">2</span> x<span class="Operator">^</span><span class="Type">5</span> <span class="Operator">+</span> x y <span class="Operator">+</span> y<span class="Operator">^</span><span class="Type">5</span> <span class="Operator">==</span> <span class="Type">0</span>, {x, <span class="Type">0</span>, <span class="Type">2</span>}, {y, <span class="Operator">-</span><span class="Type">2</span>, <span class="Type">1</span><span class="Operator">/</span><span class="Type">2</span>}]
</code></pre>

which gives

{{< img
src="https://mailman.ntg.nl/pipermail/ntg-context/attachments/20181007/a5f31fae/attachment.png"
class="center" alt="Contour Plot">}}

There is no inbuilt function in Metapost to draw such a curve. Alan Braslau
suggested a brute force solution:

<!--
\startMPpage {doublefun}
pen savedpen ; savedpen := currentpen ;
pickup pencircle scaled .01 ;
path p ;
p := for i=0 upto 1000 :
       for j=0 upto 1000 :
         hide(x := 2i/1000 ; y := 2.5j/1000 - 2 ;)
         if abs(2*(x**5)+x*y+y**5) < .002i/1000 : (x,y) .. fi
       endfor
     endfor cycle ;
draw subpath (0,length p - 1) of p ;
setbounds currentpicture to (0,-2)--(2,-2)--(2,.5)--(0,.5)--cycle ;
currentpicture := currentpicture xsized 5cm ;
pickup savedpen ;

picture pic ; pic := currentpicture ;
drawarrow llcorner pic--lrcorner pic ;
drawarrow llcorner pic--ulcorner pic ;
label.rt ("$x$", lrcorner pic) ;
label.top("$y$", ulcorner pic) ;
for x=0 step .5 until 2 :
    label.bot(decimal x,(x/2)[llcorner pic,lrcorner pic]) ;
endfor
for y=0 step .5 until 2.5 :
    label.lft(decimal (y-2),(y/2.5)[llcorner pic,ulcorner pic]) ;
endfor
\stopMPpage
-->

<pre><code><span class="Identifier">\startMPpage</span>[instance=doublefun]
     <span class="Type">pen</span> savedpen ; savedpen := <span class="Identifier">currentpen</span> ;
     <span class="Function">pickup</span> <span class="Statement">pencircle</span> <span class="Statement">scaled</span> <span class="Number">.01</span> ;
     <span class="Type">numeric</span> stp ; stp := <span class="Number">1</span> ;
     <span class="Type">path</span> p ;
     p := <span class="Conditional">for</span> i=<span class="Number">0</span> <span class="Conditional">step</span> stp <span class="Conditional">until</span> <span class="Number">1000</span> :
         <span class="Conditional">for</span> j=<span class="Number">0</span> <span class="Conditional">step</span> stp <span class="Conditional">until</span> <span class="Number">1000</span> :
             <span class="Function">hide</span>(<span class="Identifier">x</span> := <span class="Number">2</span>i/<span class="Number">1000</span> ; <span class="Identifier">y</span> := <span class="Number">2.5</span>j/<span class="Number">1000</span> - <span class="Number">2</span> ;)
             <span class="Conditional">if</span> <span class="Statement">abs</span>(<span class="Number">2</span>*(<span class="Identifier">x</span>**<span class="Number">5</span>)+<span class="Identifier">x</span>*<span class="Identifier">y</span>+<span class="Identifier">y</span>**<span class="Number">5</span>) &lt; <span class="Number">.002</span>i/<span class="Number">1000</span> : (<span class="Identifier">x</span>,<span class="Identifier">y</span>) .. <span class="Conditional">fi</span>
         <span class="Conditional">endfor</span>
     <span class="Conditional">endfor</span> <span class="Statement">cycle</span> ;
     <span class="Function">draw</span> <span class="Statement">subpath</span> (<span class="Number">0</span>,<span class="Statement">length</span> p - <span class="Number">1</span>) <span class="Statement">of</span> p ;
     <span class="Statement">setbounds</span> <span class="Identifier">currentpicture</span> <span class="Statement">to</span> (<span class="Number">0</span>,<span class="Number">-2</span>)--(<span class="Number">2</span>,<span class="Number">-2</span>)--(<span class="Number">2</span>,<span class="Number">.5</span>)--(<span class="Number">0</span>,<span class="Number">.5</span>)--<span class="Statement">cycle</span> ;
     <span class="Identifier">currentpicture</span> := <span class="Identifier">currentpicture</span> xsized <span class="Number">5cm</span> ;
     <span class="Function">pickup</span> savedpen ;
     <span class="Type">picture</span> <span class="Function">pic</span> ; <span class="Function">pic</span> := <span class="Identifier">currentpicture</span> ;
     <span class="Function">drawarrow</span> <span class="Statement">llcorner</span> <span class="Function">pic</span>--<span class="Statement">lrcorner</span> <span class="Function">pic</span> ;
     <span class="Function">drawarrow</span> <span class="Statement">llcorner</span> <span class="Function">pic</span>--<span class="Statement">ulcorner</span> <span class="Function">pic</span> ;
     <span class="Function">label</span>.<span class="Function">rt</span> (<span class="String">&quot;$x$&quot;</span>, <span class="Statement">lrcorner</span> <span class="Function">pic</span>) ;
     <span class="Function">label</span>.<span class="Function">top</span>(<span class="String">&quot;$y$&quot;</span>, <span class="Statement">ulcorner</span> <span class="Function">pic</span>) ;
     <span class="Conditional">for</span> <span class="Identifier">x</span>=<span class="Number">0</span> <span class="Conditional">step</span> <span class="Number">.5</span> <span class="Conditional">until</span> <span class="Number">2</span> :
         <span class="Function">label</span>.<span class="Function">bot</span>(<span class="Statement">decimal</span> <span class="Identifier">x</span>,(<span class="Identifier">x</span>/<span class="Number">2</span>)[<span class="Statement">llcorner</span> <span class="Function">pic</span>,<span class="Statement">lrcorner</span> <span class="Function">pic</span>]) ;
     <span class="Conditional">endfor</span> ;
     <span class="Conditional">for</span> <span class="Identifier">y</span>=<span class="Number">0</span> <span class="Conditional">step</span> <span class="Number">.5</span> <span class="Conditional">until</span> <span class="Number">2.5</span> :
         <span class="Function">label</span>.<span class="Function">lft</span>(<span class="Statement">decimal</span> (<span class="Identifier">y</span><span class="Number">-2</span>),(<span class="Identifier">y</span>/<span class="Number">2.5</span>)[<span class="Statement">llcorner</span> <span class="Function">pic</span>,<span class="Statement">ulcorner</span> <span class="Function">pic</span>]) ;
     <span class="Conditional">endfor</span> ;
<span class="Identifier">\stopMPpage</span>
</code></pre>

This code takes about 12sec to compile on my 2012 MacBook Pro and gives the
following:

{{< img src="plot.png" class="center" alt="Contour plot in Metapost" >}}

It would be nice to have something like TikZ's external library here. TikZ's
external library does not work with ConTeXt but as Hans Hagen showed on the
mailing list, _of course_, ConTeXt has an inbuilt solution for this!

Simply wrap the above code in a buffer

<!--
\startbuffer[plot]
\startMPpage[instance=doublefun]
...
\stopMPpage
\stopbuffer
-->

<pre><code><span class="Statement">\startbuffer</span><span class="Delimiter">[</span>plot<span class="Delimiter">]</span>
<span class="Statement">\startMPpage</span><span class="Delimiter">[</span>instance=doublefun<span class="Delimiter">]</span>
...
<span class="Statement">\stopMPpage</span>
<span class="Statement">\stopbuffer</span>
</code></pre>

and then use:
<pre><code><span class="Statement">\typesetbuffer</span><span class="Delimiter">[</span>plot<span class="Delimiter">]</span>
</code></pre>

Behind the scenes, this writes the content of the buffer to an external file
and compiles the file to create an external PDF. On subsequent runs, ConTeXt
checks if the contents of the buffer has changed; if not, then the previously
compiled file is used. 

It is worth highlighting that this trick works with **any buffer** not just
Metapost. So, if you have a complicated TikZ graphic, you can simply use

<pre><code><span class="Statement">\startbuffer</span><span class="Delimiter">[</span>TikZplot<span class="Delimiter">]</span>
<span class="Statement">\startTEXpage</span>
<span class="Statement">\starttikzpicture</span>
....
<span class="Statement">\stoptikzpicture</span>
<span class="Statement">\stopTEXpage</span>
<span class="Statement">\stopbuffer</span>
</code></pre>

followed by:
<pre><code><span class="Statement">\typesetbuffer</span><span class="Delimiter">[</span>TikZplot<span class="Delimiter">]</span>
</code></pre>

---

On a final note, one should keep in mind that the `\typesetbuffer` macro
simply wraps its content inside `\starttext ... \stoptext`. Unlike TikZ
external library, the preamble from the original document is not copied. So,
to use the fonts and styles from the original document, one needs to use:

<pre><code><span class="Statement">\startbuffer</span><span class="Delimiter">[</span>...<span class="Delimiter">]</span>
<span class="Statement">\environment</span> style
...
<span class="Statement">\stopbuffer</span>
</code></pre>

where I am assuming that the style of the document is set in the `style.tex`
environment.

[question]: https://mailman.ntg.nl/pipermail/ntg-context/2018/092946.html 
