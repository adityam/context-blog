---
title     : Comparing the speed of Metapost and TikZ 
linktitle : Speed of Metapost vs TikZ
date  : 2018-10-10
tags  :
  - metapost
  - tikz
  - efficiency
categories :
  - metapost
---

As a frequent user of both Metapost and TikZ, I often observe that TikZ is
considerably slower than Metapost. But what's the actual difference in speed?
Let's consider basic operations: drawing straight lines and drawing circles. 

<pre><code><span class="Identifier">\usemodule</span><span class="Delimiter">[</span><span class="Type">tikz</span><span class="Delimiter">]</span>

<span class="PreProc">\starttext</span>

<span class="Statement">\testfeatureonce</span><span class="Delimiter">{</span>1000<span class="Delimiter">}</span>
    <span class="Delimiter">{</span><span class="Statement">\setbox</span>0<span class="Statement">\hbox</span>
        <span class="Delimiter">{</span><span class="Identifier">\startMPcode</span> <span class="Function">draw</span> (<span class="Number">0</span>,<span class="Number">0</span>) -- (<span class="Number">1cm</span>, <span class="Number">1cm</span>); <span class="Identifier">\stopMPcode</span><span class="Delimiter">}}</span>

<span class="Statement">\elapsedtime</span>

<span class="Statement">\testfeatureonce</span><span class="Delimiter">{</span>1000<span class="Delimiter">}</span>
    <span class="Delimiter">{</span><span class="Statement">\setbox</span>0<span class="Statement">\hbox</span>
        <span class="Delimiter">{</span><span class="Identifier">\starttikzpicture</span> <span class="Statement">\draw</span> (0,0) <span class="Special">--</span> (1cm, 1cm); <span class="Identifier">\stoptikzpicture</span><span class="Delimiter">}}</span>

<span class="Statement">\elapsedtime</span>

<span class="Statement">\testfeatureonce</span><span class="Delimiter">{</span>1000<span class="Delimiter">}</span>
    <span class="Delimiter">{</span><span class="Statement">\setbox</span>0<span class="Statement">\hbox</span>
        <span class="Delimiter">{</span><span class="Identifier">\startMPcode</span> <span class="Function">draw</span> <span class="Constant">fullcircle</span> <span class="Statement">scaled</span> <span class="Number">1cm</span>; <span class="Identifier">\stopMPcode</span><span class="Delimiter">}}</span>

<span class="Statement">\elapsedtime</span>

<span class="Statement">\testfeatureonce</span><span class="Delimiter">{</span>1000<span class="Delimiter">}</span>
    <span class="Delimiter">{</span><span class="Statement">\setbox</span>0<span class="Statement">\hbox</span>
        <span class="Delimiter">{</span><span class="Identifier">\starttikzpicture</span> <span class="Statement">\draw</span> (0,0) circle (1cm); <span class="Identifier">\stoptikzpicture</span><span class="Delimiter">}}</span>

<span class="Statement">\elapsedtime</span>

<span class="PreProc">\stoptext</span>
</code></pre>

The function `\testfeatureonce{n}{...}` runs the code inside the second
argument `n` times and stores the elapsed time in the macro `\elapsedtime`.
So, in the above example, we are drawing a straight line (or a circle) 1000
times, saving the output to a box (so that we don't include the overhead of
writing the content to PDF), and measuring the elapsed time. The result is as
follows (formatted for clarity).

| Shape |  Metapost |  TikZ |
|-------|-----------|-------|
| Line  |  0.434s   | 1.239s|
| Circle|  0.533s   | 1.597s|


So, **TikZ is almost 3 times slower than Metapost** for basic shapes.

Now, let's try something more complicated: drawing a 2 state Markov chain. One
of the selling features of TikZ is that drawing more "complicated" graphics is
easy. Here is the code for drawing such a chain in TikZ:

<pre><code><span class="Identifier">\usemodule</span><span class="Delimiter">[</span><span class="Type">tikz</span><span class="Delimiter">]</span>
<span class="Identifier">\usetikzlibrary</span><span class="Delimiter">[</span><span class="Type">positioning</span><span class="Delimiter">]</span>

<span class="PreProc">\starttext</span>
<span class="Statement">\tikzset</span><span class="Delimiter">{</span>state/.style=<span class="Delimiter">{</span>circle, draw,
                line width=<span class="Number">2bp</span>,
                inner sep=<span class="Number">0.5em</span>,
                draw=blue!85,
                fill=blue!25!white,
                <span class="Delimiter">}}</span>

<span class="Identifier">\starttikzpicture</span>[line width=1bp]
   <span class="Statement">\node</span>[state] (off) {<span class="String">$0$</span>};
   <span class="Statement">\node</span>[state, right=of off] (on) {<span class="String">$1$</span>};

   <span class="Statement">\draw</span>[every loop]
       (off) edge[bend right, auto=right] node {<span class="String">$p$</span>} (on)
       (on)  edge[bend right, auto=right] node {<span class="String">$q$</span>} (off)
       (off) edge[loop left]  node {<span class="String">$1-p$</span>} (off)
       (on)  edge[loop right] node {<span class="String">$1-q$</span>} (off)
       ;

<span class="Identifier">\stoptikzpicture</span>
<span class="PreProc">\stoptext</span>
</code></pre>

