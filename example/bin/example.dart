import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:jenkins_hash/jenkins_hash.dart';

class TestClassJenkins with JenkinsHash {
  final String value1;
  final List<String>? value2;

  TestClassJenkins(this.value1, this.value2);

  @override
  bool get cacheHash => true;

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
  final randEquatable = List.generate(
      NAcc,
      (i) => TestClassEquatable(
          rand.nextInt(NAcc).toString(), [rand.nextInt(NAcc).toString()]));
  final randEquatableB = List.generate(
      NAcc,
      (i) => TestClassJenkins(
          rand.nextInt(NAcc).toString(), [rand.nextInt(NAcc).toString()]));

  var s = Stopwatch()..start();
  final set = <TestClassEquatable>{};

  for (var i = 0; i < N; i++) {
    set.add(TestClassEquatable(i.toString(), [i.toString()]));
  }

  for (var i = 0; i < NAcc; i++) {
    set.add(randEquatable[i]);
  }

  s.stop();
  print('Equatable took ${s.elapsedMilliseconds}');

  s = Stopwatch()..start();
  final setB = <TestClassJenkins>{};

  for (var i = 0; i < N; i++) {
    setB.add(TestClassJenkins(i.toString(), [i.toString()]));
  }

  for (var i = 0; i < NAcc; i++) {
    setB.add(randEquatableB[i]);
  }

  s.stop();
  print('Jenkins took ${s.elapsedMilliseconds}');
}
