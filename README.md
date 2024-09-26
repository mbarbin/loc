# loc

[![CI Status](https://github.com/mbarbin/loc/workflows/ci/badge.svg)](https://github.com/mbarbin/loc/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/mbarbin/loc/badge.svg?branch=main)](https://coveralls.io/github/mbarbin/loc?branch=main)

Loc is an OCaml library to manipulate code locations, which are ranges of lexing positions from a parsed file.

It is inspired by dune's `Loc.t`, and uses it under the hood. The type equality with `Stdune.Loc.t` is currently not exposed and `Stdune` not mentioned in the interface of `Loc`, with the aim of keeping the signature of `Loc` stable across potential internal changes in `Stdune`.

## Code Documentation

The code documentation of the latest release is built with `odoc` and published to `GitHub` pages [here](https://mbarbin.github.io/loc).

## Motivation

Attaching locations to nodes manipulated by programs can be useful for applications such as compilers, interpreters, linters, refactor tools, etc.

Here are 3 kinds of examples using the `Loc` library:

1. Attach locations to the nodes of an AST. See [bopkit](https://github.com/mbarbin/bopkit/blob/main/lib/bopkit/src/netlist.mli).
2. Apply surgical patches to a file. See [file-rewriter](https://github.com/mbarbin/file-rewriter).
3. Emit located messages to the console. See cmdlang's [Err](https://github.com/mbarbin/cmdlang/blob/main/lib/err/src/err.mli) module.

## See also

Similar libraries or modules:

- Dune's [Loc.t](https://github.com/ocaml/dune/blob/dedfb76837bad6ea6de97de07e61f2ac10442127/otherlibs/stdune/src/loc.mli#L1)

- Parsexp's [ranges](https://github.com/janestreet/parsexp/blob/14af9ab942251783de6abb20e0d0e0eec6080062/src/positions.mli#L59)

- Ppxlib's [Location.t](https://github.com/ocaml-ppx/ppxlib/blob/456d1a99d354f8b3f34f01d1a7b61dc43ef678b6/src/location.ml#L4)

- Compilerlibs's [loc](https://github.com/ocaml/ocaml/blob/81003f23918729fa730c01ccffec25939cd730ff/utils/warnings.mli#L23)
