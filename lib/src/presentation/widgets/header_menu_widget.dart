import 'package:flutter/material.dart';

class HeaderMenu extends StatefulWidget {
  const HeaderMenu({super.key, this.headerData});

  final Widget? headerData;

  @override
  State<HeaderMenu> createState() => _HeaderMenuState();
}

class _HeaderMenuState extends State<HeaderMenu> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1,
              )
          ),
        ),
        child: FractionallySizedBox(
          widthFactor: 0.3,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: widget.headerData,
            ),
          ),
        ),
      ),
    );
  }
}