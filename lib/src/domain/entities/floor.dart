import 'dart:math';

import 'package:closed_map_constructor/src/domain/entities/room.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Floor extends Equatable {
  final int number;
  final List<Room> rooms;
  final List<LatLng> points;

  const Floor({
    required this.number,
    required this.rooms,
    required this.points,
  });

  void addRoom(Room room) {
    rooms.add(room);
  }

  List<Polygon> parseRoomsToPolygons(List<Room> roomsList) {
    List<Polygon> polygons = [];

    roomsList.forEach((room) {
      polygons.add(Polygon(
        points: room.points,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        isFilled: true,
      ));
    });

    return polygons;
  }

  @override
  List<Object> get props => [number, points];
}