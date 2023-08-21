import 'package:fast_equatable/src/equality.dart';
import 'package:fast_equatable/src/i_hash_engine.dart';
import 'package:fast_equatable/src/jenkins_hash_engine.dart';
import 'package:meta/meta.dart';

// ignore: missing_override_of_must_be_overridden
mixin FastEquatable {
  int? _cachedHash;

  /// The additional equality check mitigates hash collisions with an additional
  /// equality check for each parameter, independent from the generated hash.
  ///
  /// It will also check if the objects are still equal and haven't changed since
  /// caching which shouldn't happen for cached instances.
  bool get additionalEqualityCheck => true;

  /// Whether to cache the hash after first initial calculation
  /// This itend to be used for immutable classes only.
  ///
  /// Caching makes sense when a lot of equality checks on different objects
  /// are happening
  @mustBeOverridden
  bool get cacheHash;

  /// Allows to use a custom hash engine
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
