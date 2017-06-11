+++
categories = ["rant"]
date = "2011-09-04T20:06:31-07:00"
description = "Rant about making TeX easy to use"
draft = false
tags = ["beginners"]
title = "Some thoughts on lowering the learning curve for using TeX"

+++

TeX has a steep learning curve. Often times, steeper than it needs to be.
Take, for example, the special characters in TeX. Almost every introduction to
plain TeX, eplain, LaTeX, or ConTeXt has a section on these special characters

    \ { } $ & # ^ _ & ~

A good introduction then goes on to explain why these special characters are
important; sometimes dropping a hint about category codes. I feel that these
details are useless and, **at the user level**, we should get rid of them.

If you are skeptical, I don’t blame you. After all, category codes are the
very soul of TeX. However, I strongly believe that they are useless at the
user level. Lets go over each of these special characters one-by-one and see
if we really need them.

### Minimum category codes: `\ { }`

The only category codes that we need at the user level are `\` `{` `}`. The
character `\` marks the start of a control sequence, and `{` and `}` group the
arguments. The rest, can simply be replaced by control sequences.

### Math mode category codes: `$ _ ^`

In TeX, `$` is used to delimit math mode—Knuth used dollars as the math shift
character because typesetting math was expensive, so goes an old joke. But do
we really need to stick to `$`? After all, at the user level, both LaTeX and
ConTeXt do not use `$$` to move to display math mode. Both macro packages
provide environments for display math. Can’t we do the same for in-line math?
In fact, both LaTeX and ConTeXt also provide macros for in-line math: LaTeX
uses `\(...\)` and ConTeXt uses `\m{...}` and `\math{...}`. The only trouble
is that these macros are not widely used (and that the LaTeX macros are not
robust, but that is easily correctable). The only real argument in favor of
`$...$` is that it shorted to type, but compared to `\(...\)` or `\m{...}`,
not by much.

The same is true for `_` and `^`. Both LaTeX and ConTeXt (in fact, so does plain
TeX!) provide macros for both of them: `\sp` for `^` and `\sb` for `_`. But don’t
panic! I am not asking everyone to start using `\sp` and `\sb`. What I am asking
is that `_` and `^` have normal meaning in text mode. That is, if I type `_`, I
should get `_`, not a funky error message. In fact, this is not too difficult to
achieve. In LaTeX, use the [underscore] package (it is easy to extend that to
take care of `^` as well), and in ConTeXt use `\nonknuthmode` somewhere in your
preamble.

[underscore]: https://www.ctan.org/pkg/underscore

Of course, the next logical step is to make `$` a normal letter: that is, if you
type `$` you get `$`. 

### Align character `&`

Horizontal alignment is one of the strengths of TeX. Most table and multi-line
display math environments use horizontal alignment and `&` specifies the
alignment point for horizontal alignment. Surely, getting rid of `&` will not
work.

Unfortunately, that is true in LaTeX. The `&` character is so critical for
horizontal alignment at the user-level that eliminating it will mean a lot of
change. Perhaps, `&` can be handled in the same manner as `_` and `^`: it can
be a regular letter in text mode and have special meaning inside horizontal
alignment. But, it is not always clear to the users which macros use
horizontal alignment internally. As such, changing the meaning of `&` inside
some environments will bring more trouble than benefits.

However, the situation in ConTeXt is completely different. At the user-level,
`&` is never used to indicate the alignment point. Both tables and multi-line
math display use `\NC ... \NC ... \NC \NR` type of syntax to indicate new
columns. In such a situation it is all the more awkward to explain to a user
why `&` is a special character. It should just be made a normal letter. LuaTeX
provides a `\aligntab` primitive which can be used instead in alignment macros.

### Parameter indicator `#`

Macros is what makes TeX different from all other text markup languages.
Automatic numbering, cross-references, headers and footers, and all possible
due to macros. And `#1` is used to indicate the first parameter for the macro,
`#2` the second, and so on. But, why do we need this special meaning at the
user-level? Only the macro writer needs to care about it.

Most LaTeX macros are written in `.sty` files, that are loaded under a different
catcode regime anyways. Most ConTeXt macros are written inside `\unprotect ...
\protect`. So, it is easy to set the traditional catcode regime in both cases.
If a user really needs to define macros in the middle of the document, there
can be a “programming” environment. For example, ConTeXt provides
`\starttexcode...\stoptexcode`, which sets the same catcodes as
`\unprotect...\protect`. Implementing the same environment in LaTeX is trivial
(think `\makeatletter...\makeatother on steroids).

### Unbreakable space `~`

Knuth used `~` to indicate an unbreakable space, and that tradition has
continued ever since. In this age of Unicode text, do we still need such
crutches. It is easy enough to type Unicode `0x00AA` (non-breakable space) in
most editors. For example, in vim I just need to type `CTRL+K+<space>+<space>`.
A smart syntax highlighting scheme will make the non-breakable space visible.
So, there is no real reason to keep on using `~` as a non-breakable space. The
same argument holds for the TeX macros for accents, typing in Unicode is easy
to input and easy to read (but that will be the subject of another rant).

### So, what’s the point of all this?

Now image that all these features have been implemented. Then, we may split
the introduction to a TeX macro package into two parts: using the macro
package and programming the macro package. Split the first part into two
further parts: text mode and math mode. For the text mode, the only special
characters are `\` `{` `}` `%`. All other characters are normal, that means if
you type them, you see them in the output (provided the font has the glyph;
lets ignore complex languages like Arabic, CJK, and Indic scripts and setting
appropriate font features for them at the moment). `\` starts a control
sequence, `{...}` groups an argument, and `%` is a line comment. For the math
mode, explain how to enter math mode (`\(...\)` or `\m{...}` or the display-math
environments) and explain that `_` and `^` are used to indicate sub- and
super-scripts. Postpone explaining the programming mode for later. I think
that such a scheme will lower the cognitive load on the new user.

Will such a system work? Yes, it will. In fact, it already does. For about an
year now, ConTeXt has a `\asciimode` macro that implements all these features,
with a slight twist. `%` is also a normal letter and you need to type `%%` to get
a line comment (and `%{}%` if you really need the output `%%`). This macro is not
enabled by default. I think that making it default will simplify understanding
TeX for the first time. As an added advantage, it will also make the job of
sanitizing the input simpler for converters (such as pandoc) that convert some
other markup language to TeX.
