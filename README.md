# loc

[![CI Status](https://github.com/mbarbin/loc/workflows/ci/badge.svg)](https://github.com/mbarbin/loc/actions/workflows/ci.yml)
[![Deploy odoc Status](https://github.com/mbarbin/loc/workflows/deploy-odoc/badge.svg)](https://github.com/mbarbin/loc/actions/workflows/deploy-odoc.yml)

`Loc.it` representing a range of lexing positions from a parsed file. It may be
used to decorate AST nodes built by parsers so as to allow located error
messages during file processing (compilers, interpreters, etc.)

It is inspired by dune's `Loc.t`, and uses it under the hood. The type equality
with `dune` is exposed for a better compatibility of packages that uses `loc`.
