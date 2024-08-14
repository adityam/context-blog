#! /usr/bin/env -S ruby -W0


# To initialize bundle on a new machine, run:
# bundle config set --local path '.bundle'
# Run using
# bundle exec ./generate.rb toml-file
#
require 'rugged'
require 'fileutils'
require 'tomlrb'

toml = ARGV[0]
config = Tomlrb.load_file(toml, symbolize_keys: true)

generate_pdf = config[:generate_pdf]

git_url = config[:git_url]
example = config[:example]
blogdir = config[:blogdir]
tmpdir  = config[:tmpdir]
post    = config[:post]

input   = config[:input]
env     = config[:env]
output  = config[:output]

intro   = config[:intro]

puts intro

outdir  = "#{blogdir}/post"
srcdir  = "#{tmpdir}/src"
postdir = "#{outdir}/#{post}"


# Clean the output directory
FileUtils.mkdir_p postdir
FileUtils.rm_rf srcdir  if File.directory? srcdir

def context(file, result)
  Kernel.system "context --batch --noconsole --purgeall #{file} --result=#{result}" 
end

File.open("#{outdir}/#{post}.md", 'w') do |file|
  unless Dir.exists?(srcdir)
    repo = Rugged::Repository.clone_at(git_url, srcdir)
  else
    repo = Rugged::Repository.new(srcdir)
  end
  FileUtils.cd srcdir

  file.puts intro

  count = 0 
  repo.walk(repo.head.target_id,
            sorting = Rugged::SORT_TOPO | Rugged::SORT_REVERSE) do |commit|

    count += 1
    repo.checkout(commit.oid, strategy: :force)

    result = "#{output}-%02d.pdf" % count

    if generate_pdf
       context(input, result)
       FileUtils.mv(result, postdir)
    end

    file.puts "## Step #{count}: #{commit.message}\n\n"

    if count == 1
      file.puts %Q[`#{env}.tex`:\n```\n#{File.read("#{env}.tex")}```\n\n]
      file.puts %Q[`#{input}.tex`:\n```\n#{File.read("#{input}.tex")}```\n\n]
    else
      file.puts %Q[```\n#{commit.parents[0].diff(commit).patch}```\n\n]
      file.puts %Q|Full files: [[#{env}.tex](https://github.com/adityam/context-slides-example/blob/#{commit.oid}/#{env}.tex)]|
      file.puts %Q|[[#{input}.tex](https://github.com/adityam/context-slides-example/blob/#{commit.oid}/#{input}.tex)]|
    end

    file.puts %Q[<embed class="center" 
                    src="#{result}\#toolbar=0&navpanes=0"
                    type="application/pdf"
                    width="600px" height="450px" />
    ]

  end
end

