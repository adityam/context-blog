---
categories:
  - markdown
date: 2012-06-01
tags:
  - gpp
  - pandoc
title: "Preprocessing Markdown with GPP: Or how I stopped worrying and started using Markdown like TeX"
linktitle: "Preprocessing Markdown with GPP"

---

These days I type most of simple documents (short articles, blog entries,
course notes) in markdown. Markdown provides only the basic structured
elements (sections, emphasis, urls, lists, footnotes, syntax highlighting,
simple tables and figures) which makes it easy to transform the input into
multiple output formats. Most of the time, I still want PDF output and for
that, I use [pandoc] to convert markdown to [ConTeXt]. At the same time, I
have the peace of mind that if I need HTML or DOC output, I’ll be able to get
that easily.

<!--more-->

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

TeX makes it easy to include external documents. This is really important when
you want to include source code in your documents. I teach an introductory
programming class, and want to make sure that the example code included in my
notes is correct. I write the code in a separate file, write the corresponding
test files to ensure that the code works correctly, and then include it in my
notes using

<!--
\typeJAVAfile[src/FactoryExample.java]
-->

<pre><code><span class="Statement">\typeJAVAfile</span><span class="Delimiter">[</span>src/FactoryExample.java<span class="Delimiter">]</span>
</code></pre>

which gives me syntax highlighted source code. Pandoc does generate syntax highlighted source code, but does not provide any means to include external source code. So, I have to copy paste the code from the actual source file to the markdown document, but that is an error-prone process.

# Enter GPP

If I only cared about PDF output (via LaTeX/ConTeXt backend), I could simply
use the same TeX macros in the markdown document. Pandoc passes the TeX macros
unchanged to the LaTeX/ConTeXt backend, so I would get a TeX document with all
the bells and whistles. But, if I tried to generate HTML or DOC output, these
TeX macros will be omitted, and I’d get a broken document. One of my reasons
to switching to Markdown was the peace of mind that I can generate HTML or DOC
output if needed. Using TeX macros in the source takes away that advantage.

[gpp]: http://files.nothingisreal.com/software/gpp/gpp.html

So, I started looking for possible solutions and found **[GPP]**—the generic
pre-processor. It is similar to the C-preprocessor: it allows to define a
macro (similar to `#define` in the C-preprocessor) and it allows to `#include`
an external file. For example, consider the following file:

```
#define filename `#1`

filename(src/hello.c)
```

Compiling this through `gpp` gives

```
`src/hello.c`
```

This was perfect! I can define GPP macros and use them in the markdown
document. Then simply preprocess the markdown file with GPP and then pass the
parsed output to pandoc. 

However, I find the default, C-like, style of defining macros to be very
fragile. For example, in the above example, I need to run through hoops if I
wanted to use the string `filename` in my markdown file. Luckily, GPP makes it
easy to change the way user macros are defined. One can use TeX-like syntax
(enabled using `gpp -T`):


```
\define{filename}{`#1`}
\filename{src/hello.c}
```

or HTML like syntax (enabled using `gpp -H`):

```
<#define filename|`#1`>
<#filename src/hello.c>
```

I ended up using a slightly modified version of HTML like syntax which is
enabled using

```
gpp  -U "<##" ">" "\\B" "|" ">" "<" ">" "#" "" 
```

This is almost like the HTML syntax, except macros are defined and used using
`<##define ...>`. The other subtle difference is that in the HTML syntax `\`
is used as a quote character (which is useful for multi-line definitions).
However, that means that if I use a TeX command in markdown (say
`\filename{src/hello.c}`) then the leading backslash is stripped. With this
modified syntax, I can define and use macros as follows:

```
<##define filename | `#1`>
<##filename src/hello.c>
```

Now, I'll show how to use GPP to get the three features that I miss from TeX.

## Separation of content and presentation

With GPP, I can define new macros that denote structural elements, e.g.,

```
<##define filename | `#1`>
The source is included in <##filename src/hello.c>.
```

When I compile this document using GPP (and the `-U` options specified
above), I get

```
The source is included in `filename src/hello.c`
```

Sure, this requires more typing that simply using `` `...` ``, but that is
the price that one has to pay for getting more structure. More importantly, I
can define the `#filename` macro based on the output format:

~~~
<##define filename|`#1`>
<##ifdef HTML>
     <##define filename|<code class="filename">#1</code>> 
<##endif>
<##ifdef TEX> 
     <##define filename|\filename{#1}> 
<##endif> 
The source is included in <##filename src/hello.c>
~~~

Now, if I compile the document using (note the `-DHTML=1` at the end)

```
gpp  -U "<##" ">" "\\B" "|" ">" "<" ">" "#" "" -DHTML=1
```

I get

```
The source is included in <code class="filename">src/hello.c</code>.
```

and if I change the `-DHTML=1` to `-DTEX=1`, I get

```
The source is included in \filename{src/hello.c}
```

This ensures that the document structure is passed to the output as well.

To make it easy to manage macros, create three files: `macros.gpp` containing
all macros, `html.gpp` overwriting some of the macros with HTML equivalents,
and `tex.gpp` overwriting some of the macros with TeX equivalents. End
`macros.gpp` file with

```
....
<##ifdef HTML> 
    <##include html.gpp> 
<##endif> 
<##ifdef TEX> 
     <##include tex.gpp> 
<##endif>
```

and then preprocess the document using gpp `-DTEX=1 --include macors.gpp
<filename>` (or `-DHTML=1` for HTML output).


## Conditional compilation

Actually, the previous example already shows how to get conditional
compilation: use the `-D` command line switch and check the variable
definition using #ifdef. Thus, the above example translates to:


```
Feature of the solution

1. Feature 1 

   <##ifdef HANDOUT> 
   Explanation of the feature ... 
   <##endif> 

2. Feature 2 

    <##ifdef HANDOUT> 
    Explanation of the feature ... 
    <##endif>
```

When I compile without `-DHANDOUT=1`, I get the slides version; when I
compile with `-DHANDOUT=1`, I get the handout version.

## Including extenal documents

External documents can be included using the `#include` directive. So, I can
include an external file using

```
~~~{.java}
<##include src/Factory.java
~~~
```

# Putting it all together

All that is needed is to run the gpp preprocessor and then pass the output to
pandoc.

```
gpp -U "<##" ">" "\\B" "|" ">" "<" ">" "#" "" <options> <filename> \
  | pandoc -f markdown -t <format> -o <outfile>
```

Hide this in a wrapper script or a shell function or a Makefile, and you have a markdown processor with the important features of TeX!
