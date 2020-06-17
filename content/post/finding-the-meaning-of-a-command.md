---
title     : "Finding the meaning of a command"
date  : 2020-06-16T23:44:38-04:00
tags  :
  - \show
categories :
  - CLI
---

ConTeXt has a nice command to find a meaning of a command. Sometimes the
easiest way to find the meaning of a macro is to simply use

<pre><code><span class="Statement">\show\macroname</span></code></pre>

In LMTX, `context` defaults to running with `--batchmode`, which means that
you then have to hunt for the output of `\show` in the console output. 

ConTeXt comes with a nice script to simply get the meaning of a macro on
console.

```
$ mtxrun --script interface --meaning <macroname>
```

For example:

```
$ mtxrun --script interface --meaning dotfill

meaning         > dotfill

protected macro:->\cleaders \hbox {\normalstartimath \mathsurround \zeropoint \mkern 1.5mu.\mkern 1.5mu\normalstopimath }\hfill 
```

Behind the scenes this runs

```
mtxrun --silent --script context --extra=meaning --once --noconsole --nostatistics <macroname>
```

A side effect of this is that a file `context-extra.pdf` is generated in the
current directory. I usually run this command in `/tmp`. so I don't mind the
extra file. 
