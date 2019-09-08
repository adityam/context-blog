---
title     : "A new key-value interface for Metapost"
linktitle : "New Metapost interface"
date  : 2019-09-07
tags  :
  - metapost
  - metafun
  - separating content and presentation
  - programming
categories :
  - metapost
---

Recently, Hans [announced] a new key-value driven interface for MetaFun and
posted a [MyWay document] illustrating its use. In this post, I am going to
present an example of how to use this interface. 

<!--more-->

[announced]: https://www.mail-archive.com/ntg-context@ntg.nl/msg91818.html
[MyWay document]: http://www.pragma-ade.com/general/magazines/mag-1104-mkiv.pdf

I teach a course in Linear Systems and occasionally need to draw what is known
as a [pole zero plot][wikipedia]. Here is what it looks like. 

{{< img src="pzplot.png" class="center" alt="Example of a pole zero plot" >}}

The circle denotes the location of zero and the crosses denote the location
of poles. It is a relatively simple plot to draw, so I thought that this is a
good candidate to show how the interface works without worrying too much on
the logic of plotting. Let's start with the bare-bones implementation. I want
to draw the above plot using the following interface:

[wikipedia]: https://en.wikipedia.org/wiki/Pole–zero_plot

<!--
\startMPcode
   draw PZplot 
     [
        xmin = -3.5, xmax = 3.5,
        ymin = -3.5, ymax = 3.5,
        poles = { (-1, 1), (-1, -1) },
        zeros = { (-2, 0) },
     ] ;
\stopMPcode
-->

<pre><code><span class="Statement">\startMPcode</span>
   <span class="Function">draw</span> PZplot
     <span class="Delimiter">[</span>
        xmin = -3.5, xmax = 3.5,
        ymin = -3.5, ymax = 3.5,
        poles = <span class="Delimiter">{</span> (-1, 1), (-1, -1) <span class="Delimiter">}</span>,
        zeros = <span class="Delimiter">{</span> (-2, 0) <span class="Delimiter">}</span>,
     <span class="Delimiter">]</span> ;
<span class="Statement">\stopMPcode</span>
</code></pre>

So, how do we create such a key-value driven interface. Let's go over it step
by step. All that follows in Metapost code.

The first step is to define the macro `PZplot`:

<!--
def PZplot = applyparameters "PZplot" "do_PZplot" enddef ;
-->

<pre><code><span class="Statement">def</span> PZplot = <span class="Function">applyparameters</span> <span class="String">&quot;PZplot&quot;</span> <span class="String">&quot;do_PZplot&quot;</span> <span class="Statement">enddef</span> ;
</code></pre>

Here <code><span class="Function">applyparameters</span></code> is the new
MetaFun macro which takes two string arguments. The first (<code><span
class="String">&quot;PZplot&quot;</span></code> in this case) is the name of
the _data structure_ where the key-value pairs are stored. The second
(<code><span class="String">&quot;do_PZplot&quot;</span></code> in this case)
is the name of the MetaPost function that is called after all the key-value
pairs have been stored. This is very similar to the old style for defining
TeX macros in ConTeXt. 

The second (optional) step is to set up the default values of all parameters.

<!-- 
presetparameters "PZplot" [ 
  xmin = -2.5,  xmax = 2.5,
  ymin = -2.5,  ymax = 2.5, 
  dx   = 1,     dy   = 1,
  sx   = 5mm,   sy   = 5mm,
  scale = 0.5,

  poles = { },
  zeros = { },

  style = "\switchtobodyfont[8pt]",
];
-->

<pre><code><span class="Function">presetparameters</span> <span class="String">&quot;PZplot&quot;</span> [
  xmin = <span class="Number">-2.5</span>,  xmax = <span class="Number">2.5</span>,
  ymin = <span class="Number">-2.5</span>,  ymax = <span class="Number">2.5</span>,
  dx   = <span class="Number">1</span>,     dy   = <span class="Number">1</span>,
  sx   = <span class="Number">5mm</span>,   sy   = <span class="Number">5mm</span>,
  scale = <span class="Number">0.5</span>,

  <span class="Function">grid</span> = <span class="Statement">false</span>,

  poles = { },
  zeros = { },

  style = <span class="String">&quot;\switchtobodyfont[8pt]&quot;</span>,
];
</code></pre>

