// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NameValidFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameValidFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NameValidFailure()';
}


}

/// @nodoc
class $NameValidFailureCopyWith<$Res>  {
$NameValidFailureCopyWith(NameValidFailure _, $Res Function(NameValidFailure) __);
}


/// Adds pattern-matching-related methods to [NameValidFailure].
extension NameValidFailurePatterns on NameValidFailure {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _IllegalCharacters value)?  illegalCharacters,TResult Function( _Obscene value)?  obscene,TResult Function( _Empty value)?  empty,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IllegalCharacters() when illegalCharacters != null:
return illegalCharacters(_that);case _Obscene() when obscene != null:
return obscene(_that);case _Empty() when empty != null:
return empty(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _IllegalCharacters value)  illegalCharacters,required TResult Function( _Obscene value)  obscene,required TResult Function( _Empty value)  empty,}){
final _that = this;
switch (_that) {
case _IllegalCharacters():
return illegalCharacters(_that);case _Obscene():
return obscene(_that);case _Empty():
return empty(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _IllegalCharacters value)?  illegalCharacters,TResult? Function( _Obscene value)?  obscene,TResult? Function( _Empty value)?  empty,}){
final _that = this;
switch (_that) {
case _IllegalCharacters() when illegalCharacters != null:
return illegalCharacters(_that);case _Obscene() when obscene != null:
return obscene(_that);case _Empty() when empty != null:
return empty(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  illegalCharacters,TResult Function()?  obscene,TResult Function()?  empty,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IllegalCharacters() when illegalCharacters != null:
return illegalCharacters();case _Obscene() when obscene != null:
return obscene();case _Empty() when empty != null:
return empty();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  illegalCharacters,required TResult Function()  obscene,required TResult Function()  empty,}) {final _that = this;
switch (_that) {
case _IllegalCharacters():
return illegalCharacters();case _Obscene():
return obscene();case _Empty():
return empty();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  illegalCharacters,TResult? Function()?  obscene,TResult? Function()?  empty,}) {final _that = this;
switch (_that) {
case _IllegalCharacters() when illegalCharacters != null:
return illegalCharacters();case _Obscene() when obscene != null:
return obscene();case _Empty() when empty != null:
return empty();case _:
  return null;

}
}

}

/// @nodoc


class _IllegalCharacters implements NameValidFailure {
  const _IllegalCharacters();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IllegalCharacters);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NameValidFailure.illegalCharacters()';
}


}




/// @nodoc


class _Obscene implements NameValidFailure {
  const _Obscene();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Obscene);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NameValidFailure.obscene()';
}


}




/// @nodoc


class _Empty implements NameValidFailure {
  const _Empty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NameValidFailure.empty()';
}


}




// dart format on
