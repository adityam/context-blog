---
title     : "Formatting numbers in Lua"
linktitle : ""
date  : 2019-09-09
tags  :
  - luatex
  - programming
categories :
  - Formatting
---

I often use Lua to generate solution for homework assignments. Ideally, I want
the solution to look exactly how it would look if it were written by hand. But
this can be tricker than it appears at first glance. In this post, I'll
explain the issue and how I solve it. 

<!--more-->

To illustrate the formatting issue, let me consider an example of writing the
solution of how to find roots of a quadratic equation. Let's start with a
simple example. First let's define

<pre><code><span class="Statement">\defineenumeration</span><span class="Delimiter">[</span>question<span class="Delimiter">]</span>
<span class="Statement">\defineenumeration</span><span class="Delimiter">[</span>solution<span class="Delimiter">]</span>
</code></pre>

Then consider the following example.

<!--
\startquestion
  Find the roots of $x^2 + 5x + 6 = 0$.
\stopquestion

\startsolution
  Let's start by computing the determinant.
  \startformula
     Δ = b^2 - 4ac = 1.
  \stopformula
  Since $Δ > 0$, the roots are given by
  \startformula
    r_{1,2} = \dfrac{ -b \pm \sqrt{Δ} }{ 2a }
            = 3 \text{ and } 2.
  \stopformula
\stopsolution
-->

<pre><code><span class="Statement">\startquestion</span>
  Find the roots of <span class="String">$x^2 + 5x + 6 = 0$</span>.
<span class="Statement">\stopquestion</span>

<span class="Statement">\startsolution</span>
  Let's start by computing the determinant.
  <span class="Statement">\startformula</span>
     Δ = b^2 - 4ac = 1
  <span class="Statement">\stopformula</span>
  Since <span class="String">$Δ &gt; 0$</span>, the roots are given by
  <span class="Statement">\startformula</span>
    r_<span class="Delimiter">{</span>1,2<span class="Delimiter">}</span> = <span class="Statement">\dfrac</span><span class="Delimiter">{</span> -b <span class="Statement">\pm</span> <span class="Statement">\sqrt</span><span class="Delimiter">{</span>Δ<span class="Delimiter">}</span> <span class="Delimiter">}{</span> 2a <span class="Delimiter">}</span>
            = -2 <span class="Statement">\text</span><span class="Delimiter">{</span> and <span class="Delimiter">}</span> -3.
  <span class="Statement">\stopformula</span>
<span class="Statement">\stopsolution</span>
</code></pre>

Now suppose I want to generate a homework assignment with four or five such
questions. In order to ensure that I don't make any mistakes, I generate the
questions and the answers using Lua. For simplicity, let's assume that both
roots are real. Then, I can use `string.formatters` to easily generate the
assignment and the solution.

<!--
\startluacode

local formatters = string.formatters

local question = formatters[ [[
\startquestion
   Find the roots of $%s x^2 + %s x + %s = 0$.
\stopquestion
]] ]

local solution = formatters[ [[
\startsolution
  Let's start by computing the determinant.
  \startformula
     Δ = b^2 - 4ac = %s.
  \stopformula
  Since $Δ > 0$, the roots are given by
  \startformula
    r_{1,2} = \dfrac{ -b \pm \sqrt{Δ} }{ 2a }
            = %s \text{ and } %s.
  \stopformula
\stopsolution
]] ]

local sqrt = math.sqrt

assignment = assignment or { }

assignment.roots = function(a, b, c)
  context(question(a == 1 and "" or a, b, c))

  D = b^2 - 4*a*c
  r1 = (-b + sqrt(D))/(2*a)
  r2 = (-b - sqrt(D))/(2*a)

  context(solution(D, r1, r2))

end
\stopluacode
-->

<pre><code><span class="Statement">\startluacode</span>

<span class="Statement">local</span> formatters = string.formatters

<span class="Statement">local</span> question = formatters[ <span class="String">[[</span>
<span class="String">\startquestion</span>
<span class="String">   Find the roots of $%s x^2 + %s x + %s = 0$.</span>
<span class="String">\stopquestion</span>
<span class="String">]]</span> ]

<span class="Statement">local</span> solution = formatters[ <span class="String">[[</span>
<span class="String">\startsolution</span>
<span class="String">  Let's start by computing the determinant.</span>
<span class="String">  \startformula</span>
<span class="String">     Δ = b^2 - 4ac = %s.</span>
<span class="String">  \stopformula</span>
<span class="String">  Since $Δ &gt; 0$, the roots are given by</span>
<span class="String">  \startformula</span>
<span class="String">    r_{1,2} = \dfrac{ -b \pm \sqrt{Δ} }{ 2a }</span>
<span class="String">            = %s \text{ and } %s.</span>
<span class="String">  \stopformula</span>
<span class="String">\stopsolution</span>
<span class="String">]]</span> ]