All values must either be a valid MetaPost type (`numeric`, `pair`, `string`,
etc.) or a list of value MetaPost types enclosed in braces (like a Lua
table). 

Finally, we can retrieve a value as follows:

<pre><code>xmin := <span class="Function">getparameter</span> <span class="String">&quot;PZplot&quot;</span> <span class="String">&quot;xmin&quot;</span>;
</code></pre>

The right hand side returns a metapost `numeric` and one has to be careful to
ensure that the variable `xmin` is declared a `numeric` beforehand. 

For a list (like `poles` and `zeros` in the above macros), there are a few
other macros:

1. To get the number of elements in the list, use 
<pre><code><span class="Function">getparametercount</span> <span class="String">&quot;PZplot&quot;</span> <span class="String">&quot;poles&quot;</span>
</code></pre>

2. To get the say 2nd element of the list, use
<pre><code><span class="Function">getparameter</span> <span class="String">&quot;PZplot&quot;</span> <span class="String">&quot;poles&quot;</span> <span class="Number">2</span>
</code></pre>

That's it. 

There are two other convenience macros. Writing the name of the data structure
<code><span class="String">&quot;PZplot&quot;</span></code> in all the macros
can get tiring. So, one can set the name of the current data structure using 

<pre><code><span class="Function">pushparameters</span> <span class="String">&quot;PZplot&quot;</span>;
</code></pre>

Then, 
<pre><code>xmin := <span class="Function">getparameter</span> <span class="String">&quot;xmin&quot;</span>;
</code></pre>
is equivalent to
<pre><code>xmin := <span class="Function">getparameter</span> <span class="String">&quot;PZplot&quot;</span> <span class="String">&quot;xmin&quot;</span>;
</code></pre>

One can then _reset_ the name of the default data structure using 

<pre><code><span class="Function">popparameters</span>;
</code></pre>

The actual mechanism is more complicated than that because <code><span
class="Function">pushparameters</span></code> can be used in a nested manner,
but I'll ignore that and stick with the simpler explanation that I used above.

So, without further ado, here is the complete implementation of the `PZplot`
macro. As a mater of habit, I define and use this macro in a separate MetaPost
_instance_. That way, I don't have to worry about my definitions affecting
code from other modules.

<pre><code>
<span class="Identifier">\defineMPinstance</span><span class="Delimiter">[</span><span class="Type">LTI</span><span class="Delimiter">]  </span>
<span class="Delimiter">                 [</span>
<span class="Type">                   format=metafun,</span>
<span class="Type">                   extensions=yes,</span>
<span class="Type">                   initializations=yes,</span>
<span class="Type">                   method=double,</span>
<span class="Type">                  </span><span class="Delimiter">]</span>

<span class="Identifier">\startMPdefinitions</span>{LTI}
<span class="Statement">def</span> pole =
    <span class="Function">image</span>(
        <span class="Function">draw</span> (<span class="Number">1</span>, <span class="Number">1</span>) -- (<span class="Number">-1</span>, <span class="Number">-1</span>);
        <span class="Function">draw</span> (<span class="Number">1</span>, <span class="Number">-1</span>) -- (<span class="Number">-1</span>, <span class="Number">1</span>);
    )
<span class="Statement">enddef</span> ;

<span class="Statement">def</span> zero =
    <span class="Function">image</span>(
        <span class="Function">unfill</span> <span class="Constant">fullcircle</span> <span class="Statement">scaled</span> <span class="Number">2</span>;
        <span class="Function">draw</span>   <span class="Constant">fullcircle</span> <span class="Statement">scaled</span> <span class="Number">2</span>;
    )
