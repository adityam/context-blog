---
categories:
- announcement
date: 2017-07-22T21:53:37-04:00
title: "Correct math escape in t-vim"
tags:
- t-vim

---

There is a feature in `t-vim` module that allows the use of TeX code in
comments, which is useful when typeset math in comments. For example: 

<!--
\definevimtyping[C][syntax=c, escape=on]

\startC
/* The following function computes the roots of \m{ax^2+bx+c=0}
 * using the determinant \m{\Delta=\frac{-b\pm\sqrt{b^2-2ac}}{2a}} 
 */

double root (double a, double b, double c) {....}
\stopC
-->

<pre><code><span class="Identifier">\definevimtyping</span><span class="Delimiter">[</span><span class="Type">C</span><span class="Delimiter">][</span><span class="Type">syntax=c, escape=on</span><span class="Delimiter">]</span>

<span class="Keyword">\startC</span>
<span class="Comment">/*</span><span class="Comment"> The following function computes the roots of <span class="Statement">\m</span><span class="Delimiter">{</span>ax^2+bx+c=0<span class="Delimiter">}</span>
<span class="Comment"> * using the determinant <span class="Statement">\m</span><span class="Delimiter">{</span><span class="Statement">\Delta</span>=<span class="Statement">\frac</span><span class="Delimiter">{</span>-b<span class="Statement">\pm\sqrt</span><span class="Delimiter">{</span>b^2-2ac<span class="Delimiter">}}{</span>2a<span class="Delimiter">}}</span>
<span class="Comment"> </span><span class="Comment">*/</span>

<span class="Type">double</span> root (<span class="Type">double</span> a, <span class="Type">double</span> b, <span class="Type">double</span> c) {....}
<span class="Keyword">\stopC</span>
</code></pre>

<!--more-->

