// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saving_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingGoal {

 String get id; String get name; int get targetAmount; int get savedAmount; DateTime get startDate; DateTime get targetDate; String get icon; String get colorToken; String get status;// 'active', 'completed', 'archived'
 List<int> get milestonesReached; DateTime? get completedAt;
/// Create a copy of SavingGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingGoalCopyWith<SavingGoal> get copyWith => _$SavingGoalCopyWithImpl<SavingGoal>(this as SavingGoal, _$identity);

  /// Serializes this SavingGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorToken, colorToken) || other.colorToken == colorToken)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.milestonesReached, milestonesReached)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,targetAmount,savedAmount,startDate,targetDate,icon,colorToken,status,const DeepCollectionEquality().hash(milestonesReached),completedAt);

@override
String toString() {
  return 'SavingGoal(id: $id, name: $name, targetAmount: $targetAmount, savedAmount: $savedAmount, startDate: $startDate, targetDate: $targetDate, icon: $icon, colorToken: $colorToken, status: $status, milestonesReached: $milestonesReached, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $SavingGoalCopyWith<$Res>  {
  factory $SavingGoalCopyWith(SavingGoal value, $Res Function(SavingGoal) _then) = _$SavingGoalCopyWithImpl;
@useResult
$Res call({
 String id, String name, int targetAmount, int savedAmount, DateTime startDate, DateTime targetDate, String icon, String colorToken, String status, List<int> milestonesReached, DateTime? completedAt
});




}
/// @nodoc
class _$SavingGoalCopyWithImpl<$Res>
    implements $SavingGoalCopyWith<$Res> {
  _$SavingGoalCopyWithImpl(this._self, this._then);

  final SavingGoal _self;
  final $Res Function(SavingGoal) _then;

/// Create a copy of SavingGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? targetAmount = null,Object? savedAmount = null,Object? startDate = null,Object? targetDate = null,Object? icon = null,Object? colorToken = null,Object? status = null,Object? milestonesReached = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,savedAmount: null == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,colorToken: null == colorToken ? _self.colorToken : colorToken // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,milestonesReached: null == milestonesReached ? _self.milestonesReached : milestonesReached // ignore: cast_nullable_to_non_nullable
as List<int>,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingGoal].
extension SavingGoalPatterns on SavingGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingGoal value)  $default,){
final _that = this;
switch (_that) {
case _SavingGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingGoal value)?  $default,){
final _that = this;
switch (_that) {
case _SavingGoal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int targetAmount,  int savedAmount,  DateTime startDate,  DateTime targetDate,  String icon,  String colorToken,  String status,  List<int> milestonesReached,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingGoal() when $default != null:
return $default(_that.id,_that.name,_that.targetAmount,_that.savedAmount,_that.startDate,_that.targetDate,_that.icon,_that.colorToken,_that.status,_that.milestonesReached,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int targetAmount,  int savedAmount,  DateTime startDate,  DateTime targetDate,  String icon,  String colorToken,  String status,  List<int> milestonesReached,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _SavingGoal():
return $default(_that.id,_that.name,_that.targetAmount,_that.savedAmount,_that.startDate,_that.targetDate,_that.icon,_that.colorToken,_that.status,_that.milestonesReached,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int targetAmount,  int savedAmount,  DateTime startDate,  DateTime targetDate,  String icon,  String colorToken,  String status,  List<int> milestonesReached,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _SavingGoal() when $default != null:
return $default(_that.id,_that.name,_that.targetAmount,_that.savedAmount,_that.startDate,_that.targetDate,_that.icon,_that.colorToken,_that.status,_that.milestonesReached,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingGoal implements SavingGoal {
  const _SavingGoal({required this.id, required this.name, required this.targetAmount, this.savedAmount = 0, required this.startDate, required this.targetDate, required this.icon, required this.colorToken, this.status = 'active', final  List<int> milestonesReached = const [], this.completedAt}): _milestonesReached = milestonesReached;
  factory _SavingGoal.fromJson(Map<String, dynamic> json) => _$SavingGoalFromJson(json);

@override final  String id;
@override final  String name;
@override final  int targetAmount;
@override@JsonKey() final  int savedAmount;
@override final  DateTime startDate;
@override final  DateTime targetDate;
@override final  String icon;
@override final  String colorToken;
@override@JsonKey() final  String status;
// 'active', 'completed', 'archived'
 final  List<int> _milestonesReached;
// 'active', 'completed', 'archived'
@override@JsonKey() List<int> get milestonesReached {
  if (_milestonesReached is EqualUnmodifiableListView) return _milestonesReached;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_milestonesReached);
}

@override final  DateTime? completedAt;

/// Create a copy of SavingGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingGoalCopyWith<_SavingGoal> get copyWith => __$SavingGoalCopyWithImpl<_SavingGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingGoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.savedAmount, savedAmount) || other.savedAmount == savedAmount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorToken, colorToken) || other.colorToken == colorToken)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._milestonesReached, _milestonesReached)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,targetAmount,savedAmount,startDate,targetDate,icon,colorToken,status,const DeepCollectionEquality().hash(_milestonesReached),completedAt);

@override
String toString() {
  return 'SavingGoal(id: $id, name: $name, targetAmount: $targetAmount, savedAmount: $savedAmount, startDate: $startDate, targetDate: $targetDate, icon: $icon, colorToken: $colorToken, status: $status, milestonesReached: $milestonesReached, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$SavingGoalCopyWith<$Res> implements $SavingGoalCopyWith<$Res> {
  factory _$SavingGoalCopyWith(_SavingGoal value, $Res Function(_SavingGoal) _then) = __$SavingGoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int targetAmount, int savedAmount, DateTime startDate, DateTime targetDate, String icon, String colorToken, String status, List<int> milestonesReached, DateTime? completedAt
});




}
/// @nodoc
class __$SavingGoalCopyWithImpl<$Res>
    implements _$SavingGoalCopyWith<$Res> {
  __$SavingGoalCopyWithImpl(this._self, this._then);

  final _SavingGoal _self;
  final $Res Function(_SavingGoal) _then;

/// Create a copy of SavingGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? targetAmount = null,Object? savedAmount = null,Object? startDate = null,Object? targetDate = null,Object? icon = null,Object? colorToken = null,Object? status = null,Object? milestonesReached = null,Object? completedAt = freezed,}) {
  return _then(_SavingGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,savedAmount: null == savedAmount ? _self.savedAmount : savedAmount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,colorToken: null == colorToken ? _self.colorToken : colorToken // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,milestonesReached: null == milestonesReached ? _self._milestonesReached : milestonesReached // ignore: cast_nullable_to_non_nullable
as List<int>,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
