+++
categories = ["design"]
date = "2013-01-13T19:54:48-07:00"
description = "Tutorial on creating ConTeXt presentation"
draft = false
tags = ["git", "presentation", "tutorial"]
title = "Creating a clean presentation style in 40 commits"
linktitle = "Clean presentation style"
+++

Did you always want to learn ConTeXt, but did not know where to start? I have
written a [git-based
tutorial](https://github.com/adityam/context-slides-example/commits) that should help you get started.

The idea of the tutorial is to start with an empty document, and add features
one-by-one. Each git commit corresponds to one small change in the document,
and includes pointers to the documentation corresponding to that change. Read
Use this tutorial as follows:

1. Clone the git repository:

        git clone git://github.com/adityam/context-slides-example.git
        cd context-slides-example

2. Get git-walk (requires ruby)

        wget https://raw.github.com/augustl/binbin/master/git-walk
        chmod +x git-walk

3. Checkout the first commit

        git checkout init

4. Open the two files, `slides.tex` and `example.tex` in the editor.

5. Read the log message, compile example.tex and view the result.

        git log -n 1
        context example.tex
        evince example.pdf &

6. Go to next commit and repeat step 5. (This requires `git-walk` to be in
   your `$PATH`.

        git walk next

(Alternatively, instead of using `git-walk`, you can use a GUI tool to
incrementally checkout the commits one by one, compile `example.tex` at each
step, and view the result).
