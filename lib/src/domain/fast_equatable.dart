import 'package:fast_equatable/src/domain/engines/abstract/i_hash_engine.dart';
import 'package:fast_equatable/src/domain/engines/jenkins_hash_engine.dart';
import 'package:fast_equatable/src/helpers/equality.dart';
import 'package:meta/meta.dart';

// ignore: missing_override_of_must_be_overridden
mixin FastEquatable {
  int? _cachedHash;

  /// Retained for backwards compatibility.
  ///
  /// Equality always compares [hashParameters] directly.
  @Deprecated(
    'Equality always compares hashParameters directly. '
    'This flag no longer affects ==.',
  )
  bool get additionalEqualityCheck => true;

  /// Whether to cache the hash after first initial calculation
  /// This itend to be used for immutable classes only.
  ///
  /// Caching makes sense when a lot of equality checks on different objects
  /// are happening
  bool get cacheHash => true;

  /// Allows using a custom hash engine.
  ///
  /// To preserve the `==`/`hashCode` contract, equal instances of the same
  /// runtime type must resolve to the same hash engine behavior.
  ///
  /// Equality may use `hashCode` as a fast reject before comparing
  /// [hashParameters] directly.
  IHashEngine get hashEngine => const JenkinsHashEngine();

  /// The instances to generate the hash from and ultimately should uniqely
  /// identify an object
  @mustBeOverridden
  @mustCallSuper
  List<Object?> get hashParameters;

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
        (other is FastEquatable &&
            runtimeType == other.runtimeType &&
            fastEquals(this, other));
  }
}
