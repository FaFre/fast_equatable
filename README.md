## Overview

This package provides value-based equality as a `mixin` with optional hash caching for immutable objects.

It can cache `hashCode` values to improve the speed of repeated `Map` and `Set` operations on immutable objects.

By default the widely spread [Jenkins hash function](https://en.wikipedia.org/wiki/Jenkins_hash_function) is used, but you can also provide your own hash engine as long as equal instances of the same runtime type use the same hashing behavior.

Objects of any kind are allowed into `hashParameters`. 

Simple types and the standard collections like `List`, `Iterable`, `Map` an `Set` are supported by default. 

For `TypedData` (e.g. `ByteBuffer`, `Uint8List`) the exteremely fast xxh3 algorithm is used. 

When you use your own classes make sure to use the `FastEquatable` mixin as well, or make sure at least `hashCode` and `operator ==` are overriden.

`==` is always based on the current values in `hashParameters`. `cacheHash` only affects whether `hashCode` is cached and should therefore only be enabled for immutable objects.

## Example

```dart
class FastEquatableCached with FastEquatable {
  final String value1;
  final List<String>? value2;

  FastEquatableCached(this.value1, this.value2);

  @override
  //This is a immutable object, so we want to cache the hash
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [value1, value2];
}
```

## Benchmark

In the `example` you will find a benchmark code, showing off the resulting speed improvement.

```
Running benchmark on list of strings...
equatable for 1000000 elements(RunTime): 3727783.0 us.
fast_equatable (mutable) for 1000000 elements(RunTime): 3697050.5 us.
fast_equatable (immutable) for 1000000 elements(RunTime): 988318.0 us.

Running benchmark on raw data...
equatable for 10000 elements(RunTime): 3628557.5 us.
fast_equatable (mutable) for 10000 elements(RunTime): 2020746.0 us.
fast_equatable (immutable) for 10000 elements(RunTime): 3004.28035982009 us.
```
