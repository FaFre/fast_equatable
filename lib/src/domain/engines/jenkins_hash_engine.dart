import 'package:collection/collection.dart';
import 'package:fast_equatable/src/domain/engines/abstract/i_hash_engine.dart';

const _deepEquality = DeepCollectionEquality();

class JenkinsHashEngine implements IHashEngine {
  const JenkinsHashEngine();

  @pragma("vm:prefer-inline")
  static int _add(int newHash, Object? o) {
    assert(o is! Iterable);

    var hash = (newHash + o.hashCode) & 0x7fffffff;
    hash = (hash + (hash << 10)) & 0x7fffffff;
    return hash ^ (hash >> 6);
  }

  @pragma("vm:prefer-inline")
  static int _finish(int newHash) {
    var hash = (newHash + (newHash << 3)) & 0x7fffffff;
    hash ^= hash >> 11;
    return (hash + (hash << 15)) & 0x7fffffff;
  }

  @override
  @pragma("vm:prefer-inline")
  int calculateHash(List<Object?> hashParameters) {
    if (hashParameters.isEmpty) {
      throw ArgumentError.value(
        'No hash parameters provided',
        '$hashParameters',
      );
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
