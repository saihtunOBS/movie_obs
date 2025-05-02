// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqVO _$FaqVOFromJson(Map<String, dynamic> json) => FaqVO(
  id: json['_id'] as String?,
  question: json['question'] as String?,
  answer: json['answer'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  version: (json['__v'] as num?)?.toInt(),
);

Map<String, dynamic> _$FaqVOToJson(FaqVO instance) => <String, dynamic>{
  '_id': instance.id,
  'question': instance.question,
  'answer': instance.answer,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  '__v': instance.version,
};
