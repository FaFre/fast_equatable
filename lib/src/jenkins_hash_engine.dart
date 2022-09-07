import 'package:collection/collection.dart';
import 'package:fast_equatable/src/i_hash_engine.dart';

const _deepEquality = DeepCollectionEquality();

class JenkinsHashEngine implements IHashEngine {
  const JenkinsHashEngine();

  static int _add(int hash, Object? o) {
    assert(o is! Iterable);

    hash = (hash + o.hashCode) & 0x7fffffff;
    hash = (hash + (hash << 10)) & 0x7fffffff;
    return hash ^ (hash >> 6);
  }

  static int _finish(int hash) {
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
      hash = _add(hash, _deepEquality.hash(hashParam));
    }

    return _finish(hash);
  }
}
