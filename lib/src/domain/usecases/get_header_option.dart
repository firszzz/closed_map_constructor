import 'package:closed_map_constructor/src/data/repositories/header_data_repository.dart';
import 'package:closed_map_constructor/src/domain/entities/header_option.dart';

class GetHeaderOption {
  final HeaderDataRepository repository;

  GetHeaderOption({required this.repository});

  Future<List<HeaderOption>> execute() async {
    return await repository.getHeaderOptions();
  }
}