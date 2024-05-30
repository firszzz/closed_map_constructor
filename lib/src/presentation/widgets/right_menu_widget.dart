import 'package:flutter/material.dart';

class RightMenuWidget extends StatefulWidget {
  final Widget? menuData;

  const RightMenuWidget({super.key, required this.menuData});

  @override
  State<RightMenuWidget> createState() => _RightMenuWidgetState();
}

class _RightMenuWidgetState extends State<RightMenuWidget> {
  double menuWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_rounded, size: 15,),
                ),
              ),
            ],
          ) : const SizedBox.shrink(),
          menuWidth != 0 ? Row(
            children: [
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    if (menuWidth - details.delta.dx >= 0 && menuWidth - details.delta.dx <= 450) {
                      menuWidth -= details.delta.dx;
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
              Container(
                width: menuWidth,
                color: Colors.white,
                child: widget.menuData,
              ),
            ],
          ) : const SizedBox.shrink(),
        ]
    );
  }
}
