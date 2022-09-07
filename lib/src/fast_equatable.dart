import 'package:fast_equatable/src/data/i_fast_equatable.dart';
import 'package:fast_equatable/src/equality.dart';
import 'package:fast_equatable/src/i_hash_engine.dart';
import 'package:fast_equatable/src/jenkins_hash_engine.dart';

mixin FastEquatable implements IFastEquatable {
  int? _cachedHash;

  @override
  final bool additionalEqualityCheck = true;

  @override
  IHashEngine get hashEngine => const JenkinsHashEngine();

  @override
  int get hashCode {
    if (cacheHash) {
      return _cachedHash ??= hashEngine.calculateHash(hashParameters);
    }

    return hashEngine.calculateHash(hashParameters);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IFastEquatable &&
            runtimeType == other.runtimeType &&
            fastEquals(this, other));
  }
}
