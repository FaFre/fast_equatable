import 'package:collection/collection.dart';
import 'package:fast_equatable/fast_equatable.dart';

const _deepEquality = DeepCollectionEquality();

bool fastEquals(FastEquatable main, FastEquatable other) {
  if (main.cacheHash || other.cacheHash) {
    return main.hashCode == other.hashCode &&
        (!(main.additionalEqualityCheck && other.additionalEqualityCheck) ||
            _deepEquality.equals(main.hashParameters, other.hashParameters));
  }

  final params = main.hashParameters;
  final otherParams = other.hashParameters;

  final length = params.length;
  if (length != otherParams.length) return false;

  for (var i = 0; i < length; i++) {
    final a = params[i];
    final b = otherParams[i];

    if (a is FastEquatable && b is FastEquatable) {
      return fastEquals(a, b);
    } else if (_deepEquality.isValidKey(a)) {
      if (!_deepEquality.equals(a, b)) return false;
    } else if (a?.runtimeType != b?.runtimeType) {
      return false;
    } else if (a != b) {
      return false;
    }
  }

  return true;
}
