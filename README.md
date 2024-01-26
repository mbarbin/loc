# loc

[![CI Status](https://github.com/mbarbin/loc/workflows/ci/badge.svg)](https://github.com/mbarbin/loc/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/mbarbin/loc/badge.svg?branch=main&service=github)](https://coveralls.io/github/mbarbin/loc?branch=main)

`Loc.it` representing a range of lexing positions from a parsed file. It may be
used to decorate AST nodes built by parsers so as to allow located error
messages during file processing (compilers, interpreters, etc.)

It is inspired by dune's `Loc.t`, and uses it under the hood. The type equality
with `dune` is exposed for a better compatibility of packages that uses `loc`.

## Code documentation

The code documentation of the latest release is built with `odoc` and published
to `GitHub` pages [here](https://mbarbin.github.io/loc).
