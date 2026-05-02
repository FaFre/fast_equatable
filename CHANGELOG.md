## 2.0.0
- **Breaking:** Make `==` value-based by comparing `hashParameters` directly instead of relying on hash equality or equality policy flags.
- **Breaking:** Remove per-instance `hashEngine` configuration from `EquatableValue`.
- **Breaking:** Stop treating `EquatableValue.immutable` as part of semantic identity.
- Deprecate `additionalEqualityCheck`, which no longer affects equality.
- Fix nested `FastEquatable` comparisons so later fields are no longer skipped.
- Add a hash-mismatch fast reject before the final value comparison.
- Fix `TypedData` hashing to respect the view's `offsetInBytes` and `lengthInBytes`.
- Add regression tests for nested values, equality policy independence, `EquatableValue`, and `TypedData` views.

## 1.3.1
- Fix compatibility issue of `xxh3` for web

## 1.3.0
- Set `cacheHash` default to `true` e.g. assuming immutability
- Expose `EquatableValue` wrapper

## 1.2.0
- Use `xxh3` for `TypedData`
- Export `secureHash` through `hash.dart`
- Refactored codebase

## 1.1.0
- Added `mustBeOverriden` and `mustCallSuper` annotation
- **Potentially Breaking:** Simplify codebase by removing internal `IFastEquatable`

## 1.0.0
- Updated to Dart 3
- Switched from `lints` to `lint`
- Fixed lints
- Minor performance optimizations

## 0.9.1

- Added `meta` dependency
- Annotated some members with `@protected`

## 0.9.0

- Initial version.
