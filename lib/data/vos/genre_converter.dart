import 'package:json_annotation/json_annotation.dart';
import 'genre_vo.dart';

class GenreListConverter implements JsonConverter<List<GenreVO>?, dynamic> {
  const GenreListConverter();

  @override
  List<GenreVO>? fromJson(dynamic json) {
    if (json is List) {
      return json.map<GenreVO>((item) {
        if (item is String) {
          return GenreVO(name: item);
        } else if (item is Map<String, dynamic>) {
          return GenreVO.fromJson(item);
        }
        throw Exception('Unexpected genre item: $item');
      }).toList();
    }
    return null;
  }

  @override
  dynamic toJson(List<GenreVO>? genres) =>
      genres?.map((g) => g.toJson()).toList();
}
