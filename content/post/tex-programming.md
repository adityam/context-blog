---
title: "TeX Programming: The past, the present, and the future"
linktitle: "TeX Programming"
date: 2009-03-05
categories:
  - programming
tags:
  - tables
  - separating content and presentation
  - luatex

---

There was an interesting thread on the ConTeXt [mailing list][thread], which I
am summarizing in this post. To make the post interesting, I changed the
problem slightly. So, the solutions posted here were not part of the thread,
but are in the same spirit.

Suppose you want to typeset (in ConTeXt) all possible sum of roll of two die. Something like this:

{{< img src="table.png" class="center" alt="Multiplication table" >}}

One way to do this will be to type the whole thing by hand:

<!--
\bTABLE
    \bTR \bTD $(+)$ \eTD \bTD 1 \eTD \bTD 2 \eTD \bTD 3 \eTD \bTD 4  \eTD \bTD 5  \eTD \bTD 6  \eTD \eTR
    \bTR \bTD 1     \eTD \bTD 2 \eTD \bTD 3 \eTD \bTD 4 \eTD \bTD 5  \eTD \bTD 6  \eTD \bTD 7  \eTD \eTR
    \bTR \bTD 2     \eTD \bTD 3 \eTD \bTD 4 \eTD \bTD 5 \eTD \bTD 6  \eTD \bTD 7  \eTD \bTD 8  \eTD \eTR
    \bTR \bTD 3     \eTD \bTD 4 \eTD \bTD 5 \eTD \bTD 6 \eTD \bTD 7  \eTD \bTD 8  \eTD \bTD 9  \eTD \eTR
    \bTR \bTD 4     \eTD \bTD 5 \eTD \bTD 6 \eTD \bTD 7 \eTD \bTD 8  \eTD \bTD 9  \eTD \bTD 10 \eTD \eTR
    \bTR \bTD 5     \eTD \bTD 6 \eTD \bTD 7 \eTD \bTD 8 \eTD \bTD 9  \eTD \bTD 10 \eTD \bTD 11 \eTD \eTR
    \bTR \bTD 6     \eTD \bTD 7 \eTD \bTD 8 \eTD \bTD 9 \eTD \bTD 10 \eTD \bTD 11 \eTD \bTD 12 \eTD \eTR
\eTABLE
-->

<pre><code><span class="Statement">\bTABLE</span>
    <span class="Statement">\bTR</span> <span class="Statement">\bTD</span> <span class="String">$(+)$</span> <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 1 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 2 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 3 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 4  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 5  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 6  <span class="Statement">\eTD</span> <span class="Statement">\eTR</span>
    <span class="Statement">\bTR</span> <span class="Statement">\bTD</span> 1     <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 2 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 3 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 4 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 5  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 6  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 7  <span class="Statement">\eTD</span> <span class="Statement">\eTR</span>
    <span class="Statement">\bTR</span> <span class="Statement">\bTD</span> 2     <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 3 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 4 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 5 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 6  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 7  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 8  <span class="Statement">\eTD</span> <span class="Statement">\eTR</span>
    <span class="Statement">\bTR</span> <span class="Statement">\bTD</span> 3     <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 4 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 5 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 6 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 7  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 8  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 9  <span class="Statement">\eTD</span> <span class="Statement">\eTR</span>
    <span class="Statement">\bTR</span> <span class="Statement">\bTD</span> 4     <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 5 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 6 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 7 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 8  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 9  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 10 <span class="Statement">\eTD</span> <span class="Statement">\eTR</span>
    <span class="Statement">\bTR</span> <span class="Statement">\bTD</span> 5     <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 6 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 7 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 8 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 9  <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 10 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 11 <span class="Statement">\eTD</span> <span class="Statement">\eTR</span>
    <span class="Statement">\bTR</span> <span class="Statement">\bTD</span> 6     <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 7 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 8 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 9 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 10 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 11 <span class="Statement">\eTD</span> <span class="Statement">\bTD</span> 12 <span class="Statement">\eTD</span> <span class="Statement">\eTR</span>
