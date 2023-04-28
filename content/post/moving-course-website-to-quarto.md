---
title     : "Moving course website to quarto"
date  : 2023-04-23
tags  :
  - hugo
  - quarto
categories :
  - Web
---

For some years now, I have been maintaining the course notes for my graduate course as a [website] rather than a PDF document. I started with handwritten course notes the first time I taught the course, and then I typed them up in ConTeXt the next year. However, I wanted to add interactivity to my notes and that was not possible with PDF. (Technically, it is possible using Javascript, but Javascript in PDF has very limited support). So I experimented with maintaining my notes as a website and have been doing so for multiple years now. 

[website]: https://adityam.github.io/stochastic-control/notes/

<!--more-->

Overall, it has been a pleasant experience. I used [hugo] as a static website builder, which can use pandoc to convert markdown to HTML. The math is rendered by MathJax, and for the most part, the math typesetting is okay. However, I find that the overall typesetting of my website is not nice; in part because I am not too familiar with CSS + Javascript.

On a whim, I decided to try using [quarto], which is a framework built on pandoc to convert a single source to multiple output formats. I don't really need multiple output formats, but I decided to test quarto because the results look nice. A tested by converting a [few pages] and am impressed by the output. Most of the improvement in the look-and-feel is because quarto uses [bootstrap] behind the scenes. I could perhaps have done the same by using a bootstrap theme with my original website, but as I said, I am not familiar with CSS + Javascript. Quarto appears to be very well thought out, so I don't see a reason to reinvent the wheel. 

[hugo]: https://gohugo.io/
[quarto]: https://quarto.org/
[few pages]: https://adityam.github.io/course-notes/
[bootstrap]: https://getbootstrap.com/

One of the features of quarto is the ability to embed computations. This is similar to what I do in a lot of my ConTeXt documents using the [filter] module. Amongst other languages, quarto can embed [observable cells][observable] as well. To me this is a big deal. A few years ago, I had experimented with different means to embed interactive widgets in HTML: geogebra, plotly, and observable. And observable provided the nicest experience. 

However, one drawback was that the observable notebook is separate from markdown source. But with quarto, I can keep the observable code as part of the the same source, so it makes everything more portable. Yay!

I am also quite satisfied with the speed (both for compiling and rendering) as well as the quality. Look at a few examples: [the newsvendor problem](https://adityam.github.io/course-notes/stochastic-control/stochastic-optimization/newsvendor.html) and [optimal gambling](https://adityam.github.io/course-notes/stochastic-control/mdps/gambling.html) and judge for yourself. 

[filter]: https://github.com/adityam/filter
[observable]: https://observablehq.com/
