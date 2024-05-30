import 'dart:io';
import 'dart:math';

import 'package:closed_map_constructor/src/constants/tile_provider.dart';
import 'package:closed_map_constructor/src/data/repositories/header_data_repository.dart';
import 'package:closed_map_constructor/src/domain/entities/building.dart';
import 'package:closed_map_constructor/src/domain/entities/floor.dart';
import 'package:closed_map_constructor/src/domain/entities/room.dart';
import 'package:closed_map_constructor/src/domain/usecases/get_header_option.dart';
import 'package:closed_map_constructor/src/modules/image_editor.dart';
import 'package:closed_map_constructor/src/modules/poly_editor.dart';
import 'package:closed_map_constructor/src/presentation/cubits/map_control/map_control_cubit.dart';
import 'package:closed_map_constructor/src/presentation/widgets/header_view_model.dart';
import 'package:closed_map_constructor/src/presentation/widgets/left_menu_widget.dart';
import 'package:closed_map_constructor/src/presentation/widgets/right_menu_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class MapConstructorWidget extends StatefulWidget {
  const MapConstructorWidget({super.key});

  @override
  State<MapConstructorWidget> createState() => _MapConstructorWidgetState();
}

class _MapConstructorWidgetState extends State<MapConstructorWidget> {
  late HeaderViewModel viewModel;
  late MapController controller;

  /// FEFU MAP BADCODE EDITION ¯\_(ツ)_/¯
  int? currFloor;

  Building newBuilding = const Building();

  final textController = TextEditingController();

  late PolyEditor polyEditor;

  late ImageEditor imageEditor;
  LatLng? controllerCenter;
  File? pickedImage;
  Uint8List? webImage;
  bool imageSelected = false;
  RotatedOverlayImage? rotatedOverlayImage;
  List<LatLng> imagePoints = [];
  double opacity = 0.75;

  List<Room> rooms = [];
  List<Floor> floors = [];

  List<Polygon> polygons = [
    Polygon(
      color: Colors.blue,
      isFilled: true,
      points: [],
    )
  ];

  Polygon testPolygon = Polygon(
    color: Colors.yellow,
    isFilled: true,
    points: [],
  );

  ///

