---
title     : "Speeding up PGFPlots using LuaTeX"
date  : 2018-10-21
tags  :
  - tikz
  - luatex
  - efficiency
categories :
  - tikz
---

In the [previous post](../metapost-vs-tikz-speed), I compared the speed of
Metapost and TikZ for drawing similar graphics and found that **TikZ is three
to five times slower than Metapost**. Although TikZ is slower, it does provide
a much higher level interface to drawing graphics and shifting to Metapost can
take a lot of _user time_, which is often more valuable than _computer time_.

As an example, consider the [PGFPlots] package, which provides a high-level
interface for drawing function plots. Although there is a [Metapost package
for drawing
graphs](https://github.com/contextgarden/context-mirror/blob/beta/metapost/context/base/mpiv/mp-grap.mpiv), PGFPlots has more features and better documentation. In this post, I show that we can speed up plotting functions using PGFPlots by offloading the function computation to LuaTeX.

<!--more-->

As an example, consider the plot of the following function

```
0.5 - 0.5*exp(-3*x)*(cos(5.196*x) + 0.5774*sin(5.196*x))
```

which is the step response of a second order dynamical system (the exact
details are not relevant for this post). PGFPlots makes it very simple to plot
such functions:

<pre><code><span class="Identifier">\usemodule</span><span class="Delimiter">[</span><span class="Type">pgfplots</span><span class="Delimiter">]</span>
<span class="PreProc">\starttext</span>
<span class="Identifier">\starttikzpicture</span>
    <span class="Statement">\startaxis</span>
        [
          width=6cm,
          trig format plots=rad,
          xmin=0, xmax=4,
        ]

    <span class="Statement">\addplot</span>[domain=0:4, samples=500]
        {0.5 - 0.5*exp(-3*x)*(cos(5.196*x) + 0.5774*sin(5.196*x)) };
    <span class="Statement">\stopaxis</span>
<span class="Identifier">\stoptikzpicture</span>
<span class="PreProc">\stoptext</span>
</code></pre>

On my laptop, the above code takes **1.341s** (measured using the
`\testfeatureonce` macro explained in the previous post). Most of the time is
spent in calculating the algebric expression. We can speed this up by defining
a Lua function that does the calculation.

<pre><code><span class="Identifier">\usemodule</span><span class="Delimiter">[</span><span class="Type">pgfplots</span><span class="Delimiter">]</span>
<span class="PreProc">\starttext</span>
<span class="Identifier">\startluacode</span>
  <span class="Statement">local</span> exp = <span class="Identifier">math.exp</span>
  <span class="Statement">local</span> cos = <span class="Identifier">math.cos</span>
  <span class="Statement">local</span> sin = <span class="Identifier">math.sin</span>
  <span class="Statement">local</span> step = <span class="Function">function</span>(x)
      <span class="Statement">return</span> 0.5 - 0.5*exp(-3*x)*(cos(5.196*x) + 0.5774*sin(5.196*x))
  <span class="Function">end</span>

  thirddata = thirddata <span class="Operator">or</span> <span class="Structure">{}</span>
  thirddata.step = <span class="Function">function</span>(x)
      <span class="Statement">return</span> context(step(x))
  <span class="Function">end</span>
<span class="Identifier">\stopluacode</span>

<span class="Identifier">\starttikzpicture</span>
    [declare function={
        step(<span class="Statement">\x</span>) = <span class="Statement">\ctxlua</span>{thirddata.step(<span class="Statement">\x</span>)};
    }]

    <span class="Statement">\startaxis</span>
        [
          use fpu=false,
          width=6cm,
          xmin=0, xmax=4,
        ]

    <span class="Statement">\addplot</span>[domain=0:4, samples=500] {step(x)};
    <span class="Statement">\stopaxis</span>
<span class="Identifier">\stoptikzpicture</span>
<span class="PreProc">\stoptext</span>
</code></pre>

On my laptop, this takes **0.333s**. So, plotting in PGFPlots is **four times
faster** if we use Lua to do more complicated calculations. 

I don't know the internals of PGFPlot well, but recent versions of PGFPlot do
use Lua for some of the calcuations. So, I don't completely understand why I
get such a big speedup by doing the calculations in Lua. 


[PGFPlots]: https://ctan.org/pkg/pgfplots
