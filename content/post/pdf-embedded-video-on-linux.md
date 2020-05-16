---
title: "PDF with embedded video on linux"
linktitle: "PDF with embedded video on linux"
date: 2020-05-16
categories:
  - pdf viewers
tags:
  - linux
  - pdfpc
  - video
---

I occassionally give presentations where the presentation must include
embedded videos. I typically include the movie using

<pre><code><span class="Statement">\externalfigure</span><span class="Delimiter">[</span>movie.mov<span class="Delimiter">][</span>height=..., width=..., preview=yes, repeat=yes<span class="Delimiter">]</span></code></pre>

Unfortunately, I could not find any reliable method to play such movies in
linux. So, whenever I needed to make a presentation with embedded video, I
would take out a rusty 9 year old Macbook and lug that around. Not anymore!

<!--more-->

A couple of months ago, I came across [pdfpc][pdfpc], which is a presenter
console with multi-monitor PDFs. I used it a few times to show speaker notes
during a presentation. Basically, you can create a file `filename.pdfpc` with
the following format:

```
[notes]
### 1
Notes for slide 1

### 2
Notes for slide 2
```

These are then displayed on the speaker view (i.e., my laptop screen) when
showing a PDF presentation. 

[pdfpc]: https://pdfpc.github.io/

[pdfpc][pdfpc] website claimed that pdfpc can also show videos. There is a
sample presentation with embedded video on their website. I tried it and it
didn't work, so I didn't bother investigating thinking that it is another
broken solution for showing presentations on linux. 

Today I tried to dig deeper into what is happening. The [pdfpc FAQ][FAQ] has a
hint that says that if video does not work run the following command

```
gst-play-1.0 --videosink gtksink <your video>
```

[FAQ]: https://github.com/pdfpc/pdfpc/blob/master/FAQ.rst

I tried that and got an error message

```
** (gst-play-1.0:288543): WARNING **: 00:49:51.923: Couldn't create specified video sink 'gtksink'
```

So, I did not have `gtksink`. I dug [a little
deeper](https://gstreamer.freedesktop.org/documentation/gtk/gtksink.html?gi-language=c)
and found that `gtksink` is included in GStreamer Good Plug-ins package. I use
Manjaro Linux (which is a clone of Arch Linux) on my laptop, and had
`gst-plugins-good` installed. So, I should be good, right? No.

```
$pacman -Ql gst-plugins-good | grep gtk
```

gives nothing! `gst-plugins-good` does not include `gstsink`. What was going
on? After a bit of digging, I found that Manjaro (and perhaps Arch) package
the plugins differently and the `gtk` plugin is included as a separate package
`gst-plugin-gtk`! After installing it, the video in the sample available on
pdfpc's website played correctly.

I tried with some of my old presentations with `\externalfigure[movie.mov]`
and they work (but no preview image is shown). I can fix that (by showing a
preview on a separate layer). Finally, I have a way to show pdfs with embedded
videos on linux! And I submitted a [pull
request](https://github.com/pdfpc/pdfpc/compare/master...adityam:patch-1) to
add this information to [pdfpc's FAQ][FAQ].

This whole experience reminds me of this: 

{{< img src="https://imgs.xkcd.com/comics/command_line_fu.png" class="center" alt="XKCD 196" >}}



