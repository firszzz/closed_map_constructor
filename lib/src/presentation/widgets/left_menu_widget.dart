import 'package:flutter/material.dart';

class LeftMenuWidget extends StatefulWidget {
  final Widget? menuData;

  const LeftMenuWidget({super.key, required this.menuData});

  @override
  State<LeftMenuWidget> createState() => _LeftMenuWidgetState();
}

class _LeftMenuWidgetState extends State<LeftMenuWidget> {
  double menuWidth = 250;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          menuWidth != 0 ? Row(
            children: [
              Container(
                width: menuWidth,
                color: Colors.white,
                child: widget.menuData,
              ),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    if (menuWidth + details.delta.dx >= 0 && menuWidth + details.delta.dx <= 450) {
                      menuWidth += details.delta.dx;
                    }
                  });
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    if (menuWidth < 75) {
                      menuWidth = 0;
                    }
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: Container(
                    width: 5,
                    decoration: const BoxDecoration(
                      border: Border.symmetric(vertical: BorderSide()),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ) : const SizedBox.shrink(),
          menuWidth == 0 ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    menuWidth = 250;
                  });
                },
                child: Container(
                  width: 15,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded, size: 15,),
                ),
              ),
            ],
          ) : const SizedBox.shrink(),
        ]
    );
  }
}