{{< img src="tikz.png" class="center" alt="Two state Markov chain in TikZ" >}}

Using `\testfeatureonce{100}{...}` on this code takes **4.278s** on my laptop.
So, drawing one Markov chain takes about **43ms**. 

Metapost is a more declarative language, so Metapost code is more elaborate.
Here is one way to draw the same figure in Metapost:

<pre><code><span class="Identifier">\startMPinclusions</span>
  <span class="Statement">input</span> boxes;
<span class="Identifier">\stopMPinclusions</span>
<span class="PreProc">\starttext</span>
<span class="Identifier">\startMPcode</span>
   <span class="Function">pickup</span> <span class="Statement">pencircle</span> <span class="Statement">scaled</span> <span class="Number">1bp</span>;

   <span class="Function">circleit</span>.Off(<span class="String">&quot;$0$&quot;</span>);
   <span class="Function">circleit</span>.On (<span class="String">&quot;$1$&quot;</span>);

   <span class="Identifier">circmargin</span> := <span class="Number">1</span>EmWidth;

   Off.c = <span class="Constant">origin</span>;
   On.w - Off.e = (<span class="Number">1cm</span>, <span class="Number">0</span>);

   <span class="Conditional">forsuffixes</span> Box=Off, On :
      <span class="Function">fill</span> <span class="Function">bpath</span> Box <span class="Statement">withcolor</span> <span class="Number">0.75</span>[<span class="Constant">blue</span>,<span class="Constant">white</span>];
      <span class="Function">drawunboxed</span>(Box);
      <span class="Function">draw</span> <span class="Function">bpath</span> Box <span class="Statement">withcolor</span> <span class="Number">0.8</span><span class="Constant">blue</span> <span class="Statement">withpen</span> <span class="Statement">pencircle</span> <span class="Statement">scaled</span> <span class="Number">2bp</span>;
    <span class="Conditional">endfor</span>

   <span class="Type">newpath</span> p, q;
   p := Off.c {<span class="Function">dir</span> <span class="Number">-40</span>} .. On.c
        <span class="Function">cutbefore</span> <span class="Function">bpath</span> Off
        <span class="Function">cutafter</span>  <span class="Function">bpath</span> On;

   q:= On.c {<span class="Function">dir</span> <span class="Number">140</span>} .. Off.c
        <span class="Function">cutbefore</span> <span class="Function">bpath</span> On
        <span class="Function">cutafter</span>  <span class="Function">bpath</span> Off;

   <span class="Function">drawarrow</span> p;
   <span class="Function">drawarrow</span> q;

   <span class="Function">label</span>.<span class="Function">bot</span> (<span class="String">&quot;$p$&quot;</span>, <span class="Statement">point</span> <span class="Number">0.5</span> along p);
   <span class="Function">label</span>.<span class="Function">top</span> (<span class="String">&quot;$q$&quot;</span>, <span class="Statement">point</span> <span class="Number">0.5</span> along q);

   p := Off.c {<span class="Function">dir</span> <span class="Number">150</span>} .. (Off.w - (<span class="Number">0.75cm</span>, <span class="Number">0</span>))  .. {<span class="Function">dir</span> <span class="Number">30</span>} Off.c
        <span class="Function">cutbefore</span> <span class="Function">bpath</span> Off
        <span class="Function">cutafter</span>  <span class="Function">bpath</span> Off;

   q := On.c {<span class="Function">dir</span> <span class="Number">-30</span>} .. (On.e + (<span class="Number">0.75cm</span>, <span class="Number">0</span>)) .. {<span class="Function">dir</span> <span class="Number">-150</span>} On.c
         <span class="Function">cutbefore</span> <span class="Function">bpath</span> On
         <span class="Function">cutafter</span>  <span class="Function">bpath</span> On;

   <span class="Function">drawarrow</span> p;
   <span class="Function">drawarrow</span> q;

   <span class="Function">label</span>.<span class="Function">lft</span>(<span class="String">&quot;$1-p$&quot;</span>, <span class="Statement">point</span> <span class="Number">0.5</span> along p);
   <span class="Function">label</span>.<span class="Function">rt</span> (<span class="String">&quot;$1-q$&quot;</span>, <span class="Statement">point</span> <span class="Number">0.5</span> along q);
<span class="Identifier">\stopMPcode</span>
<span class="PreProc">\stoptext</span>
</code></pre>

{{< img src="metapost.png" class="center" alt="Two state Markov chain in TikZ" >}}

This code could have been made somewhat terser by defining macros `Edge` and
`Loop` but I am not doing so. Running `\testfeatureonce{100}{...}` on the
above code takes **0.790s** on my laptop. So drawing one Markov chain takes
about **8ms**. For a somewhat more complicated drawing, **TikZ is almost 5
times slower than Metapost**.

But the speed tradeoff comes at a cost. The TikZ code is terser than Metapost
and hides some of the complexity behind convenience macros. So, it is easier
to understand (at least for beginners). This also explains why TikZ is so much
more popular than Metapost. But the speed advantage makes me wonder: would
there be significant speedup in TikZ code if Lua is used for parsing the input
and metapost is used for drawing. In other words, **is it worthwhile to
rewrite the PGF backend for LuaTeX?**
