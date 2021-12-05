abstract class IJenkinsHash {
  /// The additional equality check mitigates hash collisions with an additional
  /// equality check for each parameter. The more parameters the better.
  ///
  /// It will also check if the objects are still equal and haven't changed since
  /// caching.
  bool get cacheAdditionalEquality;
  bool get cacheHash;
  List<Object?> get hashParameters;
}