<span class="Statement">local</span> sqrt = <span class="Identifier">math.sqrt</span>

assignment = assignment <span class="Operator">or</span> <span class="Structure">{</span> <span class="Structure">}</span>

assignment.roots = <span class="Function">function</span>(a, b, c)
  context(question(a == 1 <span class="Operator">and</span> <span class="String">&quot;&quot;</span> <span class="Operator">or</span> a, b, c))

  D = b^2 - 4*a*c
  r1 = (-b + sqrt(D))/(2*a)
  r2 = (-b - sqrt(D))/(2*a)

  context(solution(D, r1, r2))

<span class="Function">end</span>
<span class="Identifier">\stopluacode</span>
</code></pre>

Then, in the homework assignment, I can generate the above question and its
solution using:

<pre><code><span class="Statement">\ctxlua</span><span class="Delimiter">{</span>assignment.roots(1, 5, 6)<span class="Delimiter">}</span>
</code></pre>

The above generated solution works well when all numbers are integer valued.
However, the generated solution is not ideal when some of the calculations
result in floats. For example:

<pre><code><span class="Statement">\ctxlua</span><span class="Delimiter">{</span>assignment.roots(1, 4, 2)<span class="Delimiter">}</span>
</code></pre>

will generate:

<pre><code><span class="Statement">\startquestion</span>
  Find the roots of <span class="String">$x^2 + 4x + 2 = 0$</span>.
<span class="Statement">\stopquestion</span>

<span class="Statement">\startsolution</span>
  Let's start by computing the determinant.
  <span class="Statement">\startformula</span>
     Δ = b^2 - 4ac = <span class="Type">8.0</span>.
  <span class="Statement">\stopformula</span>
  Since <span class="String">$Δ &gt; 0$</span>, the roots are given by
  <span class="Statement">\startformula</span>
    r_<span class="Delimiter">{</span>1,2<span class="Delimiter">}</span> = <span class="Statement">\dfrac</span><span class="Delimiter">{</span> -b <span class="Statement">\pm</span> <span class="Statement">\sqrt</span><span class="Delimiter">{</span>Δ<span class="Delimiter">}</span> <span class="Delimiter">}{</span> 2a <span class="Delimiter">}</span>
            = <span class="Type">-0.5857864376269</span> <span class="Statement">\text</span><span class="Delimiter">{</span> and <span class="Delimiter">}</span> <span class="Type">-3.4142135623731</span>.
  <span class="Statement">\stopformula</span>
<span class="Statement">\stopsolution</span>
</code></pre>

Technically, the solution is correct. But one never types a float with a
precision of 12 decimal places. Of course, I could change the `%s` in the
template to `%.3f` as follows:

<pre><code><span class="Statement">local</span> solution = formatters[ <span class="String">[[</span>
<span class="String">\startsolution</span>
<span class="String">  Let's start by computing the determinant.</span>
<span class="String">  \startformula</span>
<span class="String">     Δ = b^2 - 4ac = <span class="Type">%.3f</span>.</span>
<span class="String">  \stopformula</span>
<span class="String">  Since $Δ &gt; 0$, the roots are given by</span>
<span class="String">  \startformula</span>
<span class="String">    r_{1,2} = \dfrac{ -b \pm \sqrt{Δ} }{ 2a }</span>
<span class="String">            = <span class="Type">%.3f</span> \text{ and } <span class="Type">%.3f</span>.</span>
<span class="String">  \stopformula</span>
<span class="String">\stopsolution</span>
<span class="String">]]</span> ]
</code></pre>

For the second problem, this will generate:

<pre><code><span class="Statement">\startquestion</span>
  Find the roots of <span class="String">$x^2 + 4x + 2 = 0$</span>.
<span class="Statement">\stopquestion</span>

<span class="Statement">\startsolution</span>
  Let's start by computing the determinant.
  <span class="Statement">\startformula</span>
     Δ = b^2 - 4ac = <span class="Type">8.000</span>.
  <span class="Statement">\stopformula</span>
  Since <span class="String">$Δ &gt; 0$</span>, the roots are given by
  <span class="Statement">\startformula</span>
    r_<span class="Delimiter">{</span>1,2<span class="Delimiter">}</span> = <span class="Statement">\dfrac</span><span class="Delimiter">{</span> -b <span class="Statement">\pm</span> <span class="Statement">\sqrt</span><span class="Delimiter">{</span>Δ<span class="Delimiter">}</span> <span class="Delimiter">}{</span> 2a <span class="Delimiter">}</span>
            = <span class="Type">-0.586</span> <span class="Statement">\text</span><span class="Delimiter">{</span> and <span class="Delimiter">}</span> <span class="Type">-3.414</span>.
  <span class="Statement">\stopformula</span>