<span class="Statement">\eTABLE</span>
</code></pre>

I am using [Natural Tables] since it is very easy to change their output. For example, to get the effect shown in the above figure, I can just add

<!--
\setupTABLE[each][each][width=2em,height=2em,align={middle,middle}]
\setupTABLE[r][1][background=color,backgroundcolor=gray]
\setupTABLE[c][1][background=color,backgroundcolor=gray]
-->

<pre><code><span class="Statement">\setupTABLE</span><span class="Delimiter">[</span>each<span class="Delimiter">][</span>each<span class="Delimiter">][</span>width=<span class="Number">2em</span>,height=<span class="Number">2em</span>,align=<span class="Delimiter">{</span>middle,middle<span class="Delimiter">}]</span>
<span class="Statement">\setupTABLE</span><span class="Delimiter">[</span>r<span class="Delimiter">][</span>1<span class="Delimiter">][</span>background=color,backgroundcolor=gray<span class="Delimiter">]</span>
<span class="Statement">\setupTABLE</span><span class="Delimiter">[</span>c<span class="Delimiter">][</span>1<span class="Delimiter">][</span>background=color,backgroundcolor=gray<span class="Delimiter">]</span>
</code></pre>

But that is not the point of this post. Typing everything by hand is error prone, and non-reusable. I want to show how to automate the above task. In any ordinary programming language we would do this as (pseudo code)

<!--
"start table"
  "start table row"
      "table element: (+)"
      for y in [1..6] do
          "table element: #{y}"}
  "stop table row"
  for x in [1..6] do
      "start table row"
          "table element: #{x}"
          for y in [1..6] do
              "table element #{x+y}"
          end
      "stop table row"
  end
"stop table"
-->

<pre><code><span class="String">&quot;</span><span class="String">start table</span><span class="String">&quot;</span>
  <span class="String">&quot;</span><span class="String">start table row</span><span class="String">&quot;</span>
      <span class="String">&quot;</span><span class="String">table element: (+)</span><span class="String">&quot;</span>
      <span class="Repeat">for</span> y <span class="Keyword">in</span> [<span class="Float">1..6</span>] <span class="Keyword">do</span>
          <span class="String">&quot;</span><span class="String">table element: #{y}</span><span class="String">&quot;</span><span class="Error">}</span>
  <span class="String">&quot;</span><span class="String">stop table row</span><span class="String">&quot;</span>
  <span class="Repeat">for</span> x <span class="Keyword">in</span> [<span class="Float">1..6</span>] <span class="Keyword">do</span>
      <span class="String">&quot;</span><span class="String">start table row</span><span class="String">&quot;</span>
          <span class="String">&quot;</span><span class="String">table element: #{x}</span><span class="String">&quot;</span>
          <span class="Repeat">for</span> y <span class="Keyword">in</span> [<span class="Float">1..6</span>] <span class="Keyword">do</span>
              <span class="String">&quot;</span><span class="String">table element #{x+y}</span><span class="String">&quot;</span>
          <span class="Keyword">end</span>
      <span class="String">&quot;</span><span class="String">stop table row</span><span class="String">&quot;</span>
  <span class="Repeat">end</span>
<span class="String">&quot;</span><span class="String">stop table</span><span class="String">&quot;</span>
</code></pre>

Unfortunately, TeX is no ordinary programming language. The first thing that comes to mind is to use ConTeXt’s equivalent of a for loop---`\dorecurse`

<!--
\bTABLE
    \bTR
    \bTD $(+)$ \eTD
    \dorecurse{6}
        {\bTD \recurselevel \eTD}
    \eTR
    \dorecurse{6}
      {\bTR
          \bTD \recurselevel \eTD
          \edef\firstrecurselevel{\recurselevel}
          \dorecurse{6}
            {\bTD \the\numexpr\firstrecurselevel+\recurselevel \eTD}
      \eTR}
