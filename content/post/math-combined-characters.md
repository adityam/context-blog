---
title: "Comibined characters in Math"
date: 2017-10-15
categories:
- Mathematics
tags:
- asciimath

---

There is a new feature in ConTeXt that replaces some _ascii math_ (I am using
this term informally. The symbols do not match the [asciimath] symbol list).
It is enabled by default and replaces a combination of characters by a glyph.
For example,

[asciimath]: http://asciimath.org

<pre><code>A function <span class="String">$f$</span> is an increasing function
  <span class="Identifier">\startformula</span>
<span class="String">    x &lt;= y  ===&gt; f(x) &lt;= f(y)</span>
<span class="String">  </span><span class="Identifier">\stopformula</span>
</code></pre>

gives

{{< img src="/context-blog/post/math-combined-characters/ex-1.png"
   class="center" alt="Example of combined characters" >}}


<!--more-->

Notice that `<=` got translated to `≤` (`\le`) and `===>` got translated to
`⟹ ` (`\Longrightarrow`). 

ConTeXt version `2017.08.15` or newer is needed for these mappings to work.
Here is the complete list of comining characters that are available:

| shortcut              | Mapped to      |
|-----------------------|:---------------|
| `''`                  | `\doubleprime`        |
| `'''`                 | `\tripleprime`        |
| `''''`                | `\quadprime`          |
| `::`                  | `\squaredots`  |
| `:=`                  | `\colonequals` |
| `=:`                  | `\equalscolon` |
| `::=`                 | `\coloncolonequals` |
| `-:`                  | `\minuscolon`  |
| `/<`                  | `\nless`       |
| `/>`                  | `\ngtr`        |
| `<=`                  | `\le`          |
| `/<=`                 | `\nleq`        |
| `>=`                  | `\ge`          |
| `/>=`                 | `\ngeq`        |
| `/=`                  | `\neq`         |
| `=>`                  | `\eqgtr`       |
| `=<`                  | `\eqless`      |
| `<=>`                 | `\lesseqqgtr`  |
| `>=<`                 | `\gtreqqless`  |
| `
| `<<`                  | `\ll`          |
| '>>`                  | `\gg`          |
| `<<<`                 | `\lll`         |
| `>>>`                 | `\ggg`         |
| `==`                  | `\equiv`       |
| `/==`                 | `\nequiv`       |
| `===`                 | `\eqequiv` (a virtual character for mapping purposes) |
| `->`                  | `\rightarrow`  |
| `<-`                  | `\leftarrow`   |
| `<->`                 | `\leftrightarrow` |
| `-->`                 | `\longleftarrow`  |
| `<--`                 | `\longrightarrow` |
| `<-->`                | `\longleftrightarrow` |
| `==>`                 | `\Rightarrow`     |
| `<==`                 | `\Leftarrow`      |
| `<==>`                | `\Leftrightarrow` |
| `===>`                | `\Longrightarrow` |
| `<===`                | `\Longleftarrow`  |
| `<===>`               | `\Longleftrightarrow` |
| <code>&#124;&#124;</code>  | `\doubleverticalbar`  |
| <code>&#124;&#124;&#124;</code>  | `\tripleverticalbar`  |

If the font does not contain the appropriate glyph, then the above
will silently fail (e.g., Latin Modern Math does not have `::=`). If something
goes wrong, partial debug information is available using:


<pre><code><span class="Identifier">\enabletrackers</span><span class="Delimiter">[</span><span class="Type">math.collapsing</span><span class="Delimiter">]</span>
</code></pre>

This shows the following tracking information on the console (and also
writes it to the log file)

~~~
mathematics     > collapsing > enabling math collapsing
mathematics     > collapsing > creating ligature ″ (U+02033) from specials
mathematics     > collapsing > creating ligature ‴ (U+02034) from specials
mathematics     > collapsing > creating ligature ⁗ (U+02057) from specials
mathematics     > collapsing > creating ligature ∷ (U+02237) from mathlist
mathematics     > collapsing > creating ligature ≔ (U+02254) from mathlist
mathematics     > collapsing > creating ligature ≕ (U+02255) from mathlist
mathematics     > collapsing > creating ligature ⩴ (U+02A74) from specials
...
~~~

Notice that there are two mechanisms for collapsing `mathlist` and `specials`
(I don't quite understand the difference except that the `specials` mechanism
is old and related for some font stuff while the `mathlist` mechanism is new).
The relevant information is available in `char-def.lua`. For example, for
`::=` (which is a `special`), the entry in `char-def.lua` is

<pre><code>[<span class="Number">0x2A74</span>]=<span class="Structure">{</span>
  category=<span class="String">&quot;sm&quot;</span>,
  description=<span class="String">&quot;DOUBLE COLON EQUAL&quot;</span>,
  direction=<span class="String">&quot;on&quot;</span>,
  linebreak=<span class="String">&quot;al&quot;</span>,
  mathclass=<span class="String">&quot;relation&quot;</span>,
  mathname=<span class="String">&quot;coloncolonequals&quot;</span>,
  specials=<span class="Structure">{</span> <span class="String">&quot;compat&quot;</span>, <span class="Number">0x3A</span>, <span class="Number">0x3A</span>, <span class="Number">0x3D</span> <span class="Structure">}</span>,
  unicodeslot=<span class="Number">0x2A74</span>,
 <span class="Structure">}</span>,
</code></pre>

On the other hand, for `::` (which is a `mathlist`), the entry in
`char-def.lua` is: 

<pre><code>[<span class="Number">0x2237</span>]=<span class="Structure">{</span>
  adobename=<span class="String">&quot;proportion&quot;</span>,
  category=<span class="String">&quot;sm&quot;</span>,
  cjkwd=<span class="String">&quot;a&quot;</span>,
  description=<span class="String">&quot;PROPORTION&quot;</span>,
  direction=<span class="String">&quot;on&quot;</span>,
  linebreak=<span class="String">&quot;ai&quot;</span>,
  mathclass=<span class="String">&quot;relation&quot;</span>,
  mathname=<span class="String">&quot;squaredots&quot;</span>,
  mathlist=<span class="Structure">{</span> <span class="Number">0x3A</span>, <span class="Number">0x3A</span> <span class="Structure">}</span>,
  unicodeslot=<span class="Number">0x2237</span>,
 <span class="Structure">}</span>,
</code></pre>

To add additional such shortcuts, simply add the `mathlist = { ...
}` line in `char-def.lua` and regenerate the format file.