The `escape=on` option activates this feature. Only `\`, `{`, and `}` have
their usual meaning inside the `Comment` region, so I use `\m{...}` to enter
math mode. The above code get typeset as:

{{< img class="center" src="root.png" alt="Typeset example" >}}

Gerion Entrup reported on the [context mailing list][list] that the spacing
inside the math mode is not always correct. The incorrect behavior is not
visit in the above example, because there was no blank space inside the math
mode. As soon as we add space in the math mode, the output is too
spaced out. For example,

<pre><code><span class="Identifier">\definevimtyping</span><span class="Delimiter">[</span><span class="Type">C</span><span class="Delimiter">][</span><span class="Type">syntax=c, escape=on</span><span class="Delimiter">]</span>

<span class="Keyword">\startC</span>
<span class="Comment">/*</span><span class="Comment"> The following function computes the roots of <span class="Statement">\m</span><span class="Delimiter">{</span>ax^2 + bx + c = 0<span class="Delimiter">}</span>
<span class="Comment"> * using the determinant <span class="Statement">\m</span><span class="Delimiter">{</span><span class="Statement">\Delta</span> = <span class="Statement">\frac</span><span class="Delimiter">{</span>-b<span class="Statement"> \pm \sqrt</span><span class="Delimiter">{</span>b^2 - 2ac<span class="Delimiter">}}{</span>2a<span class="Delimiter">}}</span>
<span class="Comment"> </span><span class="Comment">*/</span>

<span class="Type">double</span> root (<span class="Type">double</span> a, <span class="Type">double</span> b, <span class="Type">double</span> c) {....}
<span class="Keyword">\stopC</span>
</code></pre>

{{< img class="center" src="root-2.png" alt="Typeset example" >}}

[list]: https://mailman.ntg.nl/pipermail/ntg-context/2017/089189.html

Spacing inside math mode should not affect the output. What is happening
here? After a bit of sleuthing, I found the culprit. 

As I had ranted in an old [blog post][post], I want syntax highlighting
programs to generate clean TeX output. Therefore, I do not escape space and
newline characters. After all, it is easy enough to tell ConTeXt to honor
spaces and newlines by using `\obeyspaces` and `\obeylines`. By themselves,
`\obeyspaces` and `\obeylines` are okay. 

<!--
\bgroup
\obeylines\obeyspaces\tttf
The following function computes the roots of \m{ax^2 + bx + c = 0}
using the determinant \m{\Delta = \frac{-b \pm \sqrt{b^2 - 2ac}}{2a}}
\egroup
-->

<pre><code><span class="Character">\bgroup</span>
<span class="Statement">\obeylines\obeyspaces\tttf</span>
The following function computes the roots of <span class="Statement">\m</span><span class="Delimiter">{</span>ax^2 + bx + c = 0<span class="Delimiter">}</span>
using the determinant <span class="Statement">\m</span><span class="Delimiter">{</span><span class="Statement">\Delta</span> = <span class="Statement">\frac</span><span class="Delimiter">{</span>-b <span class="Statement">\pm</span> <span class="Statement">\sqrt</span><span class="Delimiter">{</span>b^2 - 2ac<span class="Delimiter">}}{</span>2a<span class="Delimiter">}}</span>
<span class="Character">\egroup</span>
</code></pre>

{{< img class="center" src="test-1.png" alt="Typeset example" >}}

In `t-vim`, I wanted to control how to wrap long lines. The default option is
not to do anything and let the user figure out how to wrap the source code.
There is also an option to split a long line at a space.
(For other options on splitting long lines, see the [documentation]). 

To control whether a long line should be split at a space or not, I redefined
`\obeyedspace`. For those who are not familiar with ConTeXt internals,
whenever `\obeyspaces` is active, space is mapped to `\obeyedspace`. This
makes it possible, for example, to visualize spaces. For example,

<!--
\bgroup
\obeylines\obeyspaces\tttf\def\obeyedspace{-}
The following function computes the roots 
\egroup
-->

<pre><code><span class="Character">\bgroup</span>
<span class="Statement">\obeylines\obeyspaces\tttf</span><span class="Character">\def</span><span class="Statement">\obeyedspace</span><span class="Delimiter">{</span>-<span class="Delimiter">}</span>
The following function computes the roots
<span class="Character">\egroup</span>
</code></pre>

{{< img class="center" src="test-2.png" alt="Typeset example" >}}

So, to allow a line to break at a space, I use 

<!--
\def\obeyedspace{\hskip\interwordspace\relax}
-->

<pre><code><span class="Character">\def</span><span class="Statement">\obeyedspace</span><span class="Delimiter">{</span><span class="Statement">\hskip\interwordspace\relax</span><span class="Delimiter">}</span>
</code></pre>
 
and to prevent lines from breaking at a space, I use

<pre><code><span class="Character">\def</span><span class="Statement">\obeyedspace</span><span class="Delimiter">{</span><span class="Statement">\kern\interwordspace\relax</span><span class="Delimiter">}</span>
</code></pre>

However, this definition creates a wreck inside math mode.
<!--
\bgroup
\obeylines\obeyspaces\tttf\def\obeyedspace{\hskip\interwordspace\relax}
The following function computes the roots of \m{ax^2 + bx + c = 0}
using the determinant \m{\Delta = \frac{-b \pm \sqrt{b^2 - 2ac}}{2a}}
\egroup
-->

<pre><code><span class="Character">\bgroup</span>
<span class="Statement">\obeylines\obeyspaces\tttf</span>
<span class="Character">\def</span><span class="Statement">\obeyedspace</span><span class="Delimiter">{</span><span class="Statement">\hskip\interwordspace\relax</span><span class="Delimiter">}</span>
The following function computes the roots of <span class="Statement">\m</span><span class="Delimiter">{</span>ax^2 + bx + c = 0<span class="Delimiter">}</span>
using the determinant <span class="Statement">\m</span><span class="Delimiter">{</span><span class="Statement">\Delta</span> = <span class="Statement">\frac</span><span class="Delimiter">{</span>-b <span class="Statement">\pm</span> <span class="Statement">\sqrt</span><span class="Delimiter">{</span>b^2 - 2ac<span class="Delimiter">}}{</span>2a<span class="Delimiter">}}</span>
<span class="Character">\egroup</span>
</code></pre>

{{< img class="center" src="test-3.png" alt="Typeset example" >}}

Now, that we know what is going on, it is an easy fix (suggested by Henri
Menke). Define `\obeyedspace` to

<pre><code><span class="Character">\def</span><span class="Statement">\obeyedspace</span><span class="Delimiter">{</span><span class="Statement">\hskip\interwordspace\relax</span><span class="Delimiter">}</span>
</code></pre>

Let's test this.

<pre><code><span class="Character">\bgroup</span>
<span class="Statement">\obeylines\obeyspaces\tttf</span>
<span class="Character">\def</span><span class="Statement">\obeyedspace</span><span class="Delimiter">{</span><span class="Statement">\mathortext\normalspace</span><span class="Delimiter">{</span><span class="Statement">\hskip\interwordspace\relax</span><span class="Delimiter">}}</span>
The following function computes the roots of <span class="Statement">\m</span><span class="Delimiter">{</span>ax^2 + bx + c = 0<span class="Delimiter">}</span>
using the determinant <span class="Statement">\m</span><span class="Delimiter">{</span><span class="Statement">\Delta</span> = <span class="Statement">\frac</span><span class="Delimiter">{</span>-b <span class="Statement">\pm</span> <span class="Statement">\sqrt</span><span class="Delimiter">{</span>b^2 - 2ac<span class="Delimiter">}}{</span>2a<span class="Delimiter">}}</span>
<span class="Character">\egroup</span>
</code></pre>

{{< img class="center" src="test-4.png" alt="Typeset example" >}}

I'll fix this bug in the next release of `t-vim`.

[post]: https://randomdeterminism.wordpress.com/2011/06/06/clean-tex-output/
[documentation]: https://github.com/adityam/filter/blob/master/vim-README.md#wrapping-lines