\eTABLE
-->

<pre><code><span class="Statement">\bTABLE</span>
    <span class="Statement">\bTR</span>
    <span class="Statement">\bTD</span> <span class="String">$(+)$</span> <span class="Statement">\eTD</span>
    <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
        <span class="Delimiter">{</span><span class="Statement">\bTD</span> <span class="Statement">\recurselevel</span> <span class="Statement">\eTD</span><span class="Delimiter">}</span>
    <span class="Statement">\eTR</span>
    <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
      <span class="Delimiter">{</span><span class="Statement">\bTR</span>
          <span class="Statement">\bTD</span> <span class="Statement">\recurselevel</span> <span class="Statement">\eTD</span>
          <span class="Statement">\edef\firstrecurselevel</span><span class="Delimiter">{</span><span class="Statement">\recurselevel</span><span class="Delimiter">}</span>
          <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
            <span class="Delimiter">{</span><span class="Statement">\bTD</span> <span class="Statement">\the\numexpr\firstrecurselevel</span>+<span class="Statement">\recurselevel</span> <span class="Statement">\eTD</span><span class="Delimiter">}</span>
      <span class="Statement">\eTR</span><span class="Delimiter">}</span>
<span class="Statement">\eTABLE</span>
</code></pre>

This however does not work as expected because `\dorecurse` is not fully expandable. One way to get around this problem is to expand the appropriate parts of the body of `\dorecurse`

<!--
\bTABLE
  \bTR
  \bTD $(+)$ \eTD
  \dorecurse{6}
    {\expandafter \bTD \recurselevel \eTD}
  \eTR
  \dorecurse{6}
    {\bTR
        \edef\firstrecurselevel{\recurselevel}
        \expandafter\bTD \recurselevel \eTD
        \dorecurse{6}
        {\expandafter\expandafter\expandafter
         \bTD
            \expandafter\expandafter\expandafter
            \the\expandafter\expandafter\expandafter
            \numexpr\expandafter\firstrecurselevel\expandafter
            +%
            \recurselevel
        \eTD}
      \eTR}
\eTABLE
-->

<pre><code><span class="Statement">\bTABLE</span>
  <span class="Statement">\bTR</span>
  <span class="Statement">\bTD</span> <span class="String">$(+)$</span> <span class="Statement">\eTD</span>
  <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
    <span class="Delimiter">{</span><span class="Statement">\expandafter</span> <span class="Statement">\bTD</span> <span class="Statement">\recurselevel</span> <span class="Statement">\eTD</span><span class="Delimiter">}</span>
  <span class="Statement">\eTR</span>
  <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
    <span class="Delimiter">{</span><span class="Statement">\bTR</span>
        <span class="Statement">\edef\firstrecurselevel</span><span class="Delimiter">{</span><span class="Statement">\recurselevel</span><span class="Delimiter">}</span>
        <span class="Statement">\expandafter\bTD</span> <span class="Statement">\recurselevel</span> <span class="Statement">\eTD</span>
        <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
        <span class="Delimiter">{</span><span class="Statement">\expandafter\expandafter\expandafter</span>
         <span class="Statement">\bTD</span>
            <span class="Statement">\expandafter\expandafter\expandafter</span>
            <span class="Statement">\the\expandafter\expandafter\expandafter</span>
            <span class="Statement">\numexpr\expandafter\firstrecurselevel\expandafter</span>
            +<span class="Comment">%</span>
            <span class="Statement">\recurselevel</span>
        <span class="Statement">\eTD</span><span class="Delimiter">}</span>
      <span class="Statement">\eTR</span><span class="Delimiter">}</span>
<span class="Statement">\eTABLE</span>
</code></pre>

