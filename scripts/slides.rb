#! /usr/bin/env -S ruby -W0

# Instructions: 
# When testing a new version of ConTeXt, change `generate_pdf` to `true`
# This will generate PDF files.
generate_pdf = false

# Run using
# bundle exec ./slides.rb
#
# For local testing before updating the blog post:
# Change `git_url` to local copy.
# In the local copy run: `git rebase -i --root`
# and then choose `reword` or `edit` to modify the commit as needed. 

require 'rugged'
require 'fileutils'


git_url = "https://github.com/adityam/context-slides-example.git"
# git_url = "/home/adityam/temp/context-slides-example/"
example = "example.tex"
blogdir = "/home/adityam/Projects/context/context-blog/content"
tmpdir  = "/tmp/slides"
outdir  = "#{blogdir}/post"
srcdir  = "#{tmpdir}/src"
post    = "presentation-40-commits-redux"
postdir = "#{outdir}/#{post}"


# Clean the output directory
FileUtils.mkdir_p postdir
FileUtils.rm_rf srcdir  if File.directory? srcdir

def context(file, result)
  Kernel.system "context --batch --noconsole --purgeall #{file} --result=#{result}" 
end

intro = %Q[---
title: "Creating a clean presentation style in 40 commits (redux)"
linktitle: "Clean presentation style (redux)"
tags:
  - git
  - presentation
  - tutorial
categories: 
  - design
date: 2020-05-14T02:30:00-04:00
---

<link rel="stylesheet" href="../../css/atom-one-light.css">
<script src="../../js/highlight.pack.js"></script>
<script>hljs.initHighlightingOnLoad();</script>

A while back, a had created a [git based tutorial][post] for learning how to
create a presentation style in ConTeXt. I chose a git based style so that it
was easy to see what changed in each commit and what effect did the change
have on the output. But it is cumbersome to work with, especially if you are new
to ConTeXt as well as git. 

[post]: ../presentation-40-commits

<!--more-->

So, I thought that it will be a good idea to automatically generate a single
page from that git repo. This way, a new user can actually see the output
without struggling with navigating git. I will try to update this post whenever I make any changes in the tutorial.

I am not completely happy with how all the information is displayed on this page, but have run out my HTML coding skills. Any suggestions to improve the output are welcome. And I hope the embedded PDFs work on all modern browsers. 

]

File.open("#{outdir}/#{post}.md", 'w') do |file|
  repo = Rugged::Repository.clone_at(git_url, srcdir)

  file.puts intro
  FileUtils.cd srcdir

  count = 0 
  repo.walk(repo.head.target_id,
            sorting = Rugged::SORT_TOPO | Rugged::SORT_REVERSE) do |commit|

    count += 1
    repo.checkout(commit.oid, strategy: :force)

    result = "example-%02d.pdf" % count

    if generate_pdf
       context(example, result)
       FileUtils.mv(result, postdir)
    end

    file.puts "## Step #{count}: #{commit.message}\n\n"

    if count == 1
      file.puts %Q[`slides.tex`:\n```\n#{File.read("slides.tex")}```\n\n]
      file.puts %Q[`example.tex`:\n```\n#{File.read("example.tex")}```\n\n]
    else
      file.puts %Q[```\n#{commit.parents[0].diff(commit).patch}```\n\n]
      file.puts %Q|Full files: [[slides.tex](https://github.com/adityam/context-slides-example/blob/#{commit.oid}/slides.tex)]|
      file.puts %Q|[[example.tex](https://github.com/adityam/context-slides-example/blob/#{commit.oid}/example.tex)]|
    end

    file.puts %Q[<embed class="center" 
                    src="#{result}\#toolbar=0&navpanes=0"
                    type="application/pdf"
                    width="600px" height="450px" />
    ]

  end
end

