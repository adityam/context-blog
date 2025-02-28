---
title     : "Formatting metapost labels"
linktitle : "Formatting metapost labels"
date  : 2025-02-27
tags  :
  - metapost
  - label
  - fmtlabel 
  - programming
categories :
  - Formatting
---

The standard way to typeset labels in metapost is using `label(btex ... etex, pos)`, which uses TeX to typeset the label and then includes it in the metapost graphic. ConTeXt simplifies the user interface a little: instead of using `btex ... etex`, one can simply use `label("...", pos)`, and the string argument is typeset using ConTeXt and included in the meapost graphic. However, both of these are cumbersome to use for dynamically generated labels (i.e., labels whose text depends on the value of some metapost variable). In this post, I show how to use `fmtlabel`, makes it simple to use dynamically generated labels.

<!-- more -->

Let me illustrate this by an example. Suppose I want to create a metapost `\useMPgraphic` such that 

<pre><code><span class="Identifier">\useMPgraphic</span><span class="Delimiter">{</span>example<span class="Delimiter">}{</span>length=2<span class="Delimiter">}</span>
</code></pre>

gives

{{< img class="center" src="example-1.png" alt="Output of metapost example" >}}

and 

<pre><code><span class="Identifier">\useMPgraphic</span><span class="Delimiter">{</span>example<span class="Delimiter">}{</span>length=3<span class="Delimiter">}</span>
</code></pre>

gives

{{< img class="center" src="example-2.png" alt="Output of metapost example" >}}

Such a command is rather straight forward to write in metapost:

<pre><code><span class="Identifier">\setupMPvariables</span><span class="Delimiter">[</span><span class="Type">example</span><span class="Delimiter">][</span><span class="Type">length=3, sy=2bp</span><span class="Delimiter">]</span>
<span class="Identifier">\startuseMPgraphic</span><span class="metapost">{example}</span>
<span class="metapost">    </span><span class="Type">newpair</span><span class="metapost"> A, B;</span>
<span class="metapost">    A := </span><span class="Constant">origin</span><span class="metapost">;</span>
<span class="metapost">    B := (\MPvar{</span><span class="Statement">length</span><span class="metapost">}*</span><span class="Number">cm</span><span class="metapost">, </span><span class="Number">0</span><span class="metapost">);</span>

<span class="metapost">    </span><span class="Type">newnumeric</span><span class="metapost"> sy_scale, sy_shift; </span>
<span class="metapost">    sy_scale := \MPvar{sy};</span>
<span class="metapost">    sy_shift := -(</span><span class="Number">2</span><span class="metapost">*\MPvar{sy} - </span><span class="Number">1bp</span><span class="metapost">);</span>

<span class="metapost">    </span><span class="Function">draw</span><span class="metapost"> A -- B ;</span>
<span class="metapost">    </span><span class="Function">drawdot</span><span class="metapost"> A </span><span class="Statement">withpen</span><span class="metapost"> </span><span class="Statement">pencircle</span><span class="metapost"> </span><span class="Statement">scaled</span><span class="metapost"> </span><span class="Number">1.5bp</span><span class="metapost">;</span>
<span class="metapost">    </span><span class="Function">drawdot</span><span class="metapost"> B </span><span class="Statement">withpen</span><span class="metapost"> </span><span class="Statement">pencircle</span><span class="metapost"> </span><span class="Statement">scaled</span><span class="metapost"> </span><span class="Number">1.5bp</span><span class="metapost">;</span>

<span class="metapost">    </span><span class="Conditional">for</span><span class="metapost"> dx = A, B :</span>
<span class="metapost">      </span><span class="Function">draw</span><span class="metapost"> (</span><span class="Constant">up</span><span class="metapost"> -- </span><span class="Constant">down</span><span class="metapost">) </span><span class="Statement">scaled</span><span class="metapost"> sy_scale </span><span class="Statement">shifted</span><span class="metapost"> dx yshifted sy_shift</span>
<span class="metapost">           </span><span class="Statement">withpen</span><span class="metapost"> </span><span class="Statement">pencircle</span><span class="metapost"> </span><span class="Statement">scaled</span><span class="metapost"> </span><span class="Number">0.2bp</span><span class="metapost">;</span>
<span class="metapost">    </span><span class="Conditional">endfor</span>