Behold! All those `\expandafter`s. The reason they are needed was succinctly explained by David Kastrup in [his TeX interview][Kastrup]

> Instead, macros are used as a substitute for programming. TeX’s macro
> expansion language is the only way to implement conditionals and loops, but
> the corresponding control variables can’t be influenced by macro expansion
> (TeX’s “mouth” in Knuth’s terminology). Instead assignments must be executed
> by the back end (TeX’s “stomach”). Stomach and mouth execute at different
> times and independently from one another. But it is not possible to solve
> nontrivial programming tasks with either: only the unholy chimera made from
> both can solve serious problems. eTeX gives the mouth a few more teeth and
> changes some of that, but the changes are not really fundamental: expansion
> still makes no assignments.

Once you get the hang of it, adding all those `\expandafter`s is “simple” (Taco Hoekwater in a [post][Taco]):

> The trick to \expandafter is that you (normally) write it backwards
> until reaching a moment in time where TeX is not scanning an argument.

> Say you have a macro that contains some stuff in it to be typeset by
> `\type`:
>
>     \def\mystuff{Some literal stuff}
>
> Then you begin with
>
>     \type{\mystuff}
>
> but that obviously doesn't work, you want the final input to look like
>
>     \type{Some literal stuff}
>
> Since `\expandafter` expands the token that follows the after next token
> -- whatever the next token is -- you have to insert it backwards across the
> opening brace of the argument, like so:
>
>     \type\expandafter{\mystuff}
>
> But this wouldn't work, yet: you are still in the middle of an
> expression (the `\type` expects an argument, and it gets `\expandafter`
> as it stands).
> 
> Luckily, `\expandafter` *itself* is an expandable command, so you
> jump back once more and insert another one:
>
>     \expandafter\type\expandafter{\mystuff}
>
> Now you are on 'neutral ground', and can stop backtracking.
> Easy, once you get the hang of it.

Fortunately, in ConTeXt you do not need to do all this mental arithmetic. ConTeXt provides a command `\expanded` which expands its argument. It only works if the expanded code does not try to scan the next character. In this case, `\bTD`—`\eTD` can be included in `\expanded`, while `\bTR`—`\eTR` cannot. So we end up with:

<!--
\bTABLE
  \bTR
    \bTD $(+)$ \eTD
    \dorecurse{6}
        {\expanded{\bTD \recurselevel \eTD}}
  \eTR
  \dorecurse{6}
      {\bTR
          \expanded{\bTD \recurselevel \eTD}
          \edef\firstrecurselevel{\recurselevel}
          \dorecurse{6}
          {\expanded{\bTD \the\numexpr\firstrecurselevel+\recurselevel\relax \eTD}}
      \eTR}
\eTABLE
-->

<pre><code><span class="Statement">\bTABLE</span>
  <span class="Statement">\bTR</span>
    <span class="Statement">\bTD</span> <span class="String">$(+)$</span> <span class="Statement">\eTD</span>
    <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
        <span class="Delimiter">{</span><span class="Statement">\expanded</span><span class="Delimiter">{</span><span class="Statement">\bTD</span> <span class="Statement">\recurselevel</span> <span class="Statement">\eTD</span><span class="Delimiter">}}</span>
  <span class="Statement">\eTR</span>
  <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
      <span class="Delimiter">{</span><span class="Statement">\bTR</span>
          <span class="Statement">\expanded</span><span class="Delimiter">{</span><span class="Statement">\bTD</span> <span class="Statement">\recurselevel</span> <span class="Statement">\eTD</span><span class="Delimiter">}</span>
          <span class="Statement">\edef\firstrecurselevel</span><span class="Delimiter">{</span><span class="Statement">\recurselevel</span><span class="Delimiter">}</span>
          <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
          <span class="Delimiter">{</span><span class="Statement">\expanded</span><span class="Delimiter">{</span><span class="Statement">\bTD</span> <span class="Statement">\the\numexpr\firstrecurselevel</span>+<span class="Statement">\recurselevel\relax</span> <span class="Statement">\eTD</span><span class="Delimiter">}}</span>
      <span class="Statement">\eTR</span><span class="Delimiter">}</span>
