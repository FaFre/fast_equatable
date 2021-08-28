// Jenkins hash function, optimized for small integers.
//
// Base is borrowed from the dart sdk: sdk/lib/math/jenkins_smi_hash.dart.
class Jenkins {
  int _hash = 0;

  Jenkins();

  void add(Object? o) {
    assert(o is! Iterable);
    _hash = 0x1fffffff & (_hash + o.hashCode);
    _hash = 0x1fffffff & (_hash + ((0x0007ffff & _hash) << 10));
    _hash = _hash ^ (_hash >> 6);
  }

  int finish() {
    _hash = 0x1fffffff & (_hash + ((0x03ffffff & _hash) << 3));
    _hash = _hash ^ (_hash >> 11);
    _hash = 0x1fffffff & (_hash + ((0x00003fff & _hash) << 15));
    return _hash;
  }
}