<span class="metapost">    </span><span class="Function">drawdblarrow</span><span class="metapost"> (A -- B)</span> <span class="metapost">yshifted sy_shift</span>
<span class="metapost">           </span><span class="Statement">withpen</span><span class="metapost"> </span><span class="Statement">pencircle</span><span class="metapost"> </span><span class="Statement">scaled</span><span class="metapost"> </span><span class="Number">0.2bp</span><span class="metapost">;</span>

<span class="metapost">    </span><span class="Function">label</span><span class="metapost">.</span><span class="Function">bot</span><span class="metapost">(</span><span class="String">&quot;\switchtobodyfont[8pt]$\unit{&quot;</span><span class="metapost"> &amp; </span><span class="Statement">decimal</span><span class="metapost"> \MPvar{</span><span class="Statement">length</span><span class="metapost">} &amp; </span><span class="String">&quot;cm}$&quot;</span><span class="metapost">, </span>
<span class="metapost">               </span><span class="Number">0.5</span><span class="metapost">[A, B] + (</span><span class="Number">0</span><span class="metapost">, sy_shift) );</span>
<span class="Identifier">\stopuseMPgraphic</span>
</code></pre>

Here I have used the `MPvar` method to pass variables from TeX to metapost. The above code can then be used to produce the examples above (except that I don't like the default metapost arrows, so I am using old code borrowed long time ago from Donald Knuth's webpage; more on that at the end). 

The label command is a bit clumsy to write:
`decimal \MPvar{length}` converts `\MPvar{length}` (which is a numeric value) to a metapost string), which we then concatenate with other formatting instructions.

However, apart from being clumsy to write, the above code gives unusable output when `length` is not an integer. For example

<pre><code><span class="Identifier">\useMPgraphic</span><span class="Delimiter">{</span>example<span class="Delimiter">}{</span>length=5/3<span class="Delimiter">}</span>
</code></pre>

gives

{{< img class="center" src="example-3.png" alt="Output of metapost example" >}}

Hmm ... it would be nice if we could round to two decimal places. Metapost has a round function, but it rounds to the nearest decimal. I can do a bit of algebra and round it to two decimal places, but ... wouldn't it be much nicer if we could simply use `printf` like formatting instructions? The `thefmtlabel` macro does exactly that. We can simply replace the `label.bot` line with:

<pre><code><span class="metapost">    </span><span class="Function">draw</span><span class="metapost"> thefmttext.</span><span class="Function">bot</span><span class="metapost">(</span><span class="String">&quot;\switchtobodyfont[8pt]$\unit{@0.2N cm}$&quot;</span><span class="metapost">, \MPvar{</span><span class="Statement">length</span><span class="metapost">}, </span>
<span class="metapost">                        </span><span class="Number">0.5</span><span class="metapost">[A, B] + (</span><span class="Number">0</span><span class="metapost">,sy_shift) );</span>
</code></pre>

which then gives

{{< img class="center" src="example-4.png" alt="Output of metapost example" >}}

The command uses the lua formatters available in ConTeXt. The format specifications are similar to C format specifications used in `printf` family of C functions (and borrowed in many other languages, including in Lua `format` function), but ConTeXt formatters adds a few additional options. The main thing to remember is that it uses `@f`, `@d`, etc, instead of the usual `%f`, `%d` because `%` is a commend character in metapost. 

