import 'package:collection/collection.dart';
import 'package:fast_equatable/fast_equatable.dart';

const _deepEquality = DeepCollectionEquality();

bool fastEquals(FastEquatable main, FastEquatable other) {
  if (identical(main, other)) return true;

  if ((main.cacheHash || other.cacheHash) && main.hashCode != other.hashCode) {
    return false;
  }

  final params = main.hashParameters;
  final otherParams = other.hashParameters;

  final length = params.length;
  if (length != otherParams.length) return false;

  for (var i = 0; i < length; i++) {
    final a = params[i];
    final b = otherParams[i];

    if (!_objectsEquals(a, b)) return false;
  }

  return true;
}

@pragma('vm:prefer-inline')
bool _objectsEquals(Object? a, Object? b) {
  if (identical(a, b)) return true;

  if (a is FastEquatable && b is FastEquatable) {
    return a.runtimeType == b.runtimeType && fastEquals(a, b);
  } else if (a is num && b is num) {
    return a == b;
  } else if (a is Iterable && b is Iterable) {
    return _deepEquality.equals(a, b);
  } else if (a is Map && b is Map) {
    return _deepEquality.equals(a, b);
  } else if (a?.runtimeType != b?.runtimeType) {
    return false;
  }

  return a == b;
}