<span class="Statement">enddef</span>;

<span class="Statement">def</span> PZplot = <span class="Function">applyparameters</span> <span class="String">&quot;PZplot&quot;</span> <span class="String">&quot;do_PZplot&quot;</span> <span class="Statement">enddef</span> ;

<span class="Function">presetparameters</span> <span class="String">&quot;PZplot&quot;</span> [
  xmin = <span class="Number">-2.5</span>,  xmax = <span class="Number">2.5</span>,
  ymin = <span class="Number">-2.5</span>,  ymax = <span class="Number">2.5</span>,
  dx   = <span class="Number">1</span>,     dy   = <span class="Number">1</span>,
  sx   = <span class="Number">5mm</span>,   sy   = <span class="Number">5mm</span>,
  scale = <span class="Number">0.5</span>,

  <span class="Function">grid</span> = <span class="Statement">false</span>,

  poles = { },
  zeros = { },

  style = <span class="String">&quot;\switchtobodyfont[8pt]&quot;</span>,

];

<span class="Statement">vardef</span> do_PZplot =
  <span class="Function">image</span> (
    <span class="Function">pushparameters</span> <span class="String">&quot;PZplot&quot;</span>;

    <span class="Type">newnumeric</span> xmin, xmax, ymin, ymax;
    xmin := <span class="Function">getparameter</span> <span class="String">&quot;xmin&quot;</span>;
    xmax := <span class="Function">getparameter</span> <span class="String">&quot;xmax&quot;</span>;
    ymin := <span class="Function">getparameter</span> <span class="String">&quot;ymin&quot;</span>;
    ymax := <span class="Function">getparameter</span> <span class="String">&quot;ymax&quot;</span>;

    <span class="Type">newnumeric</span> sx, sy;
    sx := <span class="Function">getparameter</span> <span class="String">&quot;sx&quot;</span>;
    sy := <span class="Function">getparameter</span> <span class="String">&quot;sy&quot;</span>;

    <span class="Type">newnumeric</span> dx, dy;
    dx := <span class="Function">getparameter</span> <span class="String">&quot;dx&quot;</span>;
    dy := <span class="Function">getparameter</span> <span class="String">&quot;dy&quot;</span>;

    <span class="Type">newpath</span> xaxis, yaxis;

    xaxis := (xmin*sx, <span class="Number">0</span>) -- (xmax*sx, <span class="Number">0</span>);
    yaxis := (<span class="Number">0</span>, ymin*sy) -- (<span class="Number">0</span>, ymax*sy);

    <span class="Type">newpath</span> xtick, ytick;
    xtick := (<span class="Number">-0.1</span>sx, <span class="Number">0</span>) -- (<span class="Number">0.1</span>sx, <span class="Number">0</span>);
    ytick := (<span class="Number">0</span>, <span class="Number">-0.1</span>sy) -- (<span class="Number">0</span>, <span class="Number">0.1</span>sy);

    <span class="Type">newstring</span> style;
    style := <span class="Function">getparameter</span> <span class="String">&quot;style&quot;</span>;

    <span class="Type">newboolean</span> <span class="Function">grid</span>;
    <span class="Function">grid</span>  := <span class="Function">getparameter</span> <span class="String">&quot;grid&quot;</span>;

    <span class="Conditional">for</span> <span class="Identifier">x</span> = dx <span class="Conditional">step</span> dx <span class="Conditional">until</span> xmax :
        <span class="Conditional">if</span> <span class="Function">grid</span> :
            <span class="Function">draw</span> yaxis <span class="Statement">shifted</span> (<span class="Identifier">x</span>*sx, <span class="Number">0</span>) <span class="Statement">withcolor</span> <span class="Number">0.5</span><span class="Constant">white</span>;
        <span class="Conditional">fi</span>
        <span class="Function">draw</span> ytick <span class="Statement">shifted</span> (<span class="Identifier">x</span>*sx, <span class="Number">0</span>);
        <span class="Function">label</span>.<span class="Function">bot</span>(style &amp; <span class="Statement">decimal</span> <span class="Identifier">x</span>, (<span class="Identifier">x</span>*sx, <span class="Number">0</span>));
    <span class="Conditional">endfor</span>

    <span class="Function">label</span>.lrt(style &amp; <span class="String">&quot;0&quot;</span>, <span class="Constant">origin</span>);

    <span class="Conditional">for</span> <span class="Identifier">x</span> = -dx <span class="Conditional">step</span> -dx <span class="Conditional">until</span> xmin :
        <span class="Conditional">if</span> <span class="Function">grid</span> :
            <span class="Function">draw</span> yaxis <span class="Statement">shifted</span> (<span class="Identifier">x</span>*sx, <span class="Number">0</span>) <span class="Statement">withcolor</span> <span class="Number">0.5</span><span class="Constant">white</span>;
        <span class="Conditional">fi</span>
        <span class="Function">draw</span> ytick <span class="Statement">shifted</span> (<span class="Identifier">x</span>*sx, <span class="Number">0</span>);
        <span class="Function">label</span>.<span class="Function">bot</span>(style &amp; <span class="Statement">decimal</span> <span class="Identifier">x</span>, (<span class="Identifier">x</span>*sx, <span class="Number">0</span>));
    <span class="Conditional">endfor</span>

    <span class="Conditional">for</span> <span class="Identifier">y</span> = dy <span class="Conditional">step</span> dy <span class="Conditional">until</span> ymax :
        <span class="Conditional">if</span> <span class="Function">grid</span> :
            <span class="Function">draw</span> xaxis <span class="Statement">shifted</span> (<span class="Number">0</span>, <span class="Identifier">y</span>*sy) <span class="Statement">withcolor</span> <span class="Number">0.5</span><span class="Constant">white</span>;
        <span class="Conditional">fi</span>
        <span class="Function">draw</span> xtick <span class="Statement">shifted</span> (<span class="Number">0</span>, <span class="Identifier">y</span>*sy);
        <span class="Function">label</span>.<span class="Function">lft</span>(style &amp; <span class="Statement">decimal</span> <span class="Identifier">y</span>, (<span class="Number">0</span>, <span class="Identifier">y</span>*sy));
    <span class="Conditional">endfor</span>

    <span class="Conditional">for</span> <span class="Identifier">y</span> = -dy <span class="Conditional">step</span> -dy <span class="Conditional">until</span> ymin :
        <span class="Conditional">if</span> <span class="Function">grid</span> :
            <span class="Function">draw</span> xaxis <span class="Statement">shifted</span> (<span class="Number">0</span>, <span class="Identifier">y</span>*sy) <span class="Statement">withcolor</span> <span class="Number">0.5</span><span class="Constant">white</span>;
        <span class="Conditional">fi</span>
        <span class="Function">draw</span> xtick <span class="Statement">shifted</span> (<span class="Number">0</span>, <span class="Identifier">y</span>*sy);
        <span class="Function">label</span>.<span class="Function">lft</span>(style &amp; <span class="Statement">decimal</span> <span class="Identifier">y</span>, (<span class="Number">0</span>, <span class="Identifier">y</span>*sy));
    <span class="Conditional">endfor</span>


    <span class="Function">drawarrow</span> xaxis;
    <span class="Function">drawarrow</span> yaxis;

    <span class="Function">label</span>.<span class="Function">rt</span>( style &amp; <span class="String">&quot;$σ$&quot;</span>,  (xmax*sx, <span class="Number">0</span>));
    <span class="Function">label</span>.<span class="Function">top</span>(style &amp; <span class="String">&quot;$jω$&quot;</span>, (<span class="Number">0</span>, ymax*sy));

    <span class="Type">newpair</span> p ;

    <span class="Type">newnumeric</span> scale;
    scale := <span class="Function">getparameter</span> <span class="String">&quot;scale&quot;</span>;

    <span class="Conditional">if</span> (<span class="Function">getparametercount</span> <span class="String">&quot;zeros&quot;</span>) &gt; <span class="Number">0</span> :
          <span class="Conditional">for</span> i = <span class="Number">1</span> <span class="Function">upto</span> <span class="Function">getparametercount</span> <span class="String">&quot;zeros&quot;</span>:
            p := <span class="Function">getparameter</span> <span class="String">&quot;zeros&quot;</span> i;
            <span class="Function">draw</span> (zero xysized(scale*sx, scale*sx))
                 <span class="Statement">shifted</span> (<span class="Statement">xpart</span> p*sx, <span class="Statement">ypart</span> p*sy)
                 <span class="Statement">withpen</span> <span class="Statement">pencircle</span> <span class="Statement">scaled</span> <span class="Number">1bp</span>;
            <span class="Conditional">endfor</span>
    <span class="Conditional">fi</span>

    <span class="Conditional">if</span> (<span class="Function">getparametercount</span> <span class="String">&quot;poles&quot;</span>) &gt; <span class="Number">0</span> :
          <span class="Conditional">for</span> i = <span class="Number">1</span> <span class="Function">upto</span> <span class="Function">getparametercount</span> <span class="String">&quot;poles&quot;</span>:
            p := <span class="Function">getparameter</span> <span class="String">&quot;poles&quot;</span> i;
            <span class="Function">draw</span> (pole xysized(scale*sx, scale*sx))
                 <span class="Statement">shifted</span> (<span class="Statement">xpart</span> p*sx, <span class="Statement">ypart</span> p*sy)
                 <span class="Statement">withpen</span> <span class="Statement">pencircle</span> <span class="Statement">scaled</span> <span class="Number">1bp</span>;
            <span class="Conditional">endfor</span>
    <span class="Conditional">fi</span>


    <span class="Function">popparameters</span>;

  )
