import 'package:closed_map_constructor/src/domain/usecases/get_header_option.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/header_option.dart';

class HeaderViewModel extends ChangeNotifier {
  final GetHeaderOption getHeaderOptionsUseCase;
  List<HeaderOption> _menuOptions = [];

  HeaderViewModel({required this.getHeaderOptionsUseCase}) {
    _loadMenuOptions();
  }

  List<HeaderOption> get menuOptions => _menuOptions;

  Future<void> _loadMenuOptions() async {
    _menuOptions = await getHeaderOptionsUseCase.execute();
    notifyListeners();
  }
}