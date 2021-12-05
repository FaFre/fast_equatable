import 'package:collection/collection.dart';
import 'package:jenkins_hash/src/data/i_jenkins_hash.dart';

const _deepEquality = DeepCollectionEquality();

// Jenkins hash function, optimized for small integers.
//
// Base is borrowed from the dart sdk: sdk/lib/math/jenkins_smi_hash.dart.
class Jenkins {
  int _hash = 0;

  Jenkins();

  void add(Object? o) {
    assert(o is! Iterable);

    _hash = (_hash + o.hashCode) & 0x7fffffff;
    _hash = (_hash + (_hash << 10)) & 0x7fffffff;
    _hash ^= (_hash >> 6);
  }

  int finish() {
    _hash = (_hash + (_hash << 3)) & 0x7fffffff;
    _hash ^= (_hash >> 11);
    _hash = (_hash + (_hash << 15)) & 0x7fffffff;
    return _hash;
  }

  static int calculateHash(List<Object?> hashParameters) {
    if (hashParameters.isEmpty) {
      throw ArgumentError.value(
          'No hash parameters provided', '$hashParameters');
    } else if (hashParameters.length == 1) {
      return _deepEquality.hash(hashParameters.first);
    }

    var jenkins = Jenkins();
    for (final hashParam in hashParameters) {
      jenkins.add(_deepEquality.hash(hashParam));
    }

    return jenkins.finish();
  }

  static bool equals(IJenkinsHash main, IJenkinsHash other) {
    if (main.cacheHash || other.cacheHash) {
      return main.hashCode == other.hashCode &&
          (!(main.cacheAdditionalEquality && other.cacheAdditionalEquality) ||
              _deepEquality.equals(main.hashParameters, other.hashParameters));
    }

    final params = main.hashParameters;
    final otherParams = other.hashParameters;

    final length = params.length;
    if (length != otherParams.length) return false;

    for (var i = 0; i < length; i++) {
      final a = params[i];
      final b = otherParams[i];

      if (a is IJenkinsHash && b is IJenkinsHash) {
        return equals(a, b);
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
}
