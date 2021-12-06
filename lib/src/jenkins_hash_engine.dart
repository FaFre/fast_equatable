import 'package:collection/collection.dart';
import 'package:jenkins_hash/src/data/i_jenkins_hash.dart';
import 'package:jenkins_hash/src/i_hash_engine.dart';

const _deepEquality = DeepCollectionEquality();

class JenkinsHashEngine implements IHashEngine {
  const JenkinsHashEngine();

  static int add(int hash, Object? o) {
    assert(o is! Iterable);

    hash = (hash + o.hashCode) & 0x7fffffff;
    hash = (hash + (hash << 10)) & 0x7fffffff;
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    hash = (hash + (hash << 3)) & 0x7fffffff;
    hash ^= (hash >> 11);
    return (hash + (hash << 15)) & 0x7fffffff;
  }

  @override
  int calculateHash(List<Object?> hashParameters) {
    if (hashParameters.isEmpty) {
      throw ArgumentError.value(
          'No hash parameters provided', '$hashParameters');
    } else if (hashParameters.length == 1) {
      return _deepEquality.hash(hashParameters.first);
    }

    var hash = 0;
    for (final hashParam in hashParameters) {
      hash = add(hash, _deepEquality.hash(hashParam));
    }

    return finish(hash);
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
