## 0.2.2 (2024-11-04)

### Fixed

- Fix `Offset.to_position` to allow the end-of-file offset instead of raising (#7, @mbarbin).

## 0.2.1 (2024-11-04)

### Added

- Add utils to build locs from file offsets and ranges (#6, @mbarbin).
- Make the library build with `ocaml.4.14` (#5, @mbarbin).
- Add new checks in CI (build checks on windows and macos) (#5, @mbarbin).

### Changed

- Rename `Loc.in_file` to `Loc.of_file`; rename `Loc.in_file_line` to `Loc.of_file_line` (#6, @mbarbin).

### Deprecated

- Prepare `Loc.in_file` and `Loc.in_file_line` for deprecation (#6, @mbarbin).

## 0.2.0 (2024-09-03)

### Added

- Added test - increase coverage.

### Changed

- Rename `Loc.Txt` fields to be closer to upstream compiler libs conventions.
- Merged `With_loc` into the main module, as `Loc.Txt`.
- Revert renaming the lib `loc0` - back to `loc`.

## 0.1.0 (2024-08-23)

### Changed

- Less dependencies: remove `base` & ppx preprocessing.
- Rename main package `loc0` in preparation to release to opam in the future.
- Remove `base` dependency, reduced to `sexplib0`.

## 0.0.6 (2024-07-26)

### Added

- Added dependabot config for automatically upgrading action files.

### Changed

- Upgrade `ppxlib` to `0.33` - activate unused items warnings.
- Upgrade `ocaml` to `5.2`.
- Upgrade `dune` to `3.16`.
- Upgrade base & co to `0.17`.

## 0.0.5 (2024-03-13)

### Changed

- Uses `expect-test-helpers` (reduce core dependencies)
- Run `ppx_js_style` as a linter & make it a `dev` dependency.
- Upgrade GitHub workflows `actions/checkout` to v4.
- In CI, specify build target `@all`, and add `@lint`.
- List ppxs instead of `ppx_jane`.

## 0.0.4 (2024-02-14)

### Changed

- Upgrade dune to `3.14`.
- Build the doc with sherlodoc available to enable the doc search bar.

## 0.0.3 (2024-02-09)

### Added

- Setup `bisect_ppx` for test coverage.
- Add utils on offsets and ranges.

### Changed

- Internal changes related to the release process.
- Upgrade dune and internal dependencies.

## 0.0.2 (2024-01-18)

### Added

- Add a few convenient accessors for start/stop positions.

### Changed

- Internal changes related to build and release process.

## 0.0.1 (2023-11-12)

Initial release.
