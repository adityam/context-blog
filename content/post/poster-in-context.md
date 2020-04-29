---
title     : "Making visaully attractive posters in ConTeXt"
linktitle : "Posters in ConTeXt"
date  : 2018-08-25
tags  :
  - poster
  - metapost
  - backgrounds
categories :
  - design

---

Posters are not or rather were not too common in my research field, so I have
never really had a need to create posters. But this is now changing and every
now and then, we have to make a poster presentation. I have looked at the
different options available for creating posters (see, for example, this
[TeX.SE](https://tex.stackexchange.com/q/341/323) post) but I find all of them
to be boring. Given that poster sessions are crammed, it is important to
create a poster that is visually distinct. So, when it came time to create a
poster for a paper that we will be presenting at [NecSys
2018](https://fwn06.housing.rug.nl/necsys2018/) next week, we started looking
at something visually distinct. Inspired by a [template] that my co-author,
Mohammad, found, we created the poster shown below.

[template]: http://monanews.info/best-poster-presentation-template/

<a
href="http://www.cim.mcgill.ca/~adityam/projects/info-structures/posters/2018-necsys.pdf">
{{< img src="/context-blog/post/poster-in-context/poster.png" class="right" alt="Poster" >}}
</a>


I rather like the design. It has nice balance and harmony. I didn't like the
colors used in the template, so we replaced them by colors from the [solarized
palette][solarized]. When printed on A0 sized fabric, this looks gorgeous. 

The poster was created using ConTeXt. We were against a deadline and trying to
fine-tune the visual layout. So, the actual  `.tex` file has a lot of
spaghetti code. So, I'll not share the code for now, but explain our thought
process while creating this. 

1. We start with the layout and set 1in margins on all sizes (on A0 paper,
   these margins are tiny). 

    <pre><code><span class="Identifier">\setuppapersize</span><span class="Delimiter">[</span><span class="Type">A0</span><span class="Delimiter">]</span>
    <span class="Identifier">\setuplayout</span>
    <span class="Identifier">    </span><span class="Delimiter">[</span>
    <span class="Type">      cutspace=1in,</span>
    <span class="Type">      leftmargin=1in,</span>
    <span class="Type">      leftmargindistance=0mm,</span>
    <span class="Type">      width=middle,</span>
    <span class="Type">      rightmargindistance=0mm,</span>
    <span class="Type">      rightmargin=1in,</span>
    <span class="Type">      backspace=1in,</span>
    <span class="Type">      </span><span class="Comment">%</span>
    <span class="Type">      topspace=1in,</span>
    <span class="Type">      header=0mm,</span>
    <span class="Type">      headerdistance=0mm,</span>
    <span class="Type">      height=middle,</span>
    <span class="Type">      footerdistance=0mm,</span>
    <span class="Type">      footer=0mm,</span>
    <span class="Type">      bottomspace=1in,</span>
    <span class="Type">      columns=6,</span>
    <span class="Type">      columndistance=0.5em,</span>
    <span class="Type">    </span><span class="Delimiter">]</span>

    <span class="Identifier">\setuppagenumbering</span><span class="Delimiter">[</span><span class="Type">location=</span><span class="Delimiter">]</span>
    </code></pre>

2. Next, we set the fonts. I typically use [Diavlo] plus [Euler] for my
   presentations, so we stick with the same combination here. 

    <pre><code><span class="Identifier">\usetypescriptfile</span><span class="Delimiter">[</span><span class="Type">diavlo, delicious, euler, dejavu</span><span class="Delimiter">]</span>

    <span class="Identifier">\definetypeface</span><span class="Delimiter">[</span><span class="Type">posterfont</span><span class="Delimiter">][</span><span class="Type">rm</span><span class="Delimiter">][</span><span class="Type">serif</span><span class="Delimiter">][</span><span class="Type">diavlo</span><span class="Delimiter">][</span><span class="Type">default</span><span class="Delimiter">]</span>
    <span class="Identifier">\definetypeface</span><span class="Delimiter">[</span><span class="Type">posterfont</span><span class="Delimiter">][</span><span class="Type">ss</span><span class="Delimiter">][</span><span class="Type">sans</span><span class="Delimiter">] [</span><span class="Type">delicious</span><span class="Delimiter">][</span><span class="Type">default</span><span class="Delimiter">]</span>
    <span class="Identifier">\definetypeface</span><span class="Delimiter">[</span><span class="Type">posterfont</span><span class="Delimiter">][</span><span class="Type">mm</span><span class="Delimiter">][</span><span class="Type">math</span><span class="Delimiter">] [</span><span class="Type">pagellaovereuler</span><span class="Delimiter">][</span><span class="Type">default</span><span class="Delimiter">]</span>
    <span class="Identifier">\definetypeface</span><span class="Delimiter">[</span><span class="Type">posterfont</span><span class="Delimiter">][</span><span class="Type">tt</span><span class="Delimiter">][</span><span class="Type">mono</span><span class="Delimiter">] [</span><span class="Type">dejavu</span><span class="Delimiter">][</span><span class="Type">default</span><span class="Delimiter">] [</span><span class="Type">rscale=0.85, features=none</span><span class="Delimiter">]</span>


    <span class="Identifier">\definebodyfontenvironment</span><span class="Delimiter">[</span><span class="Type">24pt</span><span class="Delimiter">]</span>
    <span class="Identifier">\definebodyfontenvironment</span><span class="Delimiter">[</span><span class="Type">32pt</span><span class="Delimiter">]</span>
    <span class="Identifier">\definebodyfontenvironment</span><span class="Delimiter">[</span><span class="Type">44pt</span><span class="Delimiter">]</span>
    <span class="Identifier">\definebodyfontenvironment</span><span class="Delimiter">[</span><span class="Type">72pt</span><span class="Delimiter">]</span>

    <span class="Identifier">\setupbodyfont</span><span class="Delimiter">[</span><span class="Type">posterfont,32pt</span><span class="Delimiter">]</span>
    <span class="Identifier">\setupmathematics</span><span class="Delimiter">[</span><span class="Type">default=normal, lcgreek=normal, ucgreek=normal</span><span class="Delimiter">]</span>
    </code></pre>


[solarized]: https://ethanschoonover.com/solarized/

3. Next, we create a background layer called `page:highlight` for drawing the different shapes. We also define a layer called `text`, which we will use to write all the text.

    <pre><code><span class="Identifier">\setupbackgrounds</span><span class="Delimiter">[</span><span class="Type">page</span><span class="Delimiter">][</span><span class="Type">background=color, backgroundcolor=background:dark</span><span class="Delimiter">]</span>

    <span class="Identifier">\defineoverlay</span>   <span class="Delimiter">[</span><span class="Type">page:highlight</span><span class="Delimiter">][</span><span class="Type">\useMPgraphic</span><span class="Delimiter">{</span>page:highlight<span class="Delimiter">}]</span>
    <span class="Identifier">\definelayer</span>     <span class="Delimiter">[</span><span class="Type">text</span><span class="Delimiter">]</span>
    <span class="Identifier">\setupbackgrounds</span><span class="Delimiter">[</span><span class="Type">text</span><span class="Delimiter">][</span><span class="Type">background=</span><span class="Delimiter">{</span>page:highlight,text,foreground<span class="Delimiter">}]</span>

    <span class="Identifier">\startuseMPgraphic</span>{page:highlight}
      StartPage;
      ...
      StopPage;
    <span class="Identifier">\stopuseMPgraphic</span>
    </code></pre>

    This gives us the poster outline shown below. Note that I am using the
    trick of randomly perturbing the outline of each cell and drawing it
    multiple times to get the effect of hand drawn lines.

    {{< img src="poster-v1.png" class="center" alt="Poster outline" >}}

4. Now, we use the layers mechanism to place all the context (on top of the
   background). We start with the poster title and logo:

    <pre><code><span class="Identifier">\setlayerframed</span><span class="Delimiter">[</span><span class="Type">text</span><span class="Delimiter">]</span>
    <span class="Delimiter">         [</span><span class="Type">line=0, column=1</span><span class="Delimiter">]</span>
    <span class="Delimiter">         [</span>
    <span class="Type">           width=\textwidth,</span>
    <span class="Type">           background=color,</span>
    <span class="Type">           backgroundcolor=background:light,</span>
    <span class="Type">           align=middle,</span>
    <span class="Type">           framecolor=contrastcolor,</span>
    <span class="Type">           rulethickness=0.2in,</span>
    <span class="Type">           frame=on,</span>
    <span class="Type">           foregroundstyle=</span><span class="Delimiter">{</span><span class="Statement">\switchtobodyfont</span>[72pt]<span class="Delimiter">}</span><span class="Type">,</span>
    <span class="Type">           toffset=0.1\lineheight,</span>
    <span class="Type">           boffset=1.4\lineheight,</span>
    <span class="Type">         </span><span class="Delimiter">]</span>
    <span class="Delimiter">         {</span>...<span class="Delimiter">}</span>

    <span class="Identifier">\setlayer</span><span class="Delimiter">[</span><span class="Type">text</span><span class="Delimiter">]</span>
    <span class="Delimiter">         [</span><span class="Type">line=1, column=6,x=0.125\layoutcolumnwidth</span><span class="Delimiter">]</span>
    <span class="Delimiter">         {</span>...<span class="Delimiter">}</span>
    </code></pre>

    This gives the following.

    {{< img src="poster-v2.png" class="center" alt="Poster plus header" >}}

5. The rest of the content can be filled in a similar manner. We place the
   content of each cell using `\setlayerframed`. But what about the
   non-rectangular shapes? It is possible to ask ConTeXt [to typeset text in a
   non-rectangular
   shape](http://www.pragma-ade.com/general/magazines/mag-0010.pdf), but for
   something as simple as this poster, I prefer to manually break lines to
   give the impression of a non-rectangular shape. For example, this is the
   code for the middle block. Lot's of manual tweaking of the space, but it
   works!

    <pre><code><span class="Identifier">\setlayerframed</span><span class="Delimiter">[</span><span class="Type">text</span><span class="Delimiter">]</span>
    <span class="Delimiter">          [</span><span class="Type">line=45, x=1.75\layoutcolumnwidth</span><span class="Delimiter">]</span>
    <span class="Delimiter">          [</span><span class="Type">width=\dimexpr(3\layoutcolumnwidth-0.5in)\relax, </span>
    <span class="Type">           frame=off,</span>
    <span class="Type">           align=normal</span><span class="Delimiter">]</span>
    <span class="Delimiter">          {</span>
              <span class="String">$</span><span class="Statement">\MATRIX</span><span class="String">{x_1(t+1) ; x_2(t+1)} = </span>
    <span class="String">          </span><span class="Statement">\MATRIX</span><span class="String">{ A_{11}, 0; A_{21}, A_{22} } </span>
    <span class="String">          </span><span class="Statement">\MATRIX</span><span class="String">{ x_1(t); x_2(t) }</span>
    <span class="String">          +</span>
    <span class="String">          </span><span class="Statement">\MATRIX</span><span class="String">{ B_{11}, 0; B_{21}, B_{22} } </span>
    <span class="String">          </span><span class="Statement">\MATRIX</span><span class="String">{ u_1(t); u_2(t) }</span>
    <span class="String">          +</span>
    <span class="String">          </span><span class="Statement">\MATRIX</span><span class="String">{ w_1(t); w_2(t) }$</span>
              <span class="Statement">\blank</span><span class="Delimiter">[</span>line,fixed<span class="Delimiter">]</span>
              <span class="Statement">\hskip</span><span class="Number"> 1em</span>
              <span class="String">$</span><span class="Statement">\MATRIX</span><span class="String">{y_{1}(t) ; y_{2}(t)} = </span>
    <span class="String">          </span><span class="Statement">\MATRIX</span><span class="String">{ I, 0; C_{21}, C_{22} } </span>
    <span class="String">          </span><span class="Statement">\MATRIX</span><span class="String">{ x_1(t); x_2(t) }</span>
    <span class="String">          +</span>
    <span class="String">          </span><span class="Statement">\MATRIX</span><span class="String">{ 0; v_2(t) }$</span>
              <span class="Statement">\quad</span>
              <span class="Statement">\randomized</span><span class="Delimiter">[</span>width=0.8<span class="Statement">\layoutcolumnwidth</span>, location=lohi<span class="Delimiter">]</span>
                <span class="Delimiter">{</span>Noise need not be Gaussian<span class="Delimiter">}</span>
              <span class="Statement">\blank</span><span class="Delimiter">[</span>0.85<span class="Statement">\lineheight</span>,fixed<span class="Delimiter">]</span>
              <span class="Statement">\hskip</span> 0.5<span class="Statement">\layoutcolumnwidth</span>
              <span class="String">$J = </span><span class="Statement">\mathbb</span><span class="String">{E}</span><span class="Statement">\Bigl</span><span class="String">[ </span><span class="Statement">\displaystyle</span>
    <span class="String">          </span><span class="Statement">\sum_</span><span class="String">{t=1}^{T-1} </span><span class="Statement">\Bigl</span><span class="String">[ </span><span class="Statement">\NORM</span><span class="String">{x(t)}{Q} + </span><span class="Statement">\NORM</span><span class="String">{u(t)}{R} </span><span class="Statement">\Bigr</span><span class="String">]</span>
    <span class="String">          + </span><span class="Statement">\NORM</span><span class="String">{x(T)}{Q}</span>
    <span class="String">            </span><span class="Statement">\Bigr</span><span class="String">]$</span>
              <span class="Delimiter">}</span>

    <span class="Identifier">\setlayerframed</span><span class="Delimiter">[</span><span class="Type">text</span><span class="Delimiter">]</span>
    <span class="Delimiter">          [</span><span class="Type">y=34\LineHeight, x=\dimexpr(2.5\layoutcolumnwidth+0.5cm)</span><span class="Delimiter">]</span>
    <span class="Delimiter">          [</span><span class="Type">width=fit,</span>
    <span class="Type">           frame=off,</span>
    <span class="Type">           foregroundstyle=</span><span class="Delimiter">{</span><span class="Statement">\switchtobodyfont</span>[44pt]<span class="Statement">\bf</span><span class="Delimiter">}</span><span class="Type">,</span>
    <span class="Type">           foregroundcolor=background:light,</span>
    <span class="Type">           align=middle</span><span class="Delimiter">]</span>
    <span class="Delimiter">           {</span>Two-agent system with <span class="Special">\\</span> partial output feedback<span class="Delimiter">}</span>
    </code></pre>
   
   
     We also drew the background for the _headings_ of each block in MetaPost
     so that these could be clipped to the different shape. 
   
That's it! Layers really make it very simple to create visually attractive
_non-linear_ posters. 

