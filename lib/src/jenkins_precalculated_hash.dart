import 'package:jenkins_hash/src/data/i_jenkins_hash.dart';
import 'package:jenkins_hash/src/data/precalculated_jenkins.dart';
import 'package:jenkins_hash/src/jenkins.dart';

abstract class JenkinsPrecalculatedHash implements IJenkinsHash {
  final PrecalculatedJenkins _precalculatedJenkins;

  @override
  final bool cacheAdditionalEquality = true;
  @override
  final bool cacheHash = true;
  @override
  List<Object?> get hashParameters => _precalculatedJenkins.hashParameters;

  const JenkinsPrecalculatedHash(PrecalculatedJenkins precalculatedJenkins)
      : _precalculatedJenkins = precalculatedJenkins;

  @override
  int get hashCode => _precalculatedJenkins.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IJenkinsHash &&
            runtimeType == other.runtimeType &&
            Jenkins.equals(this, other));
  }
}
