import 'package:jenkins_hash/src/i_hash_engine.dart';

abstract class IJenkinsHash {
  /// The additional equality check mitigates hash collisions with an additional
  /// equality check for each parameter. The more parameters the better.
  ///
  /// It will also check if the objects are still equal and haven't changed since
  /// caching which shouldn't happen for cached instances.
  bool get cacheAdditionalEquality;

  /// Whether to cache the hash after first initial calculation
  /// This itend to be used for immutable instances only
  ///
  /// Caching makes sense when a lot of equality checks on different objects
  /// are happening
  bool get cacheHash;

  /// Allows to use a custom hash engine
  IHashEngine get hashEngine;

  /// The instances to generate the hash from and ultimately should uniqely
  /// identify an object
  List<Object?> get hashParameters;
}
