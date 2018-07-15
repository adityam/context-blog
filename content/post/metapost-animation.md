---
title: "Drawing Metapost animations"
categories:
  - metapost
date: 2018-07-15
tags:
  - metapost
  - animation

---

The [animation] module provides a nice interface for using
[FieldStacks][widgets] to create a JavaScript controlled animations in
ConTeXt.[^1] For example, the following code will show `step-1.pdf`,
`step-2.pdf`, `step-3.pdf`, and `step-4.pdf` files one by one:

<!--
\usemodule[animation]

\startanimation[menu=yes]
  {\useexternalfigure[step-1]}
  {\useexternalfigure[step-2]}
  {\useexternalfigure[step-3]}
  {\useexternalfigure[step-4]}
\stopanimation
-->

<pre><code><span class="Statement">\usemodule</span><span class="Delimiter">[</span>animation<span class="Delimiter">]</span>

<span class="Statement">\startanimation</span><span class="Delimiter">[</span>menu=yes<span class="Delimiter">]</span>
  <span class="Delimiter">{</span><span class="Statement">\useexternalfigure</span><span class="Delimiter">[</span>step-1.pdf<span class="Delimiter">]}</span>
  <span class="Delimiter">{</span><span class="Statement">\useexternalfigure</span><span class="Delimiter">[</span>step-2.pdf<span class="Delimiter">]}</span>
  <span class="Delimiter">{</span><span class="Statement">\useexternalfigure</span><span class="Delimiter">[</span>step-3.pdf<span class="Delimiter">]}</span>
  <span class="Delimiter">{</span><span class="Statement">\useexternalfigure</span><span class="Delimiter">[</span>step-4.pdf<span class="Delimiter">]}</span>
<span class="Statement">\stopanimation</span>
</code></pre>

[widgets]: http://www.pragma-ade.com/general/manuals/mwidget-s.pdf
[animation]: http://wiki.contextgarden.net/Animation#Using_the_animation_module
[^1]: **Warning**: Such animations only work with Adobe Acrobat. 

