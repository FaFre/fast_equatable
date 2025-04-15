import 'package:collection/collection.dart';

int secureHashImpl(Object? obj, DeepCollectionEquality equality) {
  // Always use DeepCollectionEquality for web
  return equality.hash(obj);
}
