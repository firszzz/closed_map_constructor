import 'dart:math';

import 'package:closed_map_constructor/src/constants/tile_provider.dart';
import 'package:closed_map_constructor/src/data/repositories/header_data_repository.dart';
import 'package:closed_map_constructor/src/domain/usecases/get_header_option.dart';
import 'package:closed_map_constructor/src/presentation/cubits/map_control/map_control_cubit.dart';
import 'package:closed_map_constructor/src/presentation/widgets/header_menu_widget.dart';
import 'package:closed_map_constructor/src/presentation/widgets/header_options.dart';
import 'package:closed_map_constructor/src/presentation/widgets/header_view_model.dart';
import 'package:closed_map_constructor/src/presentation/widgets/left_menu_widget.dart';
import 'package:closed_map_constructor/src/presentation/widgets/right_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';

class MapConstructorWidget extends StatefulWidget {
  const MapConstructorWidget({super.key});

  @override
  State<MapConstructorWidget> createState() => _MapConstructorWidgetState();
}

class _MapConstructorWidgetState extends State<MapConstructorWidget> {
  late HeaderViewModel viewModel;

  @override
  void initState() {
    final menuRepository = HeaderDataRepository();
    final getHeaderOptionsUseCase = GetHeaderOption(repository: menuRepository);
    viewModel = HeaderViewModel(getHeaderOptionsUseCase: getHeaderOptionsUseCase);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapControlCubit, MapControlState>(
      builder: (context, mapState) {
        if (mapState.status == Status.initial) {
          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialZoom: mapState.initialZoom,
                  maxZoom: mapState.maxZoom,
                  initialCenter: const LatLng(43.024963, 131.892528),
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      context.read<MapControlCubit>().setZoom(position.zoom);
                    }
                  },
                ),
                children: [
                  mapboxMapTileLayer,
                ],
              ),
              Column(
                children: [
                  HeaderMenu(headerData: HeaderOptions(viewModel: viewModel)),
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LeftMenuWidget(menuData: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Text('left menu', style: TextStyle(color: Colors.black,),),],)),
                        RightMenuWidget(menuData: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Text('right menu', style: TextStyle(color: Colors.black,),)],)),
                      ],
                    ),
                  )
                ],
              ),
            ]
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}


