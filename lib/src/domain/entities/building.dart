import 'package:closed_map_constructor/src/domain/entities/floor.dart';
import 'package:closed_map_constructor/src/domain/entities/marker.dart';
import 'package:closed_map_constructor/src/domain/entities/room.dart';

class Building {
  final List<Floor> floors;
  final List<Room> rooms;
  final List<MarkerEntity> markers;

  const Building({
    this.floors = const [],
    this.rooms = const [],
    this.markers = const [],
  });
}

