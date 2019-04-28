---
title     : "Designing cover page for an exam"
linktitle : "Designing exam cover page"
date  : 2019-04-15
draft : false
tags  :
- tables
- forms
- metapost
- fontawesome
- coverpage
- tutorial
categories :
- design
---

Our university has a specific style that courses need to use as a cover page
for exams, shown below. They circulate a Word template at the beginning of
each term. Since I typeset my exams in ConTeXt, I decided to translate this
cover page template to ConTeXt as well. In this post, I'll explain how I went
about doing this translation.

<!--more-->

<a
href="/context-blog/post/exam-coverpage/exam-v6.png">
<img src="/context-blog/post/exam-coverpage/exam-v6.png" class="right" alt="Exam Coverpage" width="300px" />
</a>


## The user interface

The cover page is just a fancy table with certain information filled in. At a
high-level, I want to hide all the implementation details in an environment
file (which I'll call `env-coverpage`), specify all the information using a
key-value driven interface, and then call a macro (which I'll call
`\placecoverpage`) which typesets the cover page. Thus, my main tex file looks
like this:

<!--
\environment env-coverpage
% Other environments that I load

\starttext

\placecoverpage
  [
    course={ECSE 101: Course title}, 
    term=Winter 2019, 
    exam=Final, 
    time={15 April 2019 (9:00 am)},
    %
    book=closed, % open, closed
    print=doublesided, % singlesided, doublesided
    type=exam, %multiple, booklet, exam
    keepexam=no, % yes no
    cribsheet=no, % yes no
    dictionary=translation,
    calculator=yes, % yes no
    extra={Any extra instructions that need to go with the exam such as if
           there is a formula sheet in the end.},
  ]


% Rest of the details of the exam

\stoptext
-->

<pre><code><span class="Statement">\environment</span> env-coverpage
<span class="Comment">% Other environments that I load</span>

<span class="Statement">\starttext</span>

<span class="Statement">\placecoverpage</span>
  <span class="Delimiter">[</span>
    course=<span class="Delimiter">{</span>ECSE 101: Course title<span class="Delimiter">}</span>,
    term=Winter 2019,
    exam=Final,
    time=<span class="Delimiter">{</span>15 April 2019 (9:00 am)<span class="Delimiter">}</span>,
    <span class="Comment">%</span>
    book=closed, <span class="Comment">% open, closed</span>
    print=doublesided, <span class="Comment">% singlesided, doublesided</span>
    type=exam, <span class="Comment">%multiple, booklet, exam</span>
    keepexam=no, <span class="Comment">% yes no</span>
    cribsheet=no, <span class="Comment">% yes no</span>
    dictionary=translation,
    calculator=yes, <span class="Comment">% yes no</span>
    extra=<span class="Delimiter">{</span>Any extra instructions that need to go with the exam such as if
           there is a formula sheet in the end.<span class="Delimiter">}</span>,
  <span class="Delimiter">]</span>

<span class="Comment">% Rest of the details of the exam</span>

<span class="Statement">\stoptext</span>
</code></pre>

Now, I'll explain how I design the `\placecoverpage` macro. 
Because this is a one-off macro, I use the simplest mechanism to store the
key-value options: `\setvariables`. Thus, the basic skeleton of the
`\placecoverpage` macro is as follows:

<!--
\startenvironment env-coverpage
\define\placecoverpage
    {\dosingleargument\doplacecoverpage}

\def\doplacecoverpage[#1]%
    {\setvariables[exam][#1]%
    \setups{exam:coverpage}}

\def\dodoplacecoverpage{}
\stopenvironment
-->

<pre><code><span class="Identifier">\startenvironment </span>env-coverpage
<span class="Identifier">\define\placecoverpage</span>
<span class="Identifier">    </span><span class="Delimiter">{</span><span class="Identifier">\dosingleargument\doplacecoverpage</span><span class="Delimiter">}</span>

<span class="Identifier">\def\doplacecoverpage</span><span class="Delimiter">[</span><span class="Type">#1</span><span class="Delimiter">]</span><span class="Comment">%</span>
    <span class="Delimiter">{</span><span class="Identifier">\setvariables</span><span class="Delimiter">[</span><span class="Type">exam</span><span class="Delimiter">][</span><span class="Type">#1</span><span class="Delimiter">]</span><span class="Comment">%</span>
     <span class="Identifier">\setups</span><span class="Delimiter">{</span>exam:coverpage<span class="Delimiter">}}</span>
<span class="Identifier">\stopenvironment</span>
</code></pre>

Now all we need is to write the setup `exam:coverpage` to typeset the actual
cover page. I divide that into smaller components, again using the setups
mechanism.

<!--
\startsetups exam:coverpage
  \setups{exam:banner}
  \blank[2*big]
  \setups{exam:courseinfo}
  \blank[2*big]
  \setups{exam:studentinfo}
  \blank[6*line]
  \setups{exam:instructions}
\stopsetups
-->

<pre><code><span class="Identifier">\startsetups </span>exam:coverpage
  <span class="Identifier">\setups</span><span class="Delimiter">{</span>exam:banner<span class="Delimiter">}</span>
  <span class="Identifier">\blank</span><span class="Delimiter">[</span><span class="Type">2*big</span><span class="Delimiter">]</span>
<span class="Delimiter">  </span><span class="Identifier">\setups</span><span class="Delimiter">{</span>exam:courseinfo<span class="Delimiter">}</span>
  <span class="Identifier">\blank</span><span class="Delimiter">[</span><span class="Type">2*big</span><span class="Delimiter">]</span>
<span class="Delimiter">  </span><span class="Identifier">\setups</span><span class="Delimiter">{</span>exam:studentinfo<span class="Delimiter">}</span>
  <span class="Identifier">\blank</span><span class="Delimiter">[</span><span class="Type">6*line</span><span class="Delimiter">]</span>
<span class="Delimiter">  </span><span class="Identifier">\setups</span><span class="Delimiter">{</span>exam:instructions<span class="Delimiter">}</span>
<span class="Identifier">\stopsetups</span>
</code></pre>

## Drawing the banner

{{< img src="exam-v1.png" class="right" alt="Exam Banner (barebones)" >}}

I start by using a simple framedtext to typeset the banner. 

<pre><code><span class="Identifier">\defineframedtext</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">bannertext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    width=broad,</span>
<span class="Type">    height=4\lineheight,</span>
<span class="Type">    align=</span><span class="Delimiter">{</span>flushright,lohi<span class="Delimiter">}</span><span class="Type">,</span>
<span class="Type">    foregroundstyle=\bfa,</span>
<span class="Type">    frame=on,</span>
<span class="Type">  </span><span class="Delimiter">]</span>

<span class="Identifier">\startsetups </span>exam:banner
  <span class="Identifier">\startbannertext</span>
<span class="Identifier">    \getvariable</span><span class="Delimiter">{</span>exam<span class="Delimiter">}{</span>term<span class="Delimiter">}</span>
    <span class="Identifier">\\</span>
<span class="Identifier">    \getvariable</span><span class="Delimiter">{</span>exam<span class="Delimiter">}{</span>exam<span class="Delimiter">}</span> Examination
  <span class="Identifier">\stopbannertext</span>
<span class="Identifier">\stopsetups</span>
</code></pre>

Note that we stored the key-values using `\setvariables{exam}{...}`. Now, we
use `\getvariable{exam}{key}` to access the value of a particular key.

Now, I change the simple border of the frame to the two-lined frame in the
template. To do so, I set `frame=off` and use a metapost graphic as
background.

<pre><code><span class="Identifier">\defineframedtext</span>
<span class="Identifier">  </span><span class="Delimiter">[</span><span class="Type">bannertext</span><span class="Delimiter">]</span>
<span class="Delimiter">  [</span>
<span class="Type">    ...,</span>
<span class="Type">    frame=off,</span>
<span class="Type">    background=bannerlines,</span>
<span class="Type">  </span><span class="Delimiter">]</span>

<span class="Identifier">\defineoverlay</span><span class="Delimiter">[</span><span class="Type">bannerlines</span><span class="Delimiter">][</span><span class="Type">\useMPgraphic</span><span class="Delimiter">{</span>bannerlines<span class="Delimiter">}]</span>
</code></pre>

{{< img src="exam-v2.png" class="right" alt="Exam Banner (barebones)" >}}

where

<pre><code><span class="Identifier">\startuseMPgraphic</span>{bannerlines}
  <span class="Statement">begingroup</span>
  <span class="Identifier">linecap</span> := <span class="Identifier">butt</span> ;
  <span class="Function">pickup</span> <span class="Statement">pencircle</span> <span class="Statement">scaled</span> <span class="Number">2bp</span> ;
  <span class="Function">draw</span> topboundary OverlayBox    <span class="Statement">shifted</span> (<span class="Number">0</span>,<span class="Number">-1.5bp</span>);
  <span class="Function">draw</span> bottomboundary OverlayBox <span class="Statement">shifted</span> (<span class="Number">0</span>,<span class="Number">-1.5bp</span>);

  <span class="Function">pickup</span> <span class="Statement">pencircle</span> <span class="Statement">scaled</span> <span class="Number">1bp</span> ;
  <span class="Function">draw</span> topboundary OverlayBox    <span class="Statement">shifted</span> (<span class="Number">0</span>,<span class="Number">0.7bp</span>);
  <span class="Function">draw</span> bottomboundary OverlayBox <span class="Statement">shifted</span> (<span class="Number">0</span>,<span class="Number">0.7bp</span>);

  <span class="Statement">setbounds</span> <span class="Identifier">currentpicture</span> <span class="Statement">to</span> boundingbox OverlayBox ;
  <span class="Statement">endgroup</span>;
<span class="Identifier">\stopuseMPgraphic</span>
</code></pre>

Now, I all need is to add the university logo. There are different ways to add
the logo, but I chose the simplest option in this case. Just place the logo at
the appropriate place using Metapost.

<pre><code><span class="Identifier">\startuseMPgraphic</span>{bannerlines}
  <span class="Statement">begingroup</span>
  ...
  <span class="Function">label</span>.<span class="Function">rt</span>(<span class="String">&quot;\externalfigure[mcgill-logo-bw.png][height=2\lineheight]&quot;</span>,
           <span class="Number">0.5</span>[<span class="Statement">llcorner</span> OverlayBox, <span class="Statement">ulcorner</span> OverlayBox]);
  ...
  <span class="Statement">endgroup</span>;
<span class="Identifier">\stopuseMPgraphic</span>
</code></pre>

This completes the banner of the coverpage.

{{< img src="exam-v3.png" class="center" alt="Exam Banner (barebones)" >}}

## Adding the course information

This is perhaps the simplest part. I simply mid-align the course title and
time.

<pre><code><span class="Identifier">\startsetups </span>exam:courseinfo
  <span class="Identifier">\startalignment</span><span class="Delimiter">[</span><span class="Type">middle</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Type">\bfa</span><span class="Identifier">\setupinterlinespace</span>
<span class="Identifier">    \getvariable</span><span class="Delimiter">{</span>exam<span class="Delimiter">}{</span>course<span class="Delimiter">}</span>
    <span class="Identifier">\blank</span><span class="Delimiter">[</span><span class="Type">medium</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Identifier">\getvariable</span><span class="Delimiter">{</span>exam<span class="Delimiter">}{</span>time<span class="Delimiter">}</span>
  <span class="Identifier">\stopalignment</span>
<span class="Identifier">\stopsetups</span>
</code></pre>

{{< img src="exam-v4.png" class="center" alt="Exam Banner (barebones)" >}}

## Adding student information

At first I was thinking of using Metapost to draw the boxes for the student
information but then simply used a table for no other reason than laziness.

<pre><code><span class="Identifier">\startsetups </span>exam:studentinfo
  <span class="Identifier">\startTABLE</span>
<span class="Identifier">  \setupTABLE</span><span class="Delimiter">[</span><span class="Type">c</span><span class="Delimiter">][</span><span class="Type">1,3</span><span class="Delimiter">][</span><span class="Type">background=color,backgroundcolor=lightgray,</span>
<span class="Type">                      style=bold,</span>
<span class="Type">                      loffset=0.5em,roffset=1em,</span>
<span class="Type">                      toffset=0.25ex,boffset=0.25ex</span><span class="Delimiter">]</span>
<span class="Delimiter">  </span><span class="Identifier">\setupTABLE</span><span class="Delimiter">[</span><span class="Type">c</span><span class="Delimiter">][</span><span class="Type">2</span><span class="Delimiter">][</span><span class="Type">width=broad</span><span class="Delimiter">]</span>
<span class="Delimiter">  </span><span class="Identifier">\setupTABLE</span><span class="Delimiter">[</span><span class="Type">c</span><span class="Delimiter">][</span><span class="Type">4,5,6,7,8,9,10,11,12</span><span class="Delimiter">][</span><span class="Type">width=1.5em</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Special">\NC</span> Student Name: <span class="Special">\NC</span>
    <span class="Special">\NC</span> McGill Id:    <span class="Special">\NC</span>
    <span class="Special">\NC</span>
    <span class="Special">\NC</span>
    <span class="Special">\NC</span>
    <span class="Special">\NC</span>
    <span class="Special">\NC</span>
    <span class="Special">\NC</span>
    <span class="Special">\NC</span>
    <span class="Special">\NC</span>
    <span class="Special">\NC</span>   <span class="Special">\NR</span>
  <span class="Identifier">\stopTABLE</span>
<span class="Identifier">\stopsetups</span>
</code></pre>

{{< img src="exam-v5.png" class="center" alt="Exam Banner (barebones)" >}}

## Adding exam instructions

OK, so all the simple parts of the cover page are done. Now, let's look at the
fancy table for instructions. The instruction use multiple check boxes. I use
[FontAwesome] to show these check boxes. 

<pre><code><span class="Identifier">\usesymbols</span><span class="Delimiter">[</span><span class="Type">fontawesome</span><span class="Delimiter">]</span>
<span class="Identifier">\def\FONTAWESOME</span><span class="Delimiter">[</span><span class="Type">#1</span><span class="Delimiter">]{</span><span class="Identifier">\inlinedbox</span>
<span class="Identifier">      </span><span class="Delimiter">{</span><span class="Identifier">\scale</span><span class="Delimiter">[</span><span class="Type">height=1em</span><span class="Delimiter">]{</span><span class="Identifier">\symbol</span><span class="Delimiter">[</span><span class="Type">fontawesome</span><span class="Delimiter">][</span><span class="Type">#1</span><span class="Delimiter">]}}}</span>

<span class="Identifier">\define\YES</span><span class="Delimiter">{</span><span class="Identifier">\FONTAWESOME</span><span class="Delimiter">[</span><span class="Type">check</span><span class="Delimiter">]}</span>
<span class="Identifier">\define\NO </span><span class="Delimiter">{</span><span class="Identifier">\FONTAWESOME</span><span class="Delimiter">[</span><span class="Type">check_empty</span><span class="Delimiter">]}</span>
</code></pre>

See my earlier post on [using fontawesome] to see why I use `\inlinedbox`.

Next, I define a helper macro to show a empty or ticked check box depending on
the option:

<pre><code><span class="Identifier">\define</span><span class="Delimiter">[</span><span class="Type">2</span><span class="Delimiter">]</span><span class="Identifier">\CHECKBOX</span>
<span class="Identifier">    </span><span class="Delimiter">{</span><span class="Identifier">\doifelse</span><span class="Delimiter">{</span><span class="Identifier">\getvariable</span><span class="Delimiter">{</span>exam<span class="Delimiter">}{</span>#1<span class="Delimiter">}}{</span>#2<span class="Delimiter">}{</span><span class="Identifier">\YES</span><span class="Delimiter">}{</span><span class="Identifier">\NO</span><span class="Delimiter">}}</span>
</code></pre>

Finally, I use a four column table (with carefully chosen spanned cells) to
show all exam instructions.

<pre><code><span class="Identifier">\startsetups </span>exam:instructions
  <span class="Identifier">\midaligned</span><span class="Delimiter">{</span><span class="Type">\bfa</span> INSTRUCTIONS:<span class="Delimiter">}</span>
  <span class="Identifier">\blank</span><span class="Delimiter">[</span><span class="Type">halfline</span><span class="Delimiter">]</span>
<span class="Delimiter">  </span><span class="Identifier">\bTABLE</span><span class="Delimiter">[</span><span class="Type">width=broad</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Identifier">\setupTABLE</span><span class="Delimiter">[</span><span class="Type">each</span><span class="Delimiter">][</span><span class="Type">each</span><span class="Delimiter">][</span><span class="Type">offset=0.5em</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Identifier">\setupTABLE</span><span class="Delimiter">[</span><span class="Type">column</span><span class="Delimiter">][</span><span class="Type">1</span><span class="Delimiter">]</span>
<span class="Delimiter">               [</span>
<span class="Type">                 style=bold, </span>
<span class="Type">                 align=</span><span class="Delimiter">{</span>middle,lohi<span class="Delimiter">}</span><span class="Type">,</span>
<span class="Type">                 background=color,</span>
<span class="Type">                 backgroundcolor=lightgray,</span>
<span class="Type">                 width=0.2\textwidth,</span>
<span class="Type">               </span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Identifier">\setupTABLE</span><span class="Delimiter">[</span><span class="Type">column</span><span class="Delimiter">][</span><span class="Type">2,4</span><span class="Delimiter">][</span><span class="Type">width=0.3\textwidth</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Identifier">\setupTABLE</span><span class="Delimiter">[</span><span class="Type">column</span><span class="Delimiter">][</span><span class="Type">2,3,4</span><span class="Delimiter">][</span><span class="Type">frame=off,topframe=on,bottomframe=on</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Identifier">\setupTABLE</span><span class="Delimiter">[</span><span class="Type">column</span><span class="Delimiter">][</span><span class="Type">2</span><span class="Delimiter">][</span><span class="Type">leftframe=on</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Identifier">\setupTABLE</span><span class="Delimiter">[</span><span class="Type">column</span><span class="Delimiter">][</span><span class="Type">4</span><span class="Delimiter">][</span><span class="Type">rightframe=on</span><span class="Delimiter">]</span>
<span class="Delimiter">    </span><span class="Identifier">\bTR</span>
<span class="Identifier">      \bTD</span><span class="Delimiter">[</span><span class="Type">ny=6</span><span class="Delimiter">] </span>EXAM: <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>CLOSED BOOK <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>book<span class="Delimiter">}{</span>closed<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>OPEN BOOK   <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>book<span class="Delimiter">}{</span>open<span class="Delimiter">}</span>   <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD             \eTD</span>
<span class="Identifier">    \eTR</span>
<span class="Identifier">   \bTR </span>
<span class="Identifier">     \bTD </span>SINGLE SIDED <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>print<span class="Delimiter">}{</span>singlesided<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">     \bTD</span><span class="Delimiter">[</span><span class="Type">nx=2,rightframe=on</span><span class="Delimiter">] </span>
<span class="Delimiter">        </span>PRINTED ON BOTH SIDES OF THE PAGE <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>print<span class="Delimiter">}{</span>doublesided<span class="Delimiter">}</span>
     <span class="Identifier">\eTD</span>
<span class="Identifier">   \eTR</span>
<span class="Identifier">   \bTR</span><span class="Delimiter">[</span><span class="Type">topframe=off,bottomframe=off</span><span class="Delimiter">]</span>
<span class="Delimiter">     </span><span class="Identifier">\bTD</span><span class="Delimiter">[</span><span class="Type">nx=2</span><span class="Delimiter">] </span>MULTIPLE CHOICE ANSWER SHEETS <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>type<span class="Delimiter">}{</span>multiple<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">   \eTR</span>
<span class="Identifier">   \bTR</span><span class="Delimiter">[</span><span class="Type">topframe=off,bottomframe=off</span><span class="Delimiter">]</span>
<span class="Delimiter">     </span><span class="Identifier">\bTD </span>ANSWER IN BOOKLET <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>type<span class="Delimiter">}{</span>booklet<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">     \bTD</span><span class="Delimiter">[</span><span class="Type">nx=2, rightframe=on</span><span class="Delimiter">] </span>EXTRA BOOKLETS PERMITTED: YES <span class="Identifier">\eTD</span>
<span class="Identifier">   \eTR</span>
<span class="Identifier">   \bTR</span><span class="Delimiter">[</span><span class="Type">topframe=off</span><span class="Delimiter">]</span>
<span class="Delimiter">     </span><span class="Identifier">\bTD </span>ANSWER ON EXAM <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>type<span class="Delimiter">}{</span>exam<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">     \bTD \eTD </span>
<span class="Identifier">     \bTD \eTD</span>
<span class="Identifier">   \eTR</span>
<span class="Identifier">    \bTR</span>
<span class="Identifier">      \bTD </span>SHOULD THE EXAM BE: <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>RETURNED <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>keepexam<span class="Delimiter">}{</span>no<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>KEPT BY STUDENT <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>keepexam<span class="Delimiter">}{</span>yes<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">    \eTR</span>
<span class="Identifier">    </span><span class="Comment">% </span><span class="Todo">FIXME</span><span class="Comment">: Add instructions for crib sheets</span>
    <span class="Identifier">\bTR</span>
<span class="Identifier">      \bTD </span>CRIB SHEETS: <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>NOT PERMITTED <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>cribsheet<span class="Delimiter">}{</span>no<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>PERMITTED    <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>cribsheet<span class="Delimiter">}{</span>yes<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">    \eTR</span>
<span class="Identifier">    \bTR</span>
<span class="Identifier">      \bTD </span>DICTIONARIES: <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>TRANSLATION ONLY <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>dictionary<span class="Delimiter">}{</span>translation<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>REGULAR <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>dictionary<span class="Delimiter">}{</span>regular<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>NONE    <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>dictionary<span class="Delimiter">}{</span>no<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">    \bTR</span>
<span class="Identifier">      \bTD </span>CALCULATORS: <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD </span>NOT PERMITTED <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>calculator<span class="Delimiter">}{</span>no<span class="Delimiter">}</span> <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD</span><span class="Delimiter">[</span><span class="Type">nx=2,rightframe=on</span><span class="Delimiter">]</span>
<span class="Delimiter">        </span>PERMITTED (non-programmable) <span class="Identifier">\CHECKBOX</span><span class="Delimiter">{</span>calculator<span class="Delimiter">}{</span>yes<span class="Delimiter">}</span>
      <span class="Identifier">\eTD</span>
<span class="Identifier">    \eTR</span>
<span class="Identifier">    \bTR</span>
<span class="Identifier">      \bTD </span>ANY SPECIAL <span class="Identifier">\\ </span>INSTRUCTIONS <span class="Identifier">\eTD</span>
<span class="Identifier">      \bTD</span><span class="Delimiter">[</span><span class="Type">nx=3,rightframe=on</span><span class="Delimiter">]</span>
<span class="Delimiter">          </span><span class="Identifier">\getvariable</span><span class="Delimiter">{</span>exam<span class="Delimiter">}{</span>extra<span class="Delimiter">}</span>
      <span class="Identifier">\eTD</span>
<span class="Identifier">    \eTR</span>
<span class="Identifier">  \eTABLE</span>
<span class="Identifier">\stopsetups</span>
</code></pre>

{{< img src="exam-v6.png" class="center" alt="Exam Banner (barebones)" >}}

That's it. We can easily get a fancy looking cover page! The complete files are
below:

* [env-coverpage.tex](env-coverpage.tex)
* [exam.tex](exam.tex)

The `env-converpage.tex` file also contains the layout and font setups.

[FontAwesome]: https://fontawesome.com
[using fontawesome]: ../using-fontawesome
