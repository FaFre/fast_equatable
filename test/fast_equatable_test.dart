import 'package:fast_equatable/fast_equatable.dart';
import 'package:test/test.dart';

class TestClass with FastEquatable {
  final String value1;
  final List<String>? value2;

  const TestClass(
    this.value1,
    this.value2,
  );
  @override
  bool get cacheHash => false;

  @override
  bool get additionalEqualityCheck => false;

  @override
  List<Object?> get hashParameters => [value1, value2];
}

class TestRef with FastEquatable {
  final TestClass testClass;

  const TestRef(this.testClass);

  @override
  bool get cacheHash => false;

  @override
  bool get additionalEqualityCheck => false;

  @override
  List<Object?> get hashParameters => [testClass];
}

class TestExtClass extends TestClass {
  final List<TestClass?> additionalParam;

  const TestExtClass(
    super.value1,
    super.value2,
    this.additionalParam,
  );

  @override
  bool get cacheHash => false;

  @override
  bool get additionalEqualityCheck => false;

  @override
  List<Object?> get hashParameters =>
      [...super.hashParameters, additionalParam];
}

void main() {
  group('FastEquatable Mixin', () {
    test('Simple equals', () {
      const a = TestClass('value1', null);
      const b = TestClass('value1', null);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple unequals', () {
      const a = TestClass('value1', null);
      const b = TestClass('value2', null);

      expect(a == b, isFalse);
    });

    test('Simple equals iterable', () {
      const a = TestClass('value1', ['1', '2']);
      const b = TestClass('value1', ['1', '2']);

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Simple unequals iterable', () {
      const a = TestClass('value1', ['1', '2']);
      const b = TestClass('value1', ['2', '1']);

      expect(a == b, isFalse);
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('Equals null', () {
      const a = TestClass('value1', null);
      const b = TestClass('value1', []);

      expect(a == b, isFalse);
    });

    test('Cache hashcode with additional equals', () {
      const a = TestClass('value1', []);
      const b = TestClass('value1', []);

      expect(a == b, isTrue);
      b.value2!.add('this is bad');
      expect(a != b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Cache hashcode without additional equals', () {
      const a = TestClass('value1', []);
      const b = TestClass('value1', []);

      expect(a == b, isTrue);
      b.value2!.add('this is bad');
      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('Uncached hashcode', () {
      const a = TestClass('value1', []);
      const b = TestClass('value1', []);

      expect(a == b, isTrue);
      b.value2!.add('add new');
      expect(a == b, isFalse);
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('Testing identical reference', () {
      const a = TestClass('value1', []);

      const refA = TestRef(a);
      const refB = TestRef(a);

      expect(refA == refB, isTrue);
      a.value2!.add('add new');
      expect(refA == refB, isTrue);
      expect(refA.hashCode, equals(refB.hashCode));
    });
  });

  test('Testing extended classes unequal', () {
    const a = TestClass('d', []);
    final b = TestClass(String.fromCharCode(0x64), []);

    final c = TestExtClass(
      String.fromCharCode(0x64),
      [],
      [b],
    );

    final d = TestExtClass(
      String.fromCharCode(0x64),
      [],
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
}
