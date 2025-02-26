import 'dart:math';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_equatable/fast_equatable.dart';

class FastEquatableCached with FastEquatable {
  final Object value1;
  final Object? value2;

  FastEquatableCached(this.value1, this.value2);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class FastEquatableUncached with FastEquatable {
  final Object value1;
  final Object? value2;

  FastEquatableUncached(this.value1, this.value2);

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class TestClassEquatable extends Equatable {
  final Object value1;
  final Object? value2;

  const TestClassEquatable(this.value1, this.value2);

  @override
  List<Object?> get props => [value1, value2];
}

class EquatableBenchmark extends BenchmarkBase {
  final List<Object> _randsValA;
  final List<Object> _randsValB;

  late final List<TestClassEquatable> objects;

  EquatableBenchmark(this._randsValA, this._randsValB)
      : assert(_randsValA.length == _randsValB.length),
        super('equatable for ${_randsValA.length} elements');

  @override
  void setup() {
    objects = List.generate(_randsValA.length,
        (i) => TestClassEquatable(_randsValA[i], [_randsValB[i]]));
  }

  @override
  void run() {
    final set = <TestClassEquatable>{};

    for (final obj in objects) {
      set.add(obj);
    }
  }
}

class FastEquatableUncachedBenchmark extends BenchmarkBase {
  final List<Object> _randsValA;
  final List<Object> _randsValB;

  late final List<FastEquatableUncached> objects;

  FastEquatableUncachedBenchmark(this._randsValA, this._randsValB)
      : assert(_randsValA.length == _randsValB.length),
        super('fast_equatable (mutable) for ${_randsValA.length} elements');

  @override
  void setup() {
    objects = List.generate(_randsValA.length,
        (i) => FastEquatableUncached(_randsValA[i], [_randsValB[i]]));
  }

  @override
  void run() {
    final set = <FastEquatableUncached>{};

    for (final obj in objects) {
      set.add(obj);
    }
  }
}

class FastEquatableCachedBenchmark extends BenchmarkBase {
  final List<Object> _randsValA;
  final List<Object> _randsValB;

  late final List<FastEquatableCached> objects;

  FastEquatableCachedBenchmark(this._randsValA, this._randsValB)
      : assert(_randsValA.length == _randsValB.length),
        super('fast_equatable (immutable) for ${_randsValA.length} elements');

  @override
  void setup() {
    objects = List.generate(_randsValA.length,
        (i) => FastEquatableCached(_randsValA[i], [_randsValB[i]]));
  }

  @override
  void run() {
    final set = <FastEquatableCached>{};

    for (final obj in objects) {
      set.add(obj);
    }
  }
}

void main(List<String> args) {
  final rand = Random();

  const nAcc = 1000000;

  final randsVal1 = List.generate(nAcc, (_) => rand.nextInt(nAcc).toString());
  final randsVal2 = List.generate(nAcc, (_) => rand.nextInt(nAcc).toString());

  const nRawAcc = 10000;
  const nRawSize = 1000;

  final rawRandsVal1 = List.generate(
      nRawAcc,
      (_) => Uint64List.fromList(
          List.generate(nRawSize, (_) => rand.nextInt(nAcc))));
  final rawRandsVal2 = List.generate(
      nRawAcc,
      (_) => Uint64List.fromList(
          List.generate(nRawSize, (_) => rand.nextInt(nAcc))));

  print('Running benchmark on list of strings...');
  EquatableBenchmark(randsVal1, randsVal2).report();
  FastEquatableUncachedBenchmark(randsVal1, randsVal2).report();
  FastEquatableCachedBenchmark(randsVal1, randsVal2).report();

  print('Running benchmark on raw data...');
  EquatableBenchmark(rawRandsVal1, rawRandsVal2).report();
  FastEquatableUncachedBenchmark(rawRandsVal1, rawRandsVal2).report();
  FastEquatableCachedBenchmark(rawRandsVal1, rawRandsVal2).report();
}
