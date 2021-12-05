import 'package:jenkins_hash/src/data/i_jenkins_hash.dart';
import 'package:jenkins_hash/src/jenkins.dart';

mixin JenkinsHash implements IJenkinsHash {
  int? _cachedHash;

  @override
  final bool cacheAdditionalEquality = true;

  @override
  int get hashCode {
    if (cacheHash) {
      _cachedHash ??= Jenkins.calculateHash(hashParameters);
      return _cachedHash!;
    }

    return Jenkins.calculateHash(hashParameters);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IJenkinsHash &&
            runtimeType == other.runtimeType &&
            Jenkins.equals(this, other));
  }
}
