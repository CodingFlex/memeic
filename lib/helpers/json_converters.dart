import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memeic/helpers/value_parser.dart';

class DoubleParserConverter implements JsonConverter<double, Object?> {
  const DoubleParserConverter();

  @override
  double fromJson(Object? json) {
    return ValueParser.toDouble(json, defaultValue: 0.0);
  }

  @override
  Object? toJson(double object) => object;
}