<span class="Statement">\eTABLE</span>
</code></pre>

Wolfgang Schuster posted a much neater solution.

<!--
\bTABLE
  \bTR
  \bTD $(+)$ \eTD
  \dorecurse{6}
      {\bTD #1 \eTD}
  \eTR
  \dorecurse{6}
      {\bTR
      \bTD #1 \eTD
      \dorecurse{6}
          {\bTD \the\numexpr#1+##1 \eTD}
      \eTR}
\eTABLE
-->

<pre><code><span class="Statement">\bTABLE</span>
  <span class="Statement">\bTR</span>
  <span class="Statement">\bTD</span> <span class="String">$(+)$</span> <span class="Statement">\eTD</span>
  <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
      <span class="Delimiter">{</span><span class="Statement">\bTD</span> #1 <span class="Statement">\eTD</span><span class="Delimiter">}</span>
  <span class="Statement">\eTR</span>
  <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
      <span class="Delimiter">{</span><span class="Statement">\bTR</span>
      <span class="Statement">\bTD</span> #1 <span class="Statement">\eTD</span>
      <span class="Statement">\dorecurse</span><span class="Delimiter">{</span>6<span class="Delimiter">}</span>
          <span class="Delimiter">{</span><span class="Statement">\bTD</span> <span class="Statement">\the\numexpr</span>#1+##1 <span class="Statement">\eTD</span><span class="Delimiter">}</span>
      <span class="Statement">\eTR</span><span class="Delimiter">}</span>
<span class="Statement">\eTABLE</span>
</code></pre>

This makes TeX appear like a **normal** programming language. But only TeX
wizards like Wolfgang can discover such solutions. You need to know the TeX
digestive system inside out to even attempt something like this. Inspired by
Wolfgang’s solution, I tried the same thing with ConTeXt’s lesser known for
loops.

<!--
\bTABLE
  \bTR
      \bTD $(+)$ \eTD
      \for \y=1 \to 6 \step 1 \do
          {\bTD #1 \eTD}
  \eTR
  \for \x=1 \to 6 \step 1 \do
    {\bTR
        \bTD #1 \eTD
        \for \y=1 \to 6 \step 1 \do
            {\bTD \the\numexpr#1+##1 \eTD}
     \eTR}
\eTABLE
-->

<pre><code><span class="Statement">\bTABLE</span>
  <span class="Statement">\bTR</span>
      <span class="Statement">\bTD</span> <span class="String">$(+)$</span> <span class="Statement">\eTD</span>
      <span class="Statement">\for</span> <span class="Statement">\y</span>=1 <span class="Statement">\to</span> 6 <span class="Statement">\step</span> 1 <span class="Statement">\do</span>
          <span class="Delimiter">{</span><span class="Statement">\bTD</span> #1 <span class="Statement">\eTD</span><span class="Delimiter">}</span>
  <span class="Statement">\eTR</span>
  <span class="Statement">\for</span> <span class="Statement">\x</span>=1 <span class="Statement">\to</span> 6 <span class="Statement">\step</span> 1 <span class="Statement">\do</span>
    <span class="Delimiter">{</span><span class="Statement">\bTR</span>
        <span class="Statement">\bTD</span> #1 <span class="Statement">\eTD</span>
        <span class="Statement">\for</span> <span class="Statement">\y</span>=1 <span class="Statement">\to</span> 6 <span class="Statement">\step</span> 1 <span class="Statement">\do</span>
            <span class="Delimiter">{</span><span class="Statement">\bTD</span> <span class="Statement">\the\numexpr</span>#1+##1 <span class="Statement">\eTD</span><span class="Delimiter">}</span>
     <span class="Statement">\eTR</span><span class="Delimiter">}</span>
<span class="Statement">\eTABLE</span>
</code></pre>


Don’t worry if you don’t understand how the above works. With LuaTeX, even normal users have hope. Luigi Scarso posted the following code:

<!--
\startluacode
tprint = function(s) tex.sprint(tex.ctxcatcodes,s) end
tprint('\\bTABLE')
  tprint('\\bTR')
    tprint('\\bTD $(+)$ \\eTD')
    for y = 1,6 do
        tprint('\\bTD ' .. y .. '\\eTD')
    end
  tprint('\\eTR')
  for x = 1,6 do
      tprint('\\bTR')
      tprint('\\bTD ' .. x .. '\\eTD')
      for y = 1,6 do
          tprint('\\bTD' .. x+y .. '\\eTD')
      end
      tprint('\\eTR')
  end
tprint('\\eTABLE')
\stopluacode
-->

<pre><code><span class="Statement">\startluacode</span>
tprint = function(s) tex.sprint(tex.ctxcatcodes,s) end
tprint('<span class="Special">\\</span>bTABLE')
  tprint('<span class="Special">\\</span>bTR')
    tprint('<span class="Special">\\</span>bTD <span class="String">$(+)$</span> <span class="Special">\\</span>eTD')
    for y = 1,6 do
        tprint('<span class="Special">\\</span>bTD ' .. y .. '<span class="Special">\\</span>eTD')
    end
  tprint('<span class="Special">\\</span>eTR')
  for x = 1,6 do
      tprint('<span class="Special">\\</span>bTR')
      tprint('<span class="Special">\\</span>bTD ' .. x .. '<span class="Special">\\</span>eTD')
      for y = 1,6 do
          tprint('<span class="Special">\\</span>bTD' .. x+y .. '<span class="Special">\\</span>eTD')
      end
      tprint('<span class="Special">\\</span>eTR')
  end
tprint('<span class="Special">\\</span>eTABLE')
<span class="Statement">\stopluacode</span>
</code></pre>


Finally, with LuaTeX, we can implement simple algorithms in a simple way
inside TeX. In this case, the pure TeX solution using `\dorecurse` wasn’t too
difficult. But try to come up with a pure TeX solution that prints the
**average** of the numbers.

Here is a hint. Convert the numbers to dimensions by multiplying by `1pt`, do averaging using `\dimexpr`, then get rid of the point using `\withoutpt` and hope that the fixed precision mathematics in TeX did not mess things up.

#### Addendum: 

With current ConTeXt, I would use:

<!--
\startluacode
context.bTABLE()
  context.bTR()
    context.bTD() context("(+)") context.eTD()
    for y = 1,6 do
        context.bTD() context(y) context.eTD()
    end
  context.eTR()
  for x = 1,6 do 
      context.bTR()
          for y = 1,6 do
            context.bTD() context(x+y) context.eTD()
          end
      context.eTR()
  end
context.eTABLE()
\stopluacode
-->

<pre><code><span class="Statement">\startluacode</span>
context.bTABLE()
  context.bTR()
    context.bTD() context(&quot;$(+)$&quot;) context.eTD()
    for y = 1,6 do
        context.bTD() context(y) context.eTD()
    end
  context.eTR()
  for x = 1,6 do
      context.bTR()
      context.bTD() context(x) context.eTD()
          for y = 1,6 do
            context.bTD() context(x+y) context.eTD()
          end
      context.eTR()
  end
context.eTABLE()
<span class="Statement">\stopluacode</span>
</code></pre>


[thread]: https://mailman.ntg.nl/pipermail/ntg-context/2009/038576.html
[Natural Tables]: http://www.pragma-ade.com/general/manuals/enattab.pdf
[Kastrup]: http://tug.org/interviews/kastrup.html
[Taco]: https://mailman.ntg.nl/pipermail/ntg-context/2006/019649.html