<span class="Statement">\stopsolution</span>
</code></pre>

which is partially acceptable (when typesetting the solution by hand, one
would uses `Δ = 8` rather than `Δ = 8.000`) but for the first problem, we now get 

<pre><code><span class="Statement">\startquestion</span>
  Find the roots of <span class="String">$x^2 + 5x + 6 = 0$</span>.
<span class="Statement">\stopquestion</span>

<span class="Statement">\startsolution</span>
  Let's start by computing the determinant.
  <span class="Statement">\startformula</span>
     Δ = b^2 - 4ac = <span class="Type">1.000</span>.
  <span class="Statement">\stopformula</span>
  Since <span class="String">$Δ &gt; 0$</span>, the roots are given by
  <span class="Statement">\startformula</span>
    r_<span class="Delimiter">{</span>1,2<span class="Delimiter">}</span> = <span class="Statement">\dfrac</span><span class="Delimiter">{</span> -b <span class="Statement">\pm</span> <span class="Statement">\sqrt</span><span class="Delimiter">{</span>Δ<span class="Delimiter">}</span> <span class="Delimiter">}{</span> 2a <span class="Delimiter">}</span>
            = <span class="Type">-2.000</span> <span class="Statement">\text</span><span class="Delimiter">{</span> and <span class="Delimiter">}</span> <span class="Type">-3.000</span>.
  <span class="Statement">\stopformula</span>
<span class="Statement">\stopsolution</span>
</code></pre>

which is not ideal.

So, to typeset such examples, I need to format numbers as follows:

* If the number is an integer, use `%d`.
* If the number is a float, use `%.3f`.

However, once you think about it, the above spec is not complete. In addition,
what we want is that

* If `%.3f` gives `"0.000"`, using (the tex equivalent of) `%.3e`.

Who knew simply formatting numbers could be so complicated! Anyways, here is a
simple function that does this formatting:

<pre><code><span class="Statement">local</span> mathtype, floor  = math.<span class="Identifier">type</span>, <span class="Identifier">math.floor</span>
<span class="Statement">local</span> format, strlen, match = <span class="Identifier">string.format</span>, <span class="Identifier">string.len</span>, <span class="Identifier">string.match</span>

formatnumber = <span class="Function">function</span>(a)
    <span class="Conditional">if</span> mathtype(a) == <span class="String">&quot;integer&quot;</span> <span class="Operator">or</span> floor(a) == a <span class="Conditional">then</span>
        <span class="Statement">return</span> format(<span class="String">&quot;%d&quot;</span>, a)
    <span class="Conditional">else</span>
        str = format(<span class="String">&quot;%s&quot;</span>, a)
        fmt = format(<span class="String">&quot;%.3f&quot;</span>, a)
        exp = format(<span class="String">&quot;%.3e&quot;</span>, a)
        <span class="Conditional">if</span> strlen(str) &lt; strlen(fmt) <span class="Conditional">then</span>
            <span class="Statement">return</span> str
        <span class="Conditional">elseif</span> fmt == <span class="String">&quot;0.000&quot;</span> <span class="Conditional">then</span>
             x = match(exp, <span class="String">&quot;(.*)e&quot;</span>)
             y = match(exp, <span class="String">&quot;e(.*)&quot;</span>)
             <span class="Statement">return</span> format(<span class="String">&quot;%s </span><span class="SpecialChar">\\</span><span class="String">times 10^{%d}&quot;</span>, x, y)
        <span class="Conditional">else</span>
            <span class="Statement">return</span> fmt
        <span class="Conditional">end</span>
    <span class="Conditional">end</span>
<span class="Function">end</span>
</code></pre>

We first check if the number is an integer (using `math.type(a) == "integer"`)
or if the number is a float of the type `8.0` (using `math.floor(a) == a`) and
if so, format the number using `%d`.

We then next check if casting the number to a string leads to a shorter string than
formatting it using `%.3f`. If so, we format it using `%s`. This ensures that
a number like `8.2` is typeset as `8.2` rather than `8.200`.

Finally, we check if formatting the number using `%.3f` gives `"0.000"`. If
so, we typeset the tex equvalent of `%.3e`.

Phew!

To use this code, I use `%s` in my templates, and then call the template as

<pre><code>context(solution(formatnumber(D), formatnumber(r1), formatnumber(r2)))
</code></pre>

This gives me correct formatting in all the edge cases.

