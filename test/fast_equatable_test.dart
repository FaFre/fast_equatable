import 'package:fast_equatable/fast_equatable.dart';
import 'package:test/test.dart';

class TestClass with FastEquatable {
  final String value1;
  final List<String>? value2;

  TestClass(
      this.value1, this.value2, this.cacheHash, this.additionalEqualityCheck);

  @override
  // ignore: overridden_fields
  bool additionalEqualityCheck;

  @override
  bool cacheHash;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class TestRef with FastEquatable {
  final TestClass testClass;

  TestRef(this.testClass);

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters => [testClass];
}

void main() {
  group('FastEquatable Mixin', () {
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
}
