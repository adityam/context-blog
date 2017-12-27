---
title : "Interfacing LuaTeX with Julia"
categories:
- FFI
date: 2017-12-27
tags:
- julia
---

One cool feature of LuaTeX is ability to interface with external
libraries using Lua's [Foreign Function Interface (FFI)][FFI]. An
extreme example of this is Luigi Scarso's [LuaTeX lunatic][lunatic],
which provides a two way bridge between Python and LuaTeX. Not being a Python
fan, I never looked into the implementation details, in spite of Luigi's
impressive examples.

Recently, Henri Menke [posted an interesting
example](https://tex.stackexchange.com/a/403794/323) that shows how to use a
function from [GNU Scientific Library
(GSL)](https://www.gnu.org/software/gsl/) to inteface with [pgfplots]. This
got me interested in looking into Lua's FFI in detail. After a bit of trial
and error, I finally figured out how to interface LuaTeX with my current
favorite programming language: [Julia].

<!--more-->


## Calling Julia from Lua

The basic idea of calling julia (or any other C library for that matter) from
Lua is the following:

<!--
```
local ffi = require("ffi")
local JULIA = ffi.load("julia", true)

ffi.cdef [[
  void jl_init(void);
  typedef struct _jl_value_t jl_value_t;
  jl_value_t *jl_eval_string(const char*);
]]

JULIA.jl_init()

code = [[
  x = [1 2 3]'
  A = [1 0 1; 0 1 1; 1 1 0]

  y = x'*A*x

  print(y[1])
]]

JULIA.jl_eval_string(code)
```
-->

<pre><code><span class="Statement">local</span> ffi = <span class="Identifier">require</span>(<span class="Constant">&quot;ffi&quot;</span>)
<span class="Statement">local</span> JULIA = ffi.<span class="Identifier">load</span>(<span class="Constant">&quot;julia&quot;</span>, <span class="Constant" style="font-weight: bold;">true</span>)

ffi.cdef <span class="Constant">[[</span>
<span class="Constant">  void jl_init(void);</span>
<span class="Constant">  typedef struct _jl_value_t jl_value_t;</span>
<span class="Constant">  jl_value_t *jl_eval_string(const char*);</span>
<span class="Constant">]]</span>

JULIA.jl_init()

code = <span class="Constant">[[</span>
<span class="Constant">  x = [1 2 3]'</span>
<span class="Constant">  A = [1 0 1; 0 1 1; 1 1 0]</span>

<span class="Constant">  y = x'*A*x</span>

<span class="Constant">  print(y[1])</span>
<span class="Constant">]]</span>

JULIA.jl_eval_string(code)
</code></pre>

Save this as, say `test-1.lua` and run:

    luatex test-1.lua

You should see `23` as output.

Phew! That wasn't difficult. A couple of points to note:

1. It took me quite some time to figure out that I need `ffi.load("julia",
   true)` rather than `ffi.load("julia")`. Lua's [FFI API][FFI-API]
   documentation says that when the second argument is `true`, _he library
   symbols are loaded into the global namespace, too._. I don't completely
   understand that statement. The only hint that this is needed is a  note on
   [Embedding Julia][embedding] page that says _Currently, dynamically linking
   with the libjulia shared library requires passing the `RTLD_GLOBAL`
   option._  Since I was not familiar with working with FFI, I could not put 
   two and two together. 

2. I don't quite understand why one needs to include the function signatures
   in `ffi.cdef`. It would be much simpler if I could simply ask `ffi` to
   include a C header file. Otherwise, I need to hunt for all the
   needed function signatures from `julia.h` file. Some of these functions are
   defined using `#define` and I don't know how to include them in `ffi.cdef`. 

## Creating a TeX inteface

Now that we know how to call Julia from Lua, the rest is just adding some
scafolding to create a TeX inteface. Lua's FFI interface allows one to call
any function defined in a  C library and convert return values to Lua objects
(strings, numbers, or tables). As a proof of concept, I decided to only pass
and receive strings. This is limited (and you need to ensure that the Julia
code returns a string), but easier to implement. 

To do so, I defined a Lua function `julia.eval(str, flag)`, which takes a
string `str` and evals it using julia. If `flag` is set to `true`, then it
converts the return value to a lua string and typesets it using ConTeXt. 

<!---
```
\startluacode
local ffi = require("ffi")
local JULIA = ffi.load("/usr/lib/libjulia.so", true)
local format = string.format

ffi.cdef [[
  void jl_init(void);

  typedef struct _jl_value_t jl_value_t;
  jl_value_t *jl_eval_string(const char*);
  char *jl_string_ptr(jl_value_t *);
]]

JULIA.jl_init()

julia = julia or {}

function julia.eval(str, flag)
  local jval  = JULIA.jl_eval_string(str)
  if flag then
    local lval = ffi.string(JULIA.jl_string_ptr(jval))
    context(lval)
  end
end

\stopluacode

\define[1]\ctxjulia{\ctxlua{julia.eval([===[#1]===], true) }}
\define[1]\julia   {\ctxlua{julia.eval([===[#1]===], false)}}

\starttext
\julia{a = 10}
\julia{b = 5}
\ctxjulia{string(a*b)}
\stoptext
```
-->

<pre><code><span class="Identifier">\startluacode</span>
<span class="Statement">local</span> ffi = <span class="Identifier">require</span>(<span class="Constant">&quot;ffi&quot;</span>)
<span class="Statement">local</span> JULIA = ffi.<span class="Identifier">load</span>(<span class="Constant">&quot;/usr/lib/libjulia.so&quot;</span>, <span class="Constant">true</span>)
<span class="Statement">local</span> format = <span class="Identifier">string.format</span>

ffi.cdef <span class="Constant">[[</span>
<span class="Constant">  void jl_init(void);</span>

<span class="Constant">  typedef struct _jl_value_t jl_value_t;</span>
<span class="Constant">  jl_value_t *jl_eval_string(const char*);</span>
<span class="Constant">  char *jl_string_ptr(jl_value_t *);</span>
<span class="Constant">]]</span>

JULIA.jl_init()

julia = julia <span class="Statement">or</span> <span class="Type">{}</span>

<span class="Identifier">function</span> julia.eval(str, flag)
  <span class="Statement">local</span> jval  = JULIA.jl_eval_string(str)
  <span class="Statement">if</span> flag <span class="Statement">then</span>
    <span class="Statement">local</span> lval = ffi.string(JULIA.jl_string_ptr(jval))
    context(lval)
  <span class="Statement">end</span>
<span class="Identifier">end</span>

<span class="Identifier">\stopluacode</span>
</pre></code>

Then, at the TeX end, I define two macros: `\julia` which simply evaluates its
argument using julia and `\ctxjulia` which evaluates its argument using julia
and typesets the result. 

<pre><code><span class="Identifier">\define</span><span class="Special">[</span><span class="Type">1</span><span class="Special">]</span><span class="Statement">\ctxjulia</span><span class="Special">{</span><span class="Statement">\ctxlua</span><span class="Special">{</span>julia.eval(<span class="Special">[</span>===<span class="Special">[</span>#1<span class="Special">]</span>===<span class="Special">]</span>, true) <span class="Special">}}</span>
<span class="Identifier">\define</span><span class="Special">[</span><span class="Type">1</span><span class="Special">]</span><span class="Statement">\julia</span>   <span class="Special">{</span><span class="Statement">\ctxlua</span><span class="Special">{</span>julia.eval(<span class="Special">[</span>===<span class="Special">[</span>#1<span class="Special">]</span>===<span class="Special">]</span>, false)<span class="Special">}}</span>
</code></pre>

Here is a simple usage example. 

<pre><code><span class="PreProc">\starttext</span>
<span class="Statement">\julia</span><span class="Special">{</span>a = 10<span class="Special">}</span>
<span class="Statement">\julia</span><span class="Special">{</span>b = 5<span class="Special">}</span>
<span class="Statement">\ctxjulia</span><span class="Special">{</span>string(a*b)<span class="Special">}</span>
<span class="PreProc">\stoptext</span>
</code></pre>

which, as expected, prints _50_. Sure, for something as simple as this, I
could have simply used Lua as well. In a future post, I'll show how to create
a nicer user-interface and do show some more interesting examples. 

[FFI]: http://luajit.org/ext_ffi.html
[FFI-API]: http://luajit.org/ext_ffi_api.html
[lunatic]: https://www.tug.org/TUGboat/tb30-3/tb96scarso.pdf
[pgfplots]: http://pgfplots.sourceforge.net
[Julia]: https://julialang.org
[embedding]: https://docs.julialang.org/en/release-0.6/manual/embedding/
