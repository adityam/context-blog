---
categories:
- backgrounds
date: 2017-08-06T01:34:19-04:00
tags:
- metapost
- framed

title: "Drop shadows with lifted corners"

---

There is an old question on [TeX.SE] asking how to draw drop shadows with a
_lifted_ corner. For fun, I decided to translate the code to Metapost and
release it as a module: [`t-backgrounds`][t-backgrounds]. I hope to add a few
other backgrounds to the module in the near future.

The module provides two overlays `liftedshadow:big` and `liftedshadow:medium`.
These may be used like any other overlay. Let's see an example:

<!--more-->

<pre><code><span class="Identifier">\usemodule</span><span class="Delimiter">[</span><span class="Type">backgrounds</span><span class="Delimiter">]</span>

<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">darkred</span><span class="Delimiter">][</span><span class="Type">r=0.75</span><span class="Delimiter">]</span>
<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">lightred</span><span class="Delimiter">][</span><span class="Type">r=1,g=0.95,b=0.95</span><span class="Delimiter">]</span>
<span class="Identifier">\definecolor</span><span class="Delimiter">[</span><span class="Type">lightblue</span><span class="Delimiter">][</span><span class="Type">r=0.95,g=0.95,b=1</span><span class="Delimiter">]  </span>

<span class="Identifier">\defineframedtext</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">shadowedtext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    framecolor=darkred,</span>
<span class="Type">    background=</span><span class="Delimiter">{</span>liftedshadow:big,color<span class="Delimiter">}</span><span class="Type">,</span>
<span class="Type">    backgroundcolor=lightred,</span>
<span class="Type">    rulethickness=1pt,</span>
<span class="Type">    width=broad,</span>
<span class="Type">  </span><span class="Delimiter">]</span>

<span class="Identifier">\defineframed</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">shadowed</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    frame=off,</span>
<span class="Type">    background=</span><span class="Delimiter">{</span>liftedshadow:medium,color<span class="Delimiter">}</span><span class="Type">,</span>
<span class="Type">    backgroundcolor=lightblue,</span>
<span class="Type">    width=fit,</span>
<span class="Type">  </span><span class="Delimiter">]</span>

<span class="Identifier">\usemodule</span><span class="Delimiter">[</span><span class="Type">visual</span><span class="Delimiter">]</span>

<span class="PreProc">\starttext</span>

<span class="Statement">\midaligned</span><span class="Delimiter">{</span><span class="Statement">\shadowed</span><span class="Delimiter">{</span><span class="Statement">\fakewords</span><span class="Delimiter">{</span>4<span class="Delimiter">}{</span>6<span class="Delimiter">}}}</span>

<span class="Keyword">\startshadowedtext</span>
<span class="Keyword">  </span><span class="Statement">\fakewords</span><span class="Delimiter">{</span>40<span class="Delimiter">}{</span>50<span class="Delimiter">}</span>
<span class="Keyword">\stopshadowedtext</span>

<span class="PreProc">\stoptext</span>

</code></pre>

which gives:

{{< img src="example.png" class="center" alt="Simple example" >}}

Apart from these two overlays, there are very little configuration options.
The module provides a `MPgraphic` `backgrounds::liftedshadow`, which accepts
two otions: `shadowcolor` and `shadow`. 

* `shadowcolor` determines the color of the shadow. It has to be a predefined
  ConTeXt color. By default it is `shadowcolor` which is defined as
  `0.5(white)`.

* `shadow` determines the shape of the shadow. It is a 3-tuple `(x,y,o)`,
  where `x` specifies the horizontal distance between the lower corner of the
  overlay box and the start of the shadow; `y` specifies the depth of the
  shadow at the corners, and `o` roughly specifies the depth of the shadow
  in the middle. For `liftedshadow:big`, the shadow is `(2mm, 3mm, 0.16mm)`
  and for `liftedshadow:medium`, the shadow is `(1.5mm, 1.5mm, 0.12mm)`.

Here is an example that shows how to change the shadow color and shadow size:

<pre><code><span class="Identifier">\defineoverlay</span>
<span class="Identifier">    </span><span class="Delimiter">[</span><span class="Type">hugeshadow</span><span class="Delimiter">]</span>
<span class="Delimiter">    [</span><span class="Type">\useMPgraphic</span><span class="Delimiter">{</span>backgrounds::liftedshadow<span class="Delimiter">}{</span>shadowcolor=blue, shadow={(4mm, 6mm, 0.3mm)<span class="Delimiter">}</span><span class="Type">}</span><span class="Delimiter">]</span>
</code></pre>

using which gives

{{< img src="example2.png" class="center" alt="Changing shadow color and size" >}}

Note that, the `backgrounds::liftedshadow` graphic just draws the shadow.
**It does not fill the overlay box with background color**. So, while using
the background, we must specify:

<pre><code><span class="Identifier">\defineframedtext</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">shadowedtext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    ...,</span>
<span class="Type">    background=</span><span class="Delimiter">{</span>liftedshadow:big,color<span class="Delimiter">}</span><span class="Type">,</span>
<span class="Type">    backgroundcolor=...,</span>
<span class="Type">    ...,</span>
<span class="Type">  </span><span class="Delimiter">]</span>
</code></pre>

The options `background={liftedshadow:big, color}` means that the
`liftedshadow:big` overlay is drawn first and then the `color` overlay
is drawn. The color overlay fills the frame with `backgroundcolor`. If you
wish, you can replace the `color` overlay with another overlay that does a
fancier fill (say shading or hatching).  

[TeX.SE]: https://tex.stackexchange.com/questions/180431/lifted-or-curved-drop-shadow
[t-backgrounds]: https://github.com/adityam/context-backgrounds
