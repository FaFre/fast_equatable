import 'dart:math';
import 'dart:typed_data';

import 'package:fast_equatable/fast_equatable.dart';
import 'package:fast_equatable/hash.dart';
import 'package:test/test.dart';

class TestClass with FastEquatable {
  final String value1;
  final List<Object>? value2;

  TestClass(
    this.value1,
    this.value2,
    this.cacheHash,
    this.additionalEqualityCheck,
  );

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

class NestedPair with FastEquatable {
  final TestClass nested;
  final String tail;

  NestedPair(this.nested, this.tail);

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters => [nested, tail];
}

class TestExtClass extends TestClass {
  final List<TestClass?> additionalParam;

  TestExtClass(
    super.value1,
    super.value2,
    super.cachedHash,
    super.additionalEqualityCheck,
    this.additionalParam,
  );

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters =>
      [...super.hashParameters, additionalParam];
}

void main() {
  final rand = Random();

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

    test('Simple value equals', () {
      final a = EquatableValue(['value1', null, false, false]);
      final b = EquatableValue(['value1', null, false, false]);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple value unequals', () {
      final a = EquatableValue(['value1', null, false, false]);
      final b = EquatableValue(['value2', null, false, false]);

      expect(a == b, isFalse);
    });

    test('Simple with raw equals', () {
      final data =
          Uint64List.fromList(List.generate(10, (_) => rand.nextInt(0xFF)));

      final a = TestClass('value1', data, false, false);
      final b = TestClass('value1', data, false, false);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple raw unequals', () {
      final data =
          Uint8List.fromList(List.generate(10, (_) => rand.nextInt(0xFF)));
      final data2 =
          Uint8List.fromList(List.generate(10, (_) => rand.nextInt(0xFF)));

      final a = TestClass('value1', data, false, false);
      final b = TestClass('value1', data2, false, false);

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
    });

    test('Equality ignores cache and additional equality policy', () {
      final a = TestClass('value1', [], true, false);
      final b = TestClass('value1', [], false, true);

      expect(a == b, isTrue);
      b.value2!.add('this is bad');
      expect(a == b, isFalse);
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

  test('Testing extended classes unequal', () {
    final a = TestClass('d', [], false, false);
    final b = TestClass(String.fromCharCode(0x64), [], false, false);

    final c = TestExtClass(
      String.fromCharCode(0x64),
      [],
      false,
      false,
      [b],
    );

    final d = TestExtClass(
      String.fromCharCode(0x64),
      [],
      false,
      false,
      [],
    );

    expect(a == b, isTrue);
    expect(a.hashCode, equals(b.hashCode));

    expect(c != d, isTrue);
    expect(c.hashCode != d.hashCode, isTrue);

    d.additionalParam.add(a);
    expect(c == d, isTrue);
    expect(c.hashCode, equals(d.hashCode));
  });

  test('Nested FastEquatable values do not skip trailing fields', () {
    final nestedA = TestClass('value1', ['nested'], false, false);
    final nestedB = TestClass('value1', ['nested'], true, true);

    final a = NestedPair(nestedA, 'tail-a');
    final b = NestedPair(nestedB, 'tail-b');

    expect(a == b, isFalse);
  });

  test('EquatableValue ignores immutable flag for equality', () {
    final a = EquatableValue(['value1', null], immutable: true);
    final b = EquatableValue(['value1', null], immutable: false);

    expect(a == b, isTrue);
    expect(a.hashCode, equals(b.hashCode));
  });

  test('secureHash respects TypedData view bounds', () {
    final viewA = ByteData.sublistView(Uint8List.fromList([1, 2, 3, 4]), 1, 3);
    final viewB = ByteData.sublistView(Uint8List.fromList([9, 2, 3, 8]), 1, 3);
    final viewC = ByteData.sublistView(Uint8List.fromList([1, 2, 4, 4]), 1, 3);

    expect(secureHash(viewA), equals(secureHash(viewB)));
    expect(secureHash(viewA), isNot(equals(secureHash(viewC))));
  });
}
