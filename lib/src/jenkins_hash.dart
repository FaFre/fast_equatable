import 'package:jenkins_hash/src/data/i_jenkins_hash.dart';
import 'package:jenkins_hash/src/equality.dart';
import 'package:jenkins_hash/src/i_hash_engine.dart';
import 'package:jenkins_hash/src/jenkins_hash_engine.dart';

mixin JenkinsHash implements IJenkinsHash {
  int? _cachedHash;

  @override
  final bool cacheAdditionalEquality = true;

  @override
  IHashEngine get hashEngine => const JenkinsHashEngine();

  @override
  int get hashCode {
    if (cacheHash) {
      _cachedHash ??= hashEngine.calculateHash(hashParameters);
      return _cachedHash!;
    }

    return hashEngine.calculateHash(hashParameters);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IJenkinsHash &&
            runtimeType == other.runtimeType &&
            fastEquals(this, other));
  }
}
