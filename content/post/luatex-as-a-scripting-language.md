---
title     : "LuaTeX as a scripting language"
date  : 2021-08-16
tags  :
  - script
  - mtxrun
  - yad
  - programming
categories :
  - CLI
---

This post is not really about ConTeXt but about how I could use ConTeXt to
quickly hash out an idea which involved some text processing. 

One of my long running (for more than a decade now) ConTeXt projects is typesetting my CV. I maintain the list of publications as an XML file. I parse the
file using ConTeXt's XML helper's and convert the data to a Lua table, and
then typeset it using [ConTeXt Lua Documents][CLD]. When starting with this
project, I chose XML as a data format for two reasons. First, XML scema can be
[validated] using a Schema. Second, I thought that since XML is so popular,
there must be good tools for authoring XML documents. 

[CLD]: https://www.pragma-ade.com/general/manuals/cld-mkiv.pdf
[validated]: https://en.wikipedia.org/wiki/XML_validation

<!--more-->

The first reason has really paid off. I wrote a [Relax NG][RNG] schema for the
data layout that I had in mind, and I validate the XML files (using [jing]) as part of by build process. However, I never got down to exploring authoring tools for XML. I using vim (now [neovim]) for editing everything, which has a decent [XML plugin][xmledit]. So, I mostly updated my XML file by hand (often by simply copy-pasting an old entry and changing appropriate values). It works, but is an error prone process. 

I recently came across [YAD (yet another dialog)][YAD], which is a program to
easily generate GUI dialog boxes and forms. See [this page][examples] for long list of examples. Using `yad`, I could easily generate a GUI to enter all the information for a publication. 

{{< img src="yad.png" class="center" alt="A GUI using YAD" >}}


<pre><code><span class="Identifier">data</span>=<span class="PreProc">$(</span><span class="Special">yad </span><span class="Special">--title</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Add publication</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Special">--form</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--separator</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">|</span><span class="Operator">&quot;</span><span class="Special">  </span><span class="Special">--width</span><span class="Operator">=</span><span class="Number">500</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Title</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Author 1</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Student 1?:CHK</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Author 2</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Student 2?:CHK</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Author 3</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Student 3?:CHK</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Author 4</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Student 4?:CHK</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Author 5</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Student 5?:CHK</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Journal</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Pages</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Month</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="PreProc">$(</span><span class="Special">date +%b</span><span class="PreProc">)</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Year</span><span class="Operator">&quot;</span><span class="Special">  </span><span class="PreProc">$(</span><span class="Special">date +%Y</span><span class="PreProc">)</span><span class="Special"> \</span>
<span class="Special">           </span><span class="Special">--field</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="String">Note:TXT</span><span class="Operator">&quot;</span><span class="Special"> </span><span class="Operator">&quot;&quot;</span><span class="PreProc">)</span></code></pre>

