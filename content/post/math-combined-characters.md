---
title: "Comibined characters in Math"
date: 2017-08-07T16:56:30-04:00
categories:
- Mathematics
tags:
- asciimath
draft: true

---

In ConTeXt, it is possible to replace a pair of characters by another
chacter. By combining these recursively, we have the following magic.

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
`⟹ ` (`\Longrightarrow`). (You need ConTeXt version `2017.08.06` or newer for
most of these mappings to work). Here are the other comined characters that are
available.

| shortcut              | Mapped to      |
|-----------------------|:---------------|
| `:=`                  | `\colonequals` |
| `=:`                  | `\equalscolon` |
| `::=`                 | `\coloncolonequals` |
| `::`                  | `\squaredots`  |
| `<=`                  | `\le`          |
| `>=`                  | `\ge`          |
| `!=`                  | `\neq`         |
| `<<`                  | `\ll`          |
| '>>`                  | `\gg`          |
| `<<<`                 | `\lll`         |
| `>>>`                 | `\ggg`         |
| `==`                  | `\equiv`       |
| `===`                 | `\eqequiv` (a virtual character for mapping purposes) |
| `->`                  | `\rightarrow`  |
| `<-`                  | `\leftarrow`   |
| `<->`                 | `\leftrightarrow` |
| `==>`                 | `\Rightarrow`     |
| `<==`                 | `\Leftarrow`      |
| `<=>`                 | `\Leftrightarrow` |
| `===>`                | `\Longrightarrow` |
| `<===`                | `\Longleftarrow`  |
| `<==>`                | `\Longleftrightarrow` |
| <code>&#124;&#124;</code>  | `\doubleverticalbar`  |
| <code>&#124;&#124;&#124;</code>  | `\tripleverticalbar`  |
| `''`                  | `\doubleprime`        |
| `'''`                 | `\tripleprime`        |
| `''''`                | `\quadprime`          |
