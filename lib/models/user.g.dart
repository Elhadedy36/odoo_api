// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: _parsePhone(json['phone']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };

String? _parsePhone(dynamic phone) {
  if (phone == null) return null;
  if (phone is String) return phone;
  if (phone is bool) return phone ? 'true' : 'false';
  if (phone is int) return phone.toString();
  if (phone is double) return phone.toString();
  return phone.toString();
}