import 'package:closed_map_constructor/src/domain/entities/header_option.dart';

abstract interface class HeaderRepository {
  Future<List<HeaderOption>> getHeaderOptions();
}