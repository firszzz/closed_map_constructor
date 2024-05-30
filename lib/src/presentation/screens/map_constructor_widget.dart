import 'dart:math';

import 'package:closed_map_constructor/src/constants/tile_provider.dart';
import 'package:closed_map_constructor/src/data/repositories/header_data_repository.dart';
import 'package:closed_map_constructor/src/domain/entities/building.dart';
import 'package:closed_map_constructor/src/domain/entities/room.dart';
import 'package:closed_map_constructor/src/domain/usecases/get_header_option.dart';
import 'package:closed_map_constructor/src/modules/poly_editor.dart';
import 'package:closed_map_constructor/src/presentation/cubits/map_control/map_control_cubit.dart';
import 'package:closed_map_constructor/src/presentation/widgets/header_menu_widget.dart';
import 'package:closed_map_constructor/src/presentation/widgets/header_options.dart';
import 'package:closed_map_constructor/src/presentation/widgets/header_view_model.dart';
import 'package:closed_map_constructor/src/presentation/widgets/left_menu_widget.dart';
import 'package:closed_map_constructor/src/presentation/widgets/right_menu_widget.dart';
import 'package:flutter/cupertino.dart';
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

  /// FEFU MAP BADCODE EDITION ¯\_(ツ)_/¯

  Building newBuilding = const Building();

  late PolyEditor polyEditor;

  List<Room> rooms = [];

  List<Polygon> polygons = [
    Polygon(
      points: [],
      color: Colors.black,
      isFilled: true,
    ),
  ];

  final testPolygon = Polygon(
    color: Colors.black54,
    isFilled: true,
    points: [],
  );

  ///

  @override
  void initState() {
    final menuRepository = HeaderDataRepository();
    final getHeaderOptionsUseCase = GetHeaderOption(repository: menuRepository);
    viewModel = HeaderViewModel(getHeaderOptionsUseCase: getHeaderOptionsUseCase);

    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: const Icon(Icons.crop_square, size: 10),
      intermediateIcon: const Icon(Icons.lens, size: 9, color: Colors.black87),
      callbackRefresh: () => {setState(() {})},
    );

    polygons.add(testPolygon);

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
                  onTap: (_, ll) {
                    polyEditor.add(testPolygon.points, ll);
                  },
                ),
                children: [
                  mapboxMapTileLayer,
                  PolygonLayer(
                    polygons: polygons,
                    polygonLabels: true,
                  ),
                  DragMarkers(markers: polyEditor.edit()),
                ],
              ),
              Column(
                children: [
                  FractionallySizedBox(
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
                        widthFactor: 0.4,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              SizedBox(
                                width: 50,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  focusColor: const Color.fromARGB(127, 238, 238, 238),
                                  backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                                  child: const Icon(Icons.polyline,),
                                ),
                              ),
                              const SizedBox(width: 50,),
                              SizedBox(
                                width: 50,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  focusColor: const Color.fromARGB(127, 238, 238, 238),
                                  backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                                  child: const Icon(Icons.image_outlined,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LeftMenuWidget(
                          menuData: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: rooms.map((room) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    void removeRoom(List<Room> rooms, List<LatLng> polygonPoints) {
                                      for (final room in rooms) {
                                        final sortedRoomPoints = room.points.toList()..sort((a, b) => a.latitude.compareTo(b.latitude));
                                        final sortedPolygonPoints = polygonPoints.toList()..sort((a, b) => a.latitude.compareTo(b.latitude));

                                        if (sortedRoomPoints.length == sortedPolygonPoints.length &&
                                            sortedRoomPoints.every((roomPoint) => sortedPolygonPoints.contains(roomPoint))) {
                                          rooms.removeWhere((item) => item == room);
                                        }
                                      }
                                    }

                                    void removePolygon(List<Polygon> polygons, List<LatLng> polygonPoints) {
                                      polygons.removeWhere((polygon) {
                                        final sortedPolygonPoints = polygon.points.toList()..sort((a, b) => a.latitude.compareTo(b.latitude));
                                        final sortedRoomPoints = polygonPoints.toList()..sort((a, b) => a.latitude.compareTo(b.latitude));

                                        return sortedPolygonPoints.length == sortedRoomPoints.length &&
                                            sortedPolygonPoints.every((polygonPoint) => sortedRoomPoints.contains(polygonPoint));
                                      });
                                    }

                                    testPolygon.points.clear();

                                    removeRoom(rooms, room.points);
                                    removePolygon(polygons, room.points);

                                    testPolygon.points.addAll([...room.points]);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    height: 20,
                                    color: Colors.black45,
                                    child: Text(
                                        room.title
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const RightMenuWidget(menuData: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Text('propeties menu', style: TextStyle(color: Colors.black,),)],)),
                      ],
                    ),
                  )
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            if (testPolygon.points != [] && testPolygon.points.length != 1 && testPolygon.points.length != 2) {
                              Polygon newPolygon = Polygon(
                                points: [...testPolygon.points],
                                isFilled: testPolygon.isFilled,
                                color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                              );

                              rooms.add(
                                  Room(
                                    points: [...testPolygon.points],
                                    title: 'Полигон №${Random().nextInt(100)}',
                                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)].toString(),
                                  )
                              );

                              polygons.insert(polygons.length - 1, newPolygon);
                              testPolygon.points.clear();
                            }
                          });
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              )
            ]
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}


