import 'package:collection/collection.dart';
import 'package:jenkins_hash/src/jenkins.dart';

const _deepEquality = DeepCollectionEquality();

mixin JenkinsHashEquality {
  int? _cachedHash;

  bool get cacheHash;
  List<Object?> get hashParameters;

  int _calculateHash() {
    final params = hashParameters;
    if (params.isEmpty) {
      throw ArgumentError.value(
          'No hash parameters provided', '$hashParameters');
    } else if (params.length == 1) {
      return _deepEquality.hash(params.first);
    }

    var jenkins = Jenkins();
    for (final hashParam in hashParameters) {
      jenkins.add(_deepEquality.hash(hashParam));
    }

    return jenkins.finish();
  }

  bool equals(JenkinsHashEquality other) {
    if (cacheHash || other.cacheHash) {
      return hashCode == other.hashCode;
    }

    final params = hashParameters;
    final otherParams = other.hashParameters;

    final length = params.length;
    if (length != otherParams.length) return false;

    for (var i = 0; i < length; i++) {
      final a = params[i];
      final b = otherParams[i];

      if (a is JenkinsHashEquality && b is JenkinsHashEquality) {
        if (a.cacheHash || b.cacheHash) {
          return a.hashCode == b.hashCode;
        } else if (a != b) return false;
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

  @override
  int get hashCode {
    if (cacheHash) {
      _cachedHash ??= _calculateHash();
      return _cachedHash!;
    }

    return _calculateHash();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JenkinsHashEquality &&
            runtimeType == other.runtimeType &&
            equals(other));
  }
}
