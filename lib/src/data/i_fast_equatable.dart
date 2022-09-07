import 'package:fast_equatable/src/i_hash_engine.dart';

abstract class IFastEquatable {
  /// The additional equality check mitigates hash collisions with an additional
  /// equality check for each parameter, independent from the generated hash.
  ///
  /// It will also check if the objects are still equal and haven't changed since
  /// caching which shouldn't happen for cached instances.
  bool get additionalEqualityCheck;

  /// Whether to cache the hash after first initial calculation
  /// This itend to be used for immutable classes only.
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