After clicking "OK", the values of all fields are written to `STDOUT`
(delimited by `|` (set via the option `--separator`). A typical entry looks as
follows. 

<code><pre>$ echo $data
Title of the paper|A. Author|TRUE|B. Author|FALSE||FALSE||FALSE||FALSE|Fancy Journal|1--10|Aug|2021||
</pre></code>

So, to generate XML entry, all I needed to do was, split the string at `|` to
determine the value of each field and put it in an appropriate place in a
template. The only catch is that most of papers do not have five authors. So,
I need to make sure that I don't generate entries for empty authors. Such
conditional processing was too complicated for my shell programming or AWK
scripts, but is trivial in any proper programming language. The question was,
which language?

My usual go to language for such tasks is Ruby. But I normally don't do much
text processing and it has been a while since I wrote any Ruby code. So I
found myself googing about a lot of basics of the language: how to split a
string, how to use templates, and so on. 

As I was googing, I realized that I actually *do* write a lot of code for text
processing ... just that I write it as part of my TeX documents–in Lua!
So, I could easily write the processing and the formatting code in Lua using
the helper functions provided by ConTeXt (for example, for templates). These
helper functions are not available in pure Lua, but they can be accessed if
the Lua script is called via `mtxrun --script`. So, I could quickly write out
the following:

<pre><code><span class="Statement">local</span> replace = utilities.templates.replace

<span class="Statement">local</span> data = string.explode(environment.arguments.data <span class="Operator">or</span> <span class="Constant">nil</span>, <span class="String">&quot;|&quot;</span>)

<span class="Statement">local</span> variables = <span class="Structure">{</span> <span class="Structure">}</span>

variables.title = data[<span class="Number">1</span>]

<span class="Statement">local</span> author  = <span class="Structure">{}</span>
<span class="Statement">local</span> student = <span class="Structure">{}</span>
<span class="Statement">local</span> num_authors = <span class="Number">0</span>
<span class="Repeat">for</span> i=<span class="Number">1</span>,<span class="Number">5</span> <span class="Statement">do</span>
  <span class="Conditional">if</span> data[<span class="Number">2</span>*i] == <span class="String">&quot;&quot;</span> <span class="Conditional">then</span>
<span class="Statement">      break</span>
  <span class="Conditional">else</span>
      num_authors = num_authors + <span class="Number">1</span>
      author[i]  = data[<span class="Number">2</span>*i]
      student[i] = data[<span class="Number">2</span>*i+<span class="Number">1</span>]
  <span class="Conditional">end</span>
<span class="Statement">end</span>

variables.journal = data[<span class="Number">12</span>]
variables.pages   = data[<span class="Number">13</span>]
variables.month   = data[<span class="Number">14</span>]
variables.year    = data[<span class="Number">15</span>]
variables.note    = data[<span class="Number">16</span>]

<span class="Statement">local</span> template = <span class="String">[[</span>
<span class="String">    &lt;publication status=&quot;submitted&quot;&gt;</span>
<span class="String">      &lt;title&gt;</span>
<span class="String">          %title%</span>
<span class="String">      &lt;/title&gt;</span>
<span class="String">      &lt;authors&gt;</span>
<span class="String">%authors%</span>
<span class="String">      &lt;/authors&gt;</span>
<span class="String">      &lt;journal&gt;</span>
<span class="String">          %journal%</span>
<span class="String">      &lt;/journal&gt;</span>
<span class="String">      &lt;pages&gt;%pages%&lt;/pages&gt;</span>
<span class="String">      &lt;month&gt;%month%&lt;/month&gt;</span>
<span class="String">      &lt;year&gt;%year%&lt;/year&gt;</span>
<span class="String">    &lt;/publication&gt;</span>
<span class="String">]]</span>

<span class="Statement">local</span> template_author_a = <span class="String">[[</span><span class="String">        &lt;name type=&quot;student&quot;&gt;%author%&lt;/name&gt;</span><span class="String">]]</span>
<span class="Statement">local</span> template_author_b = <span class="String">[[</span><span class="String">        &lt;name&gt;%author%&lt;/name&gt;</span><span class="String">]]</span>

<span class="Statement">local</span> formatted_authors = <span class="Structure">{</span> <span class="Structure">}</span>
<span class="Repeat">for</span> i = <span class="Number">1</span>, num_authors <span class="Statement">do</span>
  <span class="Conditional">if</span> student[i] == <span class="String">&quot;TRUE&quot;</span> <span class="Conditional">then</span>
formatted_authors[i] = replace(template_author_a, <span class="Structure">{</span>author=author[i]<span class="Structure">}</span>)
  <span class="Conditional">else</span>
formatted_authors[i] = replace(template_author_b, <span class="Structure">{</span>author=author[i]<span class="Structure">}</span>)
  <span class="Conditional">end</span>
<span class="Statement">end</span>

variables.authors = <span class="Identifier">table.concat</span>(formatted_authors, <span class="String">&quot;</span><span class="SpecialChar">\n</span><span class="String">&quot;</span>)

<span class="Statement">local</span> entry = replace(template, variables)
<span class="Identifier">print</span>(entry)</code></pre>

The code in itself is not that interesting. The point that I am trying to make
is that since I already do a lot of  text processing in ConTeXt-flavored Lua,
I can simply reuse that knowledge and quickly do the required text manging to
generate the following snippet:

<pre><code>    <span class="Function">&lt;</span><span class="Function">publication</span><span class="Function"> </span><span class="Type">status</span>=<span class="String">&quot;submitted&quot;</span><span class="Function">&gt;</span>
      <span class="Function">&lt;</span><span class="Function">title</span><span class="Function">&gt;</span>
          Title of the paper
      <span class="Function">&lt;/</span><span class="Function">title</span><span class="Function">&gt;</span>
      <span class="Function">&lt;</span><span class="Function">authors</span><span class="Function">&gt;</span>
        <span class="Function">&lt;</span><span class="Function">name</span><span class="Function"> </span><span class="Type">type</span>=<span class="String">&quot;student&quot;</span><span class="Function">&gt;</span>A. Author<span class="Function">&lt;/</span><span class="Function">name</span><span class="Function">&gt;</span>
        <span class="Function">&lt;</span><span class="Function">name</span><span class="Function">&gt;</span>B. Author<span class="Function">&lt;/</span><span class="Function">name</span><span class="Function">&gt;</span>
      <span class="Function">&lt;/</span><span class="Function">authors</span><span class="Function">&gt;</span>
      <span class="Function">&lt;</span><span class="Function">journal</span><span class="Function">&gt;</span>
          Fancy Journal
      <span class="Function">&lt;/</span><span class="Function">journal</span><span class="Function">&gt;</span>
      <span class="Function">&lt;</span><span class="Function">pages</span><span class="Function">&gt;</span>1--10<span class="Function">&lt;/</span><span class="Function">pages</span><span class="Function">&gt;</span>
      <span class="Function">&lt;</span><span class="Function">month</span><span class="Function">&gt;</span>Aug<span class="Function">&lt;/</span><span class="Function">month</span><span class="Function">&gt;</span>
      <span class="Function">&lt;</span><span class="Function">year</span><span class="Function">&gt;</span>2021<span class="Function">&lt;/</span><span class="Function">year</span><span class="Function">&gt;</span>
    <span class="Function">&lt;/</span><span class="Function">publication</span><span class="Function">&gt;</span></code></pre>


For the record, the complete code was:

<pre><code><span class="Identifier">data</span>=<span class="PreProc">$(</span><span class="Special">yad ...</span><span class="PreProc">)</span>
<span class="PreProc">$MTXRUN</span> <span class="Special">--script</span> <span class="PreProc">$SCRIPT</span> <span class="Special">--data</span><span class="Operator">=</span><span class="Operator">&quot;</span><span class="PreProc">$data</span><span class="Operator">&quot;</span> \
        <span class="Operator">|</span> xclip <span class="Special">-selection</span> clipboard
</code></pre>


where `$MTXRUN` is the location of the `mtxrun` binary and `$SCRIPT` is the
location of my lua script. I pass the result to `xclip` to store it in the
clipboard, so that I can simply paste it in my editor. To complete the circle,
I defined the following function in the local `.vimrc` file my project
directory:

<pre><code><span class="Statement">command</span><span class="Operator">!</span> AddPub <span class="Operator">!</span>$HOME/bin/<span class="Function">add</span><span class="Operator">-</span>publication
</code></pre>

So, I can just run `:AddPub` in vim to call the GUI and after I fill in all
the values, the formatted entry is in the clipboard which I can paste at
appropriate location. This was a fun weekend project!




[RNG]: https://en.wikipedia.org/wiki/XML_validation
[jing]: https://relaxng.org/jclark/jing.html
[neovim]: https://neovim.io
[xmledit]: http://github.com/sukima/xmledit/
[YAD]: https://sourceforge.net/projects/yad-dialog/
[examples]: http://smokey01.com/yad/

