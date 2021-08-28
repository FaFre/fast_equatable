import 'package:jenkins_hash/src/jenkins.dart';

class PrecalculatedJenkins {
  final List<Object?> hashParameters;

  @override
  final int hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PrecalculatedJenkins && hashCode == other.hashCode);
  }

  const PrecalculatedJenkins._(this.hashParameters, this.hashCode);

  factory PrecalculatedJenkins.create(List<Object?> hashParameters) =>
      PrecalculatedJenkins._(
          hashParameters, Jenkins.calculateHash(hashParameters));
}
