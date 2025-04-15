import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:xxh3/xxh3.dart';

int secureHashImpl(Object? obj, DeepCollectionEquality equality) {
  switch (obj) {
    case final Uint8List list:
      return xxh3(list);
    case final ByteBuffer buffer:
      return xxh3(buffer.asUint8List());
    case final TypedData data:
      return xxh3(data.buffer.asUint8List());
  }

  return equality.hash(obj);
}
