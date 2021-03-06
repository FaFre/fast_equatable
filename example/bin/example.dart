import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fast_equatable/fast_equatable.dart';

class FastEquatableCached with FastEquatable {
  final String value1;
  final List<String>? value2;

  FastEquatableCached(this.value1, this.value2);

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class FastEquatableUncached with FastEquatable {
  final String value1;
  final List<String>? value2;

  FastEquatableUncached(this.value1, this.value2);

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class TestClassEquatable extends Equatable {
  final String value1;
  final List<String>? value2;

  const TestClassEquatable(this.value1, this.value2);

  @override
  List<Object?> get props => [value1, value2];
}

void main(List<String> args) {
  const N = 1000000;
  const NAcc = 1000000;

  final rand = Random();
  final randsVal1 = List.generate(NAcc, (_) => rand.nextInt(NAcc).toString());
  final randsVal2 = List.generate(NAcc, (_) => rand.nextInt(NAcc).toString());

  final randEquatable = List.generate(
      NAcc, (i) => TestClassEquatable(randsVal1[i], [randsVal2[i]]));
  final randEquatableB = List.generate(
      NAcc, (i) => FastEquatableCached(randsVal1[i], [randsVal2[i]]));

  var s = Stopwatch()..start();
  final set = <TestClassEquatable>{};

  for (var i = 0; i < N; i++) {
    set.add(TestClassEquatable(i.toString(), [i.toString()]));
  }

  for (var i = 0; i < NAcc; i++) {
    set.add(randEquatable[i]);
  }

  s.stop();
  print(
      'Equatable took for Set<> with ${set.length} elements ${s.elapsedMilliseconds}ms');

  s = Stopwatch()..start();
  final setB = <FastEquatableCached>{};

  for (var i = 0; i < N; i++) {
    setB.add(FastEquatableCached(i.toString(), [i.toString()]));
  }

  for (var i = 0; i < NAcc; i++) {
    setB.add(randEquatableB[i]);
  }

  s.stop();
  print(
      'FastEquatable took for Set<> with ${setB.length} elements ${s.elapsedMilliseconds}ms');

  s = Stopwatch()..start();
}
