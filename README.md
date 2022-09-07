## Overview

This is a simple Dart package that provides fast and secure equality comparison as a `mixin`. This provides great compatibility to exsiting code.

It optionally offers hash caching to improve the speed of e.g. `Map`'s and `Set`'s significantly.

By default the widely spread [Jenkins hash function](https://en.wikipedia.org/wiki/Jenkins_hash_function) is used, but you are free to also implement and provide your own hash engine, suiting your needs.

Objects of any kind are allowed into `hashParameters`. Simple types and the standard collections like `List`, `Iterable`, `Map` an `Set` are supported by default. When you use own classes make sure to use the `FastEquatable` mixin as well, or make sure at least `hashCode` and `operator ==` are overriden.

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
equatable for 1000000 elements(RunTime): 8583044.5 us.
fast_equatable (uncached) for 1000000 elements(RunTime): 8493327.5 us.
fast_equatable (cached) for 1000000 elements(RunTime): 3329455.5 us.
```