  @override
  void initState() {
    controller = MapController();

    final menuRepository = HeaderDataRepository();
    final getHeaderOptionsUseCase = GetHeaderOption(repository: menuRepository);
    viewModel = HeaderViewModel(getHeaderOptionsUseCase: getHeaderOptionsUseCase);

    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: const Icon(Icons.lens, size: 12, color: Color.fromRGBO(255, 87, 61, 1),),
      intermediateIcon: const Icon(Icons.lens, size: 9, color: Color.fromRGBO(255, 87, 61, 1)),
      callbackRefresh: () => {setState(() {})},
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          pickedImage = selected;
        });
      } else {
        debugPrint('no image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = await image.readAsBytes();

        setState(() {
          webImage = selected;
          pickedImage = File('nothing');
        });
      } else {
        debugPrint('no image has been picked');
      }
    } else {
      debugPrint('not mobile and web version used.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapControlCubit, MapControlState>(
      builder: (context, mapState) {
        if (mapState.status == Status.initial) {
          return Stack(
            children: [
              FlutterMap(
                mapController: controller,
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
                    if (currFloor != null && floors.any((floor) => floor.number == currFloor) && !imageSelected) {
                      polyEditor.add(testPolygon.points, ll);
                    }
                  },
                ),
                children: [
                  mapboxMapTileLayer,
                  (webImage != null && rotatedOverlayImage != null) ? GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        imageSelected = !imageSelected;
                      });
                    },
                    child: OverlayImageLayer(
                      overlayImages: [
                        rotatedOverlayImage!
                      ],
                    ),
                  ) : const SizedBox(height: 10, width: 10),
                  PolygonLayer(
                    polygons: polygons,
                    polygonLabels: true,
                  ),
                  (webImage != null && rotatedOverlayImage != null && imageSelected) ? DragMarkers(markers: imageEditor.edit()) : DragMarkers(markers: polyEditor.edit()),
                ],
              ),
              ///menu
              Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 100,
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
                              /*const SizedBox(width: 10,),
                              SizedBox(
                                width: 50,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  focusColor: const Color.fromARGB(127, 238, 238, 238),
                                  backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                                  child: const Icon(Icons.polyline,),
                                ),
                              ),*/
                              const SizedBox(width: 10,),
                              SizedBox(
                                width: 50,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    if (webImage != null) {
                                      setState(() {
                                        webImage = null;
                                        opacity = 0.75;
                                        imageSelected = false;
                                      });
                                    }
                                    else {
                                      await _pickImage();

                                      setState(() {
                                        controllerCenter = controller.camera.center;

                                        imagePoints = [
                                          LatLng(controllerCenter!.latitude + 0.002, controllerCenter!.longitude),
                                          LatLng(controllerCenter!.latitude, controllerCenter!.longitude),
                                          LatLng(controllerCenter!.latitude, controllerCenter!.longitude + 0.004),
                                        ];

                                        rotatedOverlayImage = RotatedOverlayImage(
                                          imageProvider: MemoryImage(webImage!),
                                          opacity: opacity,
                                          topLeftCorner: imagePoints[0],
                                          bottomLeftCorner: imagePoints[1],
                                          bottomRightCorner: imagePoints[2],
                                        );
                                      });

                                      imageEditor = ImageEditor(
                                          points: imagePoints,
                                          callbackRefresh: () => {
                                            setState(() {
                                              rotatedOverlayImage = RotatedOverlayImage(
                                                imageProvider: MemoryImage(webImage!),
                                                opacity: opacity,
                                                topLeftCorner: imagePoints[0],
                                                bottomLeftCorner: imagePoints[1],
                                                bottomRightCorner: imagePoints[2],
                                              );
                                            })
                                          }
                                      );
                                    }
                                  },
                                  focusColor: const Color.fromARGB(127, 238, 238, 238),
                                  backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                                  child: webImage != null ? const Icon(Icons.image_not_supported_outlined) : const Icon(Icons.image_outlined,),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              webImage != null ? SizedBox(
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Slider(
                                        min: 0.01,
                                        max: 0.99,
                                        value: opacity,
                                        onChanged: (double value) {
                                          setState(() {
                                            opacity = value;
                                          });
                                          imageEditor.callbackRefresh!();
                                        }
                                    )
                                  ],
                                ),
                              ): const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      /// left/right
                      children: [
                        LeftMenuWidget(
                          menuData: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: double.infinity,
                                      child: const Text(
                                        'ЗДАНИЕ',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Column(
                                      children: floors.map((floor) {
                                        return Column(
                                          children: [
                                            Container(
                                              color: floor.number == currFloor ? const Color.fromRGBO(255, 87, 61, 1) : Colors.transparent,
                                              width: double.infinity,
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      currFloor = floor.number;

                                                      List<Room> floorRooms = [];

                                                      rooms.forEach((room) {
                                                        if (room.floor == currFloor) {
                                                          floorRooms.add(room);
                                                        }
                                                      });

                                                      polygons = floor.parseRoomsToPolygons(floorRooms);
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(
                                                      '— ЭТАЖ ${floor.number}',
                                                      textAlign: TextAlign.start,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: rooms.map((room) {
                                                return MouseRegion(
                                                  cursor: SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {

                                                        //change floor polygons code
                                                        currFloor = floor.number;

                                                        List<Room> floorRooms = [];

                                                        rooms.forEach((room) {
                                                          if (room.floor == currFloor) {
                                                            floorRooms.add(room);
                                                          }
                                                        });

                                                        polygons = floor.parseRoomsToPolygons(floorRooms);
                                                        //

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

                                                        void removeFloorRoom(List<Polygon> polygons, List<LatLng> polygonPoints) {
                                                          floors.forEach((floor) {
                                                            floor.rooms.removeWhere((room) {
                                                              final sortedPolygonPoints = room.points.toList()..sort((a, b) => a.latitude.compareTo(b.latitude));
                                                              final sortedRoomPoints = polygonPoints.toList()..sort((a, b) => a.latitude.compareTo(b.latitude));

                                                              return sortedPolygonPoints.length == sortedRoomPoints.length &&
                                                                  sortedPolygonPoints.every((polygonPoint) => sortedRoomPoints.contains(polygonPoint));
                                                            });
                                                          });
                                                        }

                                                        testPolygon.points.clear();

                                                        removeRoom(rooms, room.points);
                                                        removePolygon(polygons, room.points);
                                                        removeFloorRoom(polygons, room.points);

                                                        testPolygon.points.addAll([...room.points]);
                                                      });
                                                    },
                                                    child: room.floor == floor.number ? SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        '—— ${room.title}',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ) : const SizedBox.shrink(),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ),
                        ),
                        // const RightMenuWidget(menuData: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Text('propeties menu', style: TextStyle(color: Colors.black,),)],)),
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
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _openBuildingCreator();
                          });
                        },
                        focusColor: const Color.fromARGB(127, 238, 238, 238),
                        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                        child: const Icon(Icons.house),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            if (testPolygon.points.isNotEmpty && testPolygon.points.length != 1 && testPolygon.points.length != 2) {
                              Polygon newPolygon = Polygon(
                                points: [...testPolygon.points],
                                isFilled: testPolygon.isFilled,
                                color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                              );

                              Room newRoom = Room(
                                points: [...testPolygon.points],
                                title: 'Полигон №${Random().nextInt(100)}',
                                color: Colors.primaries[Random().nextInt(Colors.primaries.length)].toString(),
                                floor: currFloor,
                              );

                              rooms.add(
                                newRoom,
                              );

                              floors.forEach((floor) {
                                if (floor.number == currFloor) {
                                  floor.addRoom(newRoom);
                                }
                              });

                              polygons.insert(polygons.length, newPolygon);

                              testPolygon.points.clear();
                            }
                          });
                        },
                        focusColor: const Color.fromARGB(127, 238, 238, 238),
                        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
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

  void _openBuildingCreator() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добавление этажа',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),
            TextField(
              decoration: const InputDecoration(
                labelText: "Введите номер этажа",
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              cursorColor: const Color.fromRGBO(255, 87, 61, 1),
            ),
            const SizedBox(height: 40,),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(255, 87, 61, 1),
                  onPressed: () {
                    setState(() {
                      if (textController.value.text != '') {
                        floors.add(
                          Floor(
                            number: int.parse(textController.value.text),
                            rooms: rooms.where((element) => element.floor == int.parse(textController.value.text)).toList(),
                            points: const [],
                          ),
                        );

                        Navigator.pop(context);
                        textController.clear();
                      }
                    });
                  },
                  child: const Text(
                    'Добавить этаж', style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(255, 87, 61, 1),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть', style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




