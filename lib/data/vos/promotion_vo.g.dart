// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionVo _$PromotionVoFromJson(Map<String, dynamic> json) => PromotionVo(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  discount: (json['discount'] as num?)?.toInt(),
  status: json['status'] as bool?,
);

Map<String, dynamic> _$PromotionVoToJson(PromotionVo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'discount': instance.discount,
    };