<span class="Statement">enddef</span>;
<span class="Identifier">\stopMPdefinitions</span>

<span class="PreProc">\starttext</span>
<span class="Identifier">\startTEXpage</span><span class="Delimiter">[</span><span class="Type">offset=2mm</span><span class="Delimiter">]</span>
<span class="Identifier">\startMPcode</span>{LTI}
   <span class="Function">draw</span> PZplot
     [
        xmin = <span class="Number">-3.5</span>, xmax = <span class="Number">3.5</span>,
        ymin = <span class="Number">-3.5</span>, ymax = <span class="Number">3.5</span>,
        poles = { (<span class="Number">-1</span>, <span class="Number">1</span>), (<span class="Number">-1</span>, <span class="Number">-1</span>) },
        zeros = { (<span class="Number">-2</span>, <span class="Number">0</span>) },
     ] ;
<span class="Identifier">\stopMPcode</span>
<span class="Identifier">\stopTEXpage</span>
<span class="PreProc">\stoptext</span>
</code></pre>

Running the code above gives the plot:

{{< img src="pzplot.png" class="center" alt="Example of a pole zero plot" >}}

As an example of the flexibility of the key-value interface, we can get a
background grid by using:
<pre><code><span class="Identifier">\startMPcode</span>{LTI}
   <span class="Function">draw</span> PZplot
     [
        .&nbsp;.&nbsp;.
        .&nbsp;.&nbsp;.
        <span class="Function">grid</span> = <span class="Statement">true</span>,
     ] ;
<span class="Identifier">\stopMPcode</span>
</code></pre>

{{< img src="pzplot-grid.png" class="center" alt="Example of a pole zero plot with grid" >}}

I am very excited about this new key-value interface for MetaPost. For my
course notes, there are many plots that I draw using TikZ because of the
convenience of the key-value interface of TikZ. Now, I can draw these with
MetaPost, which has the advantage of being [3-5 times faster][faster].

[faster]: ../metapost-vs-tikz-speed/
