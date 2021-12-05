import 'package:jenkins_hash/jenkins_hash.dart';
import 'package:jenkins_hash/src/data/precalculated_jenkins.dart';
import 'package:test/test.dart';

class TestClass with JenkinsHash {
  final String value1;
  final List<String>? value2;

  TestClass(
      this.value1, this.value2, this.cacheHash, this.cacheAdditionalEquality);

  @override
  bool cacheAdditionalEquality;

  @override
  bool cacheHash;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class ConstTestClass extends JenkinsPrecalculatedHash {
  final String value1;
  final List<String>? value2;

  ConstTestClass(this.value1, this.value2)
      : super(PrecalculatedJenkins.create([value1, value2]));
}

class TestRef with JenkinsHash {
  final TestClass testClass;

  TestRef(this.testClass);

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters => [testClass];
}

void main() {
  group('JenkinsHash Mixin', () {
    test('Simple equals', () {
      final a = TestClass('value1', null, false, false);
      final b = TestClass('value1', null, false, false);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple unequals', () {
      final a = TestClass('value1', null, false, false);
      final b = TestClass('value2', null, false, false);

      expect(a == b, isFalse);
    });

    test('Simple equals iterable', () {
      final a = TestClass('value1', ['1', '2'], false, false);
      final b = TestClass('value1', ['1', '2'], false, false);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple unequals iterable', () {
      final a = TestClass('value1', ['1', '2'], false, false);
      final b = TestClass('value1', ['2', '1'], false, false);

      expect(a == b, isFalse);
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('Equals null', () {
      final a = TestClass('value1', null, false, false);
      final b = TestClass('value1', [], false, false);

      expect(a == b, isFalse);
    });

    test('Cache hashcode with additional equals', () {
      final a = TestClass('value1', [], true, true);
      final b = TestClass('value1', [], true, true);

      expect(a == b, isTrue);
      b.value2!.add('this is bad');
      expect(a != b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Cache hashcode without additional equals', () {
      final a = TestClass('value1', [], true, false);
      final b = TestClass('value1', [], true, false);

      expect(a == b, isTrue);
      b.value2!.add('this is bad');
      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Uncached hashcode', () {
      final a = TestClass('value1', [], false, false);
      final b = TestClass('value1', [], false, false);

      expect(a == b, isTrue);
      b.value2!.add('add new');
      expect(a == b, isFalse);
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('Testing identical reference', () {
      final a = TestClass('value1', [], false, false);

      final refA = TestRef(a);
      final refB = TestRef(a);

      expect(refA == refB, isTrue);
      a.value2!.add('add new');
      expect(refA == refB, isTrue);
      expect(refA.hashCode, equals(refB.hashCode));
    });
  });

  group('JenkinsHash Precalculated', () {
    test('Simple equals', () {
      final a = ConstTestClass('value1', null);
      final b = ConstTestClass('value1', null);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple unequals', () {
      final a = ConstTestClass('value1', null);
      final b = ConstTestClass('value2', null);

      expect(a == b, isFalse);
    });

    test('Simple equals iterable', () {
      final a = ConstTestClass('value1', ['1', '2']);
      final b = ConstTestClass('value1', ['1', '2']);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple unequals iterable', () {
      final a = ConstTestClass('value1', ['1', '2']);
      final b = ConstTestClass('value1', ['2', '1']);

      expect(a == b, isFalse);
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('Equals null', () {
      final a = ConstTestClass('value1', null);
      final b = ConstTestClass('value1', []);

      expect(a == b, isFalse);
    });

    test('Cache hashcode', () {
      final a = ConstTestClass('value1', []);
      final b = ConstTestClass('value1', []);

      expect(a == b, isTrue);
      b.value2!.add('this is bad');
      expect(a != b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
