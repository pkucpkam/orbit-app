// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Streak {

 int get currentStreak; int get longestStreak; String? get lastLogDate;
/// Create a copy of Streak
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakCopyWith<Streak> get copyWith => _$StreakCopyWithImpl<Streak>(this as Streak, _$identity);

  /// Serializes this Streak to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Streak&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.lastLogDate, lastLogDate) || other.lastLogDate == lastLogDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreak,longestStreak,lastLogDate);

@override
String toString() {
  return 'Streak(currentStreak: $currentStreak, longestStreak: $longestStreak, lastLogDate: $lastLogDate)';
}


}

/// @nodoc
abstract mixin class $StreakCopyWith<$Res>  {
  factory $StreakCopyWith(Streak value, $Res Function(Streak) _then) = _$StreakCopyWithImpl;
@useResult
$Res call({
 int currentStreak, int longestStreak, String? lastLogDate
});




}
/// @nodoc
class _$StreakCopyWithImpl<$Res>
    implements $StreakCopyWith<$Res> {
  _$StreakCopyWithImpl(this._self, this._then);

  final Streak _self;
  final $Res Function(Streak) _then;

/// Create a copy of Streak
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? lastLogDate = freezed,}) {
  return _then(_self.copyWith(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,lastLogDate: freezed == lastLogDate ? _self.lastLogDate : lastLogDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Streak].
extension StreakPatterns on Streak {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Streak value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Streak() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Streak value)  $default,){
final _that = this;
switch (_that) {
case _Streak():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Streak value)?  $default,){
final _that = this;
switch (_that) {
case _Streak() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStreak,  int longestStreak,  String? lastLogDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Streak() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.lastLogDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStreak,  int longestStreak,  String? lastLogDate)  $default,) {final _that = this;
switch (_that) {
case _Streak():
return $default(_that.currentStreak,_that.longestStreak,_that.lastLogDate);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStreak,  int longestStreak,  String? lastLogDate)?  $default,) {final _that = this;
switch (_that) {
case _Streak() when $default != null:
return $default(_that.currentStreak,_that.longestStreak,_that.lastLogDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Streak implements Streak {
  const _Streak({this.currentStreak = 0, this.longestStreak = 0, this.lastLogDate});
  factory _Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);

@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override final  String? lastLogDate;

/// Create a copy of Streak
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakCopyWith<_Streak> get copyWith => __$StreakCopyWithImpl<_Streak>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Streak&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.lastLogDate, lastLogDate) || other.lastLogDate == lastLogDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreak,longestStreak,lastLogDate);

@override
String toString() {
  return 'Streak(currentStreak: $currentStreak, longestStreak: $longestStreak, lastLogDate: $lastLogDate)';
}


}

/// @nodoc
abstract mixin class _$StreakCopyWith<$Res> implements $StreakCopyWith<$Res> {
  factory _$StreakCopyWith(_Streak value, $Res Function(_Streak) _then) = __$StreakCopyWithImpl;
@override @useResult
$Res call({
 int currentStreak, int longestStreak, String? lastLogDate
});




}
/// @nodoc
class __$StreakCopyWithImpl<$Res>
    implements _$StreakCopyWith<$Res> {
  __$StreakCopyWithImpl(this._self, this._then);

  final _Streak _self;
  final $Res Function(_Streak) _then;

/// Create a copy of Streak
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? longestStreak = null,Object? lastLogDate = freezed,}) {
  return _then(_Streak(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,lastLogDate: freezed == lastLogDate ? _self.lastLogDate : lastLogDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
