#lang scribble/manual

@require[@for-label[schemake
                    compatibility/mlist
                    racket/base]]

@title{schemake}
@author[(author+email "James Butcher" "jamesbutcher@duck.com")]

@defmodule[schemake]

@defproc[(require-minimum-version [ver float?]) null?]{
  Require a minimum version of schemake in a build file.
}
@defproc[(project! [name string?] [lang symbol?]) null?]{
  Setup project infomation.
}
@defproc[(new-target! [name string?] [src (listof string?)] [args mlist? (mlist)] [#:lang lang symbol? null] [#:template t procedure? null]) null?]{
  Specify a new target to build.
}

A CMake/Meson inspired meta-programmable build system that compiles to ninja
