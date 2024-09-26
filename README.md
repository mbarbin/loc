# loc

[![CI Status](https://github.com/mbarbin/loc/workflows/ci/badge.svg)](https://github.com/mbarbin/loc/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/mbarbin/loc/badge.svg?branch=main)](https://coveralls.io/github/mbarbin/loc?branch=main)

Loc is an OCaml library to manipulate code locations, which are ranges of lexing positions from a parsed file. It may be used to decorate AST nodes built by parsers so as to allow located error messages during file processing (compilers, interpreters, linters, refactor tools, etc.)

It is inspired by dune's `Loc.t`, and uses it under the hood. The type equality with `Stdune.Loc.t` is currently not exposed and `Stdune` not mentioned in the interface of `Loc`, with the aim of keeping the signature of `Loc` stable across potential internal changes in `Stdune`.

## Code Documentation

The code documentation of the latest release is built with `odoc` and published to `GitHub` pages [here](https://mbarbin.github.io/loc).