Sometimes, I use animation to give the illusion of motion. For example, to
show a particle moving along a trajectory (drawn using Metapost). In
principle, it is possible to use the `animation` module to draw such
animations (e.g., see Wolfgang's reply in [on ntg-context mailing list][thread]), but the
interface gets a bit cumbersome. In this post, I show a helper macro to
simplify drawing such animations.

[thread]: https://mailman.ntg.nl/pipermail/ntg-context/2013/070769.html

<!--more-->

As an example, I'll consider the use case of drawing a particle moving in a
circle. With the helper macros given below, we can use the following code:

<!--
\startMPanimation{circle}{n=100}
    path p, q;

    p := fullcircle scaled 2cm;
    draw p withcolor 0.7white;

    n := \MPvar{n};
    t := \MPvar{t};

    drawdot point along p
        withpen pencircle scaled 3bp withcolor red;

    setbounds currentpicture to fullsquare scaled 2.2cm;
\stopMPanimation

\starttext
\useMPanimation[menu=yes,framerate=20]{circle}
\stoptext
-->

<pre><code><span class="Identifier">\startMPanimation</span>{circle}{n=<span class="Number">100</span>}
    <span class="Type">path</span> p, q;

    p := <span class="Constant">fullcircle</span> <span class="Statement">scaled</span> <span class="Number">2cm</span>;
    <span class="Function">draw</span> p <span class="Statement">withcolor</span> <span class="Number">0.7</span><span class="Constant">white</span>;

    n := \MPvar{n};
    t := \MPvar{t};

    <span class="Function">drawdot</span> <span class="Statement">point</span> (t/n) along p
        <span class="Statement">withpen</span> <span class="Statement">pencircle</span> <span class="Statement">scaled</span> <span class="Number">3bp</span> <span class="Statement">withcolor</span> <span class="Constant">red</span>;

    <span class="Statement">setbounds</span> <span class="Identifier">currentpicture</span> <span class="Statement">to</span> fullsquare <span class="Statement">scaled</span> <span class="Number">2.2cm</span>;
<span class="Identifier">\stopMPanimation</span>


<span class="PreProc">\starttext</span>
<span class="Identifier">\useMPanimation</span><span class="Delimiter">[</span><span class="Type">menu=yes,framerate=50</span><span class="Delimiter">]{</span>circle<span class="Delimiter">}</span>
<span class="PreProc">\stoptext</span>
</code></pre>

to generate this animation

{{< img src="test-animation.gif" class="center" alt="Simple animation" >}}

Thus, an animation is defined using `\startMPanimation ... \stopMPanimation`.
The macro takes one argument `n=...`, which specifies the total number of
frames. To use the animation, use

<pre><code><span class="Identifier">\useMPanimation</span><span class="Delimiter">[</span><span class="Type">menu=yes,framerate=50</span><span class="Delimiter">]{</span>circle<span class="Delimiter">}</span>
</code></pre>

where the options (in square brackets) are options to the `\startanimation`
macro from `animation` module. That's it.

Behind the scenes, the `\startMPanimation` amcro creates a `useMPgraphic` with
the name `animation:circle`, which takes two arguments `n` (which is the same
as before) and `t` (which specifies the current _time_ or the current frame
number). The body of the environment is the metapost code which draws a figure
depending on the values of `t` and `n`. In the example above, I draw a circle
and a point `t/n` along the circle. 

The macros `\startMPanimation` and `\useMPanimation` are a wrapper around the
[code by Wolfgang][thread]:

<pre><code><span class="Character">\unprotect</span>

<span class="Statement">\installnamespace</span><span class="Delimiter">{</span>MPanimationvariables<span class="Delimiter">}</span>

<span class="Character">\unexpanded\def</span><span class="Identifier">\startMPanimation</span>
    {\dodoublegroupempty\meta_start_animation}

\<span class="Statement">def</span>\meta_start_animation#<span class="Number">1</span><span class="Comment">%</span>
    {\normalexpanded{\meta_start_animation_indeed{#<span class="Number">1</span>}}}

\unexpanded\<span class="Statement">def</span>\meta_start_animation_indeed#<span class="Number">1</span>#<span class="Number">2</span>#<span class="Number">3</span><span class="Identifier">\stopMPanimation</span>
    <span class="Delimiter">{</span><span class="Statement">\doifsomething</span><span class="Delimiter">{</span>#2<span class="Delimiter">}{</span><span class="Statement">\getparameters</span><span class="Delimiter">[</span>\????MPanimationvariables#1:<span class="Delimiter">][</span>#2<span class="Delimiter">]}</span><span class="Comment">%</span>
     <span class="Statement">\setgvalue</span><span class="Delimiter">{</span>\??mpgraphic animation:#1<span class="Delimiter">}{</span><span class="Statement">\meta_handle_use_graphic</span><span class="Delimiter">{</span>#1<span class="Delimiter">}{</span>n,t<span class="Delimiter">}{</span>#3<span class="Delimiter">}}}</span>

<span class="Character">\let</span><span class="Keyword">\stopMPanimation</span><span class="Statement">\relax</span>

<span class="Character">\unexpanded\def</span><span class="Identifier">\useMPanimation</span><span class="Comment">%</span>
    <span class="Delimiter">{</span><span class="Statement">\dosingleargument</span><span class="Identifier">\use</span>_meta_animation<span class="Delimiter">}</span>

<span class="Character">\def</span><span class="Identifier">\use</span>_meta_animation<span class="Delimiter">[</span>#1<span class="Delimiter">]</span>#2<span class="Comment">%</span>
    <span class="Delimiter">{</span><span class="Statement">\edef\c_MP_animation_frames</span><span class="Delimiter">{</span><span class="Statement">\getvalue</span><span class="Delimiter">{</span>\????MPanimationvariables#2:n<span class="Delimiter">}}</span><span class="Comment">%</span>
     <span class="Keyword">\startanimation</span><span class="Delimiter">[</span><span class="Type">#1</span><span class="Delimiter">]</span>
<span class="Delimiter">        </span><span class="Statement">\dorecurse</span><span class="Delimiter">{</span><span class="Statement">\c_MP_animation_frames</span><span class="Delimiter">}</span>
            <span class="Delimiter">{</span><span class="Statement">\expanded</span><span class="Delimiter">{</span><span class="Statement">\frame</span><span class="Delimiter">{</span><span class="Identifier">\useMPgraphic</span><span class="Delimiter">{</span>animation:#2<span class="Delimiter">}{</span>n=<span class="Statement">\c_MP_animation_frames</span>,t=<span class="Statement">\recurselevel</span><span class="Delimiter">}}}}</span>
     <span class="Keyword">\stopanimation</span><span class="Delimiter">}</span>

<span class="Character">\protect</span>

</code></pre>

A test file and sample pdf output are below. The pdf file needs to be open in
Adobe Acrobat to work:

* [test-animation.tex](test-animation.tex)
* [test-animation.pdf](test-animation.pdf)

