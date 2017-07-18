---
categories:
  - markdown
date: 2012-06-01
tags:
  - gpp
title: "How I stopped worrying and started using Markdown like TeX"
linktitle: "Preprocessing Markdown with GPP"
draft: true

---

These days I type most of simple documents (short articles, blog entries,
course notes) in markdown. Markdown provides only the basic structured
elements (sections, emphasis, urls, lists, footnotes, syntax highlighting,
simple tables and figures) which makes it easy to transform the input into
multiple output formats. Most of the time, I still want PDF output and for
that, I use [pandoc] to convert markdown to [ConTeXt]. At the same time, I
have the peace of mind that if I need HTML or DOC output, I’ll be able to get
that easily.

[pandoc]: http://johnmacfarlane.net/pandoc/
[ConTeXt]: http://contextgarden.net/

For most of the last decade, I have almost exclusively used LaTeX/ConTeXt for
writing all my documents. After moving to Markdown, I miss three features of
TeX: separation of content and presentation; conditional inclusion of
content; and including external documents. In this post, I’ll explain how to
get these with Markdown.

## Separation of content and presentation

TeX gives you a lot of control for creating new structural elements. Let’s
take a simple example. Suppose I want to write a file name in a document.
Normally, I want the filename to appear in typewriter font. In LaTeX, I could
type it as

<!--
\texttt{src/hello.c}
-->

<pre><code><span class="Type">\texttt</span><span class="Delimiter">{</span>src/hello.c<span class="Delimiter">}</span>
</code></pre>

but it is better to define a custom macro `\filename` and use

<pre><code><span class="Type">\filename</span><span class="Delimiter">{</span>src/hello.c<span class="Delimiter">}</span>
</code></pre>

The advantage is two-fold. Firstly, while writing the file, I am thinking in
term of content (_filename_) rather than presentation (_typewriter font_).
Secondly, in the future, if I want to change how a filename is displayed
(perhaps as a hyper-link to the file), all I need to do is change the
definition of the macro. Markdown, with its simplistic structure, lacks the
ability to define custom macros.

# Conditional compilation

TeX also makes it trivial to generate multiple versions of the document from the same source. Again, lets take an example. Suppose I am writing notes for a class. Normally, I like to include a short bullet list on my lecture slides, but include a detailed description in the lecture handout. In ConTeXt I can use [modes] as follows (In LaTeX, I could use the `comments` package):

<!--
Features of the solution
\startitemize[n] 
   \item Feature 1 

     \startmode[handout] 
       Explanation of the feature ... 
     \stopmode 

   \item Feature 2 

     \startmode[handout]
       Explanation of the feature ... 
     \stopmode
\stopitemize
-->

<pre><code>Features of the solution
<span class="Keyword">\startitemize</span><span class="Delimiter">[</span><span class="Type">n</span><span class="Delimiter">] </span>
   <span class="Statement">\item</span> Feature 1

     <span class="Keyword">\startmode</span><span class="Delimiter">[</span><span class="Type">handout</span><span class="Delimiter">] </span>
<span class="Delimiter">       </span>Explanation of the feature ...
     <span class="Keyword">\stopmode </span>

   <span class="Statement">\item</span> Feature 2

     <span class="Keyword">\startmode</span><span class="Delimiter">[</span><span class="Type">handout</span><span class="Delimiter">]</span>
<span class="Delimiter">       </span>Explanation of the feature ...
     <span class="Keyword">\stopmode</span>
<span class="Keyword">\stopitemize</span>
</code></pre>

To generate the slides version of my lecture notes, I compile them using

```
context --mode=slides --result=slides <filename>
```

This version just contains the bullet list. Since the handout mode is not set, the content between `\startmode[handout] ... \stopmode` is omitted.

To generate the handout version of my lecture notes, I compile them using

```
context --mode=handout --result=slides <filename>
```

Since the handout mode is set, the content between `\startmode[handout] ...
\stopmode` is included.

Such a conditional compilation is extremely useful to keep the slides and
handouts in sync. Again, markdown with its simplistic feature set, lacks the
ability of conditional compilation. 

## Including external documents


