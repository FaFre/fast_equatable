import 'package:collection/collection.dart';

import 'package:fast_equatable/src/helpers/secure_hashing/native.dart'
    if (dart.library.html) 'package:fast_equatable/src/helpers/secure_hashing/web.dart';

const _deepEquality = DeepCollectionEquality();

@pragma("vm:prefer-inline")
int secureHash(Object? obj) => secureHashImpl(obj, _deepEquality);
