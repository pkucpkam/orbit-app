// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'month_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthSummary {

 String get monthKey; int get totalIncome; int get totalExpense; int get totalSaved; Map<String, int> get byCategory; List<String> get loggedDays; DateTime? get updatedAt;
/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthSummaryCopyWith<MonthSummary> get copyWith => _$MonthSummaryCopyWithImpl<MonthSummary>(this as MonthSummary, _$identity);

  /// Serializes this MonthSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthSummary&&(identical(other.monthKey, monthKey) || other.monthKey == monthKey)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.totalSaved, totalSaved) || other.totalSaved == totalSaved)&&const DeepCollectionEquality().equals(other.byCategory, byCategory)&&const DeepCollectionEquality().equals(other.loggedDays, loggedDays)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monthKey,totalIncome,totalExpense,totalSaved,const DeepCollectionEquality().hash(byCategory),const DeepCollectionEquality().hash(loggedDays),updatedAt);

@override
String toString() {
  return 'MonthSummary(monthKey: $monthKey, totalIncome: $totalIncome, totalExpense: $totalExpense, totalSaved: $totalSaved, byCategory: $byCategory, loggedDays: $loggedDays, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MonthSummaryCopyWith<$Res>  {
  factory $MonthSummaryCopyWith(MonthSummary value, $Res Function(MonthSummary) _then) = _$MonthSummaryCopyWithImpl;
@useResult
$Res call({
 String monthKey, int totalIncome, int totalExpense, int totalSaved, Map<String, int> byCategory, List<String> loggedDays, DateTime? updatedAt
});




}
/// @nodoc
class _$MonthSummaryCopyWithImpl<$Res>
    implements $MonthSummaryCopyWith<$Res> {
  _$MonthSummaryCopyWithImpl(this._self, this._then);

  final MonthSummary _self;
  final $Res Function(MonthSummary) _then;

/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monthKey = null,Object? totalIncome = null,Object? totalExpense = null,Object? totalSaved = null,Object? byCategory = null,Object? loggedDays = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
monthKey: null == monthKey ? _self.monthKey : monthKey // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,totalSaved: null == totalSaved ? _self.totalSaved : totalSaved // ignore: cast_nullable_to_non_nullable
as int,byCategory: null == byCategory ? _self.byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as Map<String, int>,loggedDays: null == loggedDays ? _self.loggedDays : loggedDays // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthSummary].
extension MonthSummaryPatterns on MonthSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthSummary value)  $default,){
final _that = this;
switch (_that) {
case _MonthSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monthKey,  int totalIncome,  int totalExpense,  int totalSaved,  Map<String, int> byCategory,  List<String> loggedDays,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
return $default(_that.monthKey,_that.totalIncome,_that.totalExpense,_that.totalSaved,_that.byCategory,_that.loggedDays,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monthKey,  int totalIncome,  int totalExpense,  int totalSaved,  Map<String, int> byCategory,  List<String> loggedDays,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MonthSummary():
return $default(_that.monthKey,_that.totalIncome,_that.totalExpense,_that.totalSaved,_that.byCategory,_that.loggedDays,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monthKey,  int totalIncome,  int totalExpense,  int totalSaved,  Map<String, int> byCategory,  List<String> loggedDays,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
return $default(_that.monthKey,_that.totalIncome,_that.totalExpense,_that.totalSaved,_that.byCategory,_that.loggedDays,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthSummary implements MonthSummary {
  const _MonthSummary({required this.monthKey, this.totalIncome = 0, this.totalExpense = 0, this.totalSaved = 0, final  Map<String, int> byCategory = const {}, final  List<String> loggedDays = const [], this.updatedAt}): _byCategory = byCategory,_loggedDays = loggedDays;
  factory _MonthSummary.fromJson(Map<String, dynamic> json) => _$MonthSummaryFromJson(json);

@override final  String monthKey;
@override@JsonKey() final  int totalIncome;
@override@JsonKey() final  int totalExpense;
@override@JsonKey() final  int totalSaved;
 final  Map<String, int> _byCategory;
@override@JsonKey() Map<String, int> get byCategory {
  if (_byCategory is EqualUnmodifiableMapView) return _byCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byCategory);
}

 final  List<String> _loggedDays;
@override@JsonKey() List<String> get loggedDays {
  if (_loggedDays is EqualUnmodifiableListView) return _loggedDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loggedDays);
}

@override final  DateTime? updatedAt;

/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthSummaryCopyWith<_MonthSummary> get copyWith => __$MonthSummaryCopyWithImpl<_MonthSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthSummary&&(identical(other.monthKey, monthKey) || other.monthKey == monthKey)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.totalSaved, totalSaved) || other.totalSaved == totalSaved)&&const DeepCollectionEquality().equals(other._byCategory, _byCategory)&&const DeepCollectionEquality().equals(other._loggedDays, _loggedDays)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monthKey,totalIncome,totalExpense,totalSaved,const DeepCollectionEquality().hash(_byCategory),const DeepCollectionEquality().hash(_loggedDays),updatedAt);

@override
String toString() {
  return 'MonthSummary(monthKey: $monthKey, totalIncome: $totalIncome, totalExpense: $totalExpense, totalSaved: $totalSaved, byCategory: $byCategory, loggedDays: $loggedDays, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MonthSummaryCopyWith<$Res> implements $MonthSummaryCopyWith<$Res> {
  factory _$MonthSummaryCopyWith(_MonthSummary value, $Res Function(_MonthSummary) _then) = __$MonthSummaryCopyWithImpl;
@override @useResult
$Res call({
 String monthKey, int totalIncome, int totalExpense, int totalSaved, Map<String, int> byCategory, List<String> loggedDays, DateTime? updatedAt
});




}
/// @nodoc
class __$MonthSummaryCopyWithImpl<$Res>
    implements _$MonthSummaryCopyWith<$Res> {
  __$MonthSummaryCopyWithImpl(this._self, this._then);

  final _MonthSummary _self;
  final $Res Function(_MonthSummary) _then;

/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monthKey = null,Object? totalIncome = null,Object? totalExpense = null,Object? totalSaved = null,Object? byCategory = null,Object? loggedDays = null,Object? updatedAt = freezed,}) {
  return _then(_MonthSummary(
monthKey: null == monthKey ? _self.monthKey : monthKey // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,totalSaved: null == totalSaved ? _self.totalSaved : totalSaved // ignore: cast_nullable_to_non_nullable
as int,byCategory: null == byCategory ? _self._byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as Map<String, int>,loggedDays: null == loggedDays ? _self._loggedDays : loggedDays // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
