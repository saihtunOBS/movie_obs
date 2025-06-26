import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';

extension Gap on num {
  SizedBox get vGap => SizedBox(height: toDouble());
  SizedBox get hGap => SizedBox(width: toDouble());
}

extension DateFormatting on DateTime {
  String toFormattedString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}

String getDeviceType() {
  // ignore: deprecated_member_use
  final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}

extension StringValidators on String {
  bool get containsUppercase => contains(RegExp(r'[A-Z]'));
  bool get containsLowercase => contains(RegExp(r'[a-z]'));
  bool get containsNumber => contains(RegExp(r'[0-9]'));
  bool get moreThan8Character => length >= 8;
  bool get containsSpecialCharacter =>
      contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}

extension DurationClamp on Duration {
  Duration clamp(Duration min, Duration max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}

extension MovieVOMapper on MovieVO {
  MovieDetailResponse toDetail() {
    return MovieDetailResponse(
      id: id,
      name: name,
      description: description,
      posterImageUrl: posterImageUrl,
      isWatchlist: isWatchlist,
      duration: duration,
      payPerViewPrice: payPerViewPrice,
      genres: genres,
      director: director,
      plan: plan,
    );
  }
}
