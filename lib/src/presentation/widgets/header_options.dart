import 'package:closed_map_constructor/src/presentation/widgets/header_view_model.dart';
import 'package:flutter/material.dart';

class HeaderOptions extends StatefulWidget {
  final HeaderViewModel viewModel;

  const HeaderOptions({super.key, required this.viewModel});

  @override
  State<HeaderOptions> createState() => _HeaderOptionsState();
}

class _HeaderOptionsState extends State<HeaderOptions> {
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.viewModel.menuOptions.map((option) {
        final isSelected = _selectedIndex ==
            widget.viewModel.menuOptions.indexOf(option);
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = widget.viewModel.menuOptions.indexOf(option);
            });
            option.callback();
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: isSelected ? const Color.fromRGBO(255, 87, 61, 1) : const Color.fromRGBO(238, 238, 238, 1),
              ),
              child: option.icon,
            ),
          ),
        );
      }).toList(),
    );
  }
}
