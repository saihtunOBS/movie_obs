// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftDataResponse _$GiftDataResponseFromJson(Map<String, dynamic> json) =>
    GiftDataResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => GiftVO.fromJson(e as Map<String, dynamic>))
              .toList(),
      count: (json['count'] as num?)?.toInt(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GiftDataResponseToJson(GiftDataResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'count': instance.count,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
    };

GiftVO _$GiftVOFromJson(Map<String, dynamic> json) => GiftVO(
  id: json['_id'] as String?,
  code: json['code'] as String?,
  sender: json['sender'] as String?,
  receiver: json['receiver'] as String?,
  plan:
      json['plan'] == null
          ? null
          : PlanVO.fromJson(json['plan'] as Map<String, dynamic>),
  status: json['status'] as String?,
  subscription: json['subscription'] as String?,
  expiresAt:
      json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  redeemedAt:
      json['redeemedAt'] == null
          ? null
          : DateTime.parse(json['redeemedAt'] as String),
);

Map<String, dynamic> _$GiftVOToJson(GiftVO instance) => <String, dynamic>{
  '_id': instance.id,
  'code': instance.code,
  'sender': instance.sender,
  'receiver': instance.receiver,
  'plan': instance.plan,
  'status': instance.status,
  'subscription': instance.subscription,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'redeemedAt': instance.redeemedAt?.toIso8601String(),
};

PlanVO _$PlanVOFromJson(Map<String, dynamic> json) => PlanVO(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toInt(),
  currency: json['currency'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  status: json['status'] as bool?,
  isPopular: json['isPopular'] as bool?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PlanVOToJson(PlanVO instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'currency': instance.currency,
  'duration': instance.duration,
  'status': instance.status,
  'isPopular': instance.isPopular,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
