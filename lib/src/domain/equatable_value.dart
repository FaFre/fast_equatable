import 'package:fast_equatable/fast_equatable.dart';

///Simple wrapper to make a value e.g. collection equatable
class EquatableValue<T> with FastEquatable {
  final T value;
  final bool immutable;

  EquatableValue(
    this.value, {
    this.immutable = true,
    this.hashEngine = const JenkinsHashEngine(),
  });

  @override
  final IHashEngine hashEngine;

  @override
  bool get cacheHash => immutable;

  @override
  List<Object?> get hashParameters => [value, immutable];
}
