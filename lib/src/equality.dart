import 'package:collection/collection.dart';
import 'package:jenkins_hash/src/data/i_jenkins_hash.dart';

const _deepEquality = DeepCollectionEquality();

bool fastEquals(IJenkinsHash main, IJenkinsHash other) {
  if (main.cacheHash || other.cacheHash) {
    return main.hashCode == other.hashCode &&
        (!(main.cacheAdditionalEquality && other.cacheAdditionalEquality) ||
            _deepEquality.equals(main.hashParameters, other.hashParameters));
  }

  final params = main.hashParameters;
  final otherParams = other.hashParameters;

  final length = params.length;
  if (length != otherParams.length) return false;

  for (var i = 0; i < length; i++) {
    final a = params[i];
    final b = otherParams[i];

    if (a is IJenkinsHash && b is IJenkinsHash) {
      return fastEquals(a, b);
    } else if (_deepEquality.isValidKey(a)) {
      if (!_deepEquality.equals(a, b)) return false;
    } else if (a?.runtimeType != b?.runtimeType) {
      return false;
    } else if (a != b) {
      return false;
    }
  }

  return true;
}