In the above example, I use `@0.2N`, where `N` means _stripped number_. So, if the argument is an integer, it is display as an integer and if the argument is a float, it is rounded to two decimal places. (Hans had told me about these extended formatter available in ConTeXt after seeing my [old post on formatting lua numbers](../formatting-numbers/).

The function `thefmttext` takes a _suffix_ (`top`, `bot`, etc.; just like `label`) and variable number of arguments: the first argument is the format specification, then remaining all but one arguments are variables which are passed to the formatter, and the last argument is the location. The command works similar to `thelabel` function in metapost but there are two minor differences:

1. The `thelabel` places the label at an offset specified by `labeloffset`. In context, `thefmttext` places the label at an offset specified by `textextoffset`. However, the default value of `labeloffset` is `3pt` while, inexplicably, the default value of `textextoffset` is `0`! In the above example, I have set it to `3pt`. 

2. The function `label` is defined as `draw thelabel(...)`. So, in typical metapost examples, you always see `label("...", pos)`, rather than `draw thelabel("...", pos)`. A `fmtlabel(...)` function is defined in ConTeXt, but it is equal to `thefmtlabel(..., origin)` ... so you still have to write `draw` and then `shift` the label to the desired position. I don't understand the rationale for this choice.

So, in my code, I always use `draw thelabel(...)`. Being able to use standard formatting instructions does make metapost appear like a normal programming language!

## A note about arrows

I don't like the default metapost arrows. If you simply copy-paste the above code and run it, you will get the following:

{{< img class="center" src="example-5.png" alt="Output of metapost example" >}}

The arrow head is too big. In metapost, the size of the arrow head is controlled via two variables `ahlength` and `ahangle`. The default values are appropriate for the default line width and look very awkward on a thin line. We can get the arrow size to scale with line width by setting

<pre><code><span class="metapost">autoarrows := </span><span class="Statement">true</span><span class="metapost">;</span></code></pre>

With `autoarrows`, the default arrows look as follows:

{{< img class="center" src="example-6.png" alt="Output of metapost example" >}}

A bit better, but I don't like them visually. I use an arrow head style that I had seen somewhere in a document by Donald Knuth ... perhaps 20 years ago or so, which looks nicer to me. I have used the same arrow style ever since. Since the arrow is drawn in an "open" style, I typically leave `autoarrows` to its default value of `false`. Below is the code for it.

<pre><code><span class="Identifier">\startMPdefinitions</span>
<span class="metapost">  </span><span class="Comment">% Arrowhead Modifications for TAOCP. Copied from some webpage of Knuth. </span>
<span class="metapost">  </span><span class="Comment">% I like these arrows better than the default mp arrows..</span>
<span class="metapost">  </span><span class="Statement">vardef</span><span class="metapost"> </span><span class="Function">arrowhead</span><span class="metapost"> </span><span class="Statement">expr</span><span class="metapost"> p =</span>
<span class="metapost">    </span><span class="Statement">save</span><span class="metapost"> q, e, f, g; </span><span class="Type">path</span><span class="metapost"> q; </span><span class="Type">pair</span><span class="metapost"> e; </span><span class="Type">pair</span><span class="metapost"> f; </span><span class="Type">pair</span><span class="metapost"> g;</span>
<span class="metapost">    e = </span><span class="Statement">point</span><span class="metapost"> </span><span class="Statement">length</span><span class="metapost"> p </span><span class="Statement">of</span><span class="metapost"> p;</span>
<span class="metapost">    q = </span><span class="Function">gobble</span><span class="metapost">(p </span><span class="Statement">shifted</span><span class="metapost"> -e </span><span class="Function">cutafter</span><span class="metapost"> </span><span class="Statement">makepath</span><span class="metapost">(</span><span class="Statement">pencircle</span><span class="metapost"> </span><span class="Statement">scaled</span><span class="metapost"> </span><span class="Number">2</span><span class="Identifier">ahlength</span><span class="metapost">))</span>
<span class="metapost">      </span><span class="Identifier">cuttings</span><span class="metapost">;</span>
<span class="metapost">    f = </span><span class="Statement">point</span><span class="metapost"> </span><span class="Number">0</span><span class="metapost"> </span><span class="Statement">of</span><span class="metapost"> (q </span><span class="Statement">rotated</span><span class="metapost"> </span><span class="Number">0.5</span><span class="Identifier">ahangle</span><span class="metapost">) </span><span class="Statement">shifted</span><span class="metapost"> e;</span>
<span class="metapost">    g = </span><span class="Statement">point</span><span class="metapost"> </span><span class="Statement">length</span><span class="metapost"> q </span><span class="Statement">of</span><span class="metapost"> (</span><span class="Statement">reverse</span><span class="metapost"> q </span><span class="Statement">rotated</span><span class="metapost"> </span><span class="Number">-0.5</span><span class="Identifier">ahangle</span><span class="metapost">) </span><span class="Statement">shifted</span><span class="metapost"> e;</span>
<span class="metapost">    f .. {</span><span class="Function">dir</span><span class="metapost"> (</span><span class="Statement">angle</span><span class="metapost"> </span><span class="Function">direction</span><span class="metapost"> </span><span class="Statement">length</span><span class="metapost"> q </span><span class="Statement">of</span><span class="metapost"> (q </span><span class="Statement">rotated</span><span class="metapost"> </span><span class="Number">0.5</span><span class="Identifier">ahangle</span><span class="metapost">) - </span><span class="Number">0.3</span><span class="Identifier">ahangle</span><span class="metapost">)}e</span>
<span class="metapost">      &amp; e{</span><span class="Function">dir</span><span class="metapost"> (</span><span class="Statement">angle</span><span class="metapost"> </span><span class="Function">direction</span><span class="metapost"> </span><span class="Number">0</span><span class="metapost"> </span><span class="Statement">of</span><span class="metapost"> ((</span><span class="Statement">reverse</span><span class="metapost"> q) </span><span class="Statement">rotated</span><span class="metapost"> </span><span class="Number">-0.5</span><span class="Identifier">ahangle</span><span class="metapost">)+</span><span class="Number">0.3</span><span class="Identifier">ahangle</span><span class="metapost">)} .. g</span>
<span class="metapost">  </span><span class="Statement">enddef</span><span class="metapost">;</span>

<span class="metapost">  </span><span class="Statement">vardef</span><span class="metapost"> arrowpath </span><span class="Statement">expr</span><span class="metapost"> p =</span>
<span class="metapost">    p</span>
<span class="metapost">  </span><span class="Statement">enddef</span><span class="metapost">;</span>

<span class="metapost">  </span><span class="Statement">def</span><span class="metapost"> mfun_draw_arrow_path </span><span class="Statement">text</span><span class="metapost"> t =</span>
<span class="metapost">      </span><span class="Conditional">if</span><span class="metapost"> autoarrows :</span>
<span class="metapost">          set_ahlength(t) ;</span>
<span class="metapost">      </span><span class="Conditional">fi</span>
<span class="metapost">      </span><span class="Function">draw</span><span class="metapost"> arrowpath mfun_arrow_path t ;</span>
<span class="metapost">      </span><span class="Function">draw</span><span class="metapost"> </span><span class="Function">arrowhead</span><span class="metapost"> mfun_arrow_path t ;</span>
<span class="metapost">      </span><span class="Statement">endgroup</span><span class="metapost"> ;</span>
<span class="metapost">  </span><span class="Statement">enddef</span><span class="metapost"> ;</span>

<span class="metapost">  </span><span class="Statement">def</span><span class="metapost"> mfun_draw_arrow_path_double </span><span class="Statement">text</span><span class="metapost"> t =</span>
<span class="metapost">      </span><span class="Conditional">if</span><span class="metapost"> autoarrows :</span>
<span class="metapost">          set_ahlength(t) ;</span>
<span class="metapost">      </span><span class="Conditional">fi</span>
<span class="metapost">      </span><span class="Function">draw</span><span class="metapost"> arrowpath (</span><span class="Statement">reverse</span><span class="metapost"> arrowpath mfun_arrow_path) t ;</span>
<span class="metapost">      </span><span class="Function">draw</span><span class="metapost"> </span><span class="Function">arrowhead</span><span class="metapost"> mfun_arrow_path t ;</span>
<span class="metapost">      </span><span class="Function">draw</span><span class="metapost"> </span><span class="Function">arrowhead</span><span class="metapost"> </span><span class="Statement">reverse</span><span class="metapost"> mfun_arrow_path t ;</span>
<span class="metapost">      </span><span class="Statement">endgroup</span><span class="metapost"> ;</span>
<span class="metapost">  </span><span class="Statement">enddef</span><span class="metapost"> ;</span>

<span class="Identifier">\stopMPdefinitions</span></code></pre>
