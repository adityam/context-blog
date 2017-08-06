---
categories:
  - Formatting
date: 2012-09-29
tags:
  - t-vim
  - code formatting
  - blank lines

title: "Removing multiple blank lines when typesetting code listings"
linktitle: "Removing blank lines from code listings"

---

The `listings` package in LaTeX has an option to collapse multiple empty lines
into a single empty line when typesetting code lists. Today, there was a
question on [TeX.SE] how to do something similar when using the `minted`
package. The `t-vim` module uses the same principle as the `minted` package.
So, I wondered how one could collapse multiple empty lines into a single
line in `t-vim`?

<!--more-->

[TeX.SE]: https://tex.stackexchange.com/questions/74648/remove-blank-lines-in-minted

In the `vim` module, it is possible to specify a `vimrc` file that is sourced
when the code snippet is loaded in the editor. I included this option to
pass options to syntax highlighting (e.g., for laguages like `sh` and `tex`,
one can specify the _flavor_ using keywords set in the `.vimrc` file). 

One can use this feature to pre-process the file using `vim` macros. The
following regular expression collapses multiple lines to a single line:

```
%s/\(^\s*\n\)\{2,\}/\r/ge | w
```

So, we want this regular expression to be run when the file is loaded. The
`t-vim` module writes the file with extension `.tmp`, so the following
snippet works:

<!--
au BufEnter *.tmp %s/\(^\s*\n\)\{2,\}/\r/ge | w
-->

<pre><code><span class="Statement">au</span> <span class="Type">BufEnter</span> *.tmp <span class="Number">%</span><span class="Statement">s</span><span class="Delimiter">/</span><span class="SpecialChar">\(</span>^\s*\n<span class="SpecialChar">\)</span>\{2,\}<span class="Delimiter">/</span>\r<span class="Delimiter">/</span><span class="Special">ge</span> | <span class="Statement">w</span>
</code></pre>

We may use this from the `t-vim` module as follows:

<!----
\usemodule[vim]
 
\startvimrc[name=collapse]
au BufEnter *.tmp %s/\(^\s*\n\)\{2,\}/\r/ge | w
\stopvimrc
 
 
\definevimtyping[CPPtyping][syntax=cpp, vimrc=collapse]
 
\starttext
\startCPPtyping
  i++;
 
 
  i++;
 
 
 
 
 
 
  i--;
\stopCPPtyping
\stoptext
-->

<pre><code><span class="Identifier">\usemodule</span><span class="Delimiter">[</span><span class="Type">vim</span><span class="Delimiter">]</span>
<span class="Delimiter"> </span>
<span class="Keyword">\startvimrc</span><span class="Delimiter">[</span><span class="Type">name=collapse</span><span class="Delimiter">]</span>
<span class="Statement">au</span> <span class="Type">BufEnter</span> *.tmp <span class="Number">%</span><span class="Statement">s</span><span class="Delimiter">/</span><span class="SpecialChar">\(</span>^\s*\n<span class="SpecialChar">\)</span>\{2,\}<span class="Delimiter">/</span>\r<span class="Delimiter">/</span><span class="Special">ge</span> | <span class="Statement">w</span>
<span class="Keyword">\stopvimrc</span>
<span class="Keyword"> </span>
<span class="Keyword"> </span>
<span class="Identifier">\definevimtyping</span><span class="Delimiter">[</span><span class="Type">CPPtyping</span><span class="Delimiter">][</span><span class="Type">syntax=cpp, vimrc=collapse</span><span class="Delimiter">]</span>
<span class="Delimiter"> </span>
<span class="PreProc">\starttext</span>
<span class="PreProc">\startCPPtyping</span>
<span class="Special">  i++;</span>
<span class="Special"> </span>
<span class="Special"> </span>
<span class="Special">  i++;</span>
<span class="Special"> </span>
<span class="Special"> </span>
<span class="Special"> </span>
<span class="Special"> </span>
<span class="Special"> </span>
<span class="Special"> </span>
<span class="Special">  i--;</span>
<span class="PreProc">\stopCPPtyping</span>
<span class="PreProc">\stoptext</span>
</code></pre>

Agreed, this is not as simple as the `extralines=1` option in the listings
package. But, it is not too complicated when you consider the fact that I had
not thought about this feature at all when I wrote the `t-vim` module.


