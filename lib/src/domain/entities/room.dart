import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Room {
  final String title;
  final Color color;
  final List<LatLng> points;

  const Room({
    this.title = "Комната",
    this.color = Colors.blue,
    required this.points,
  });
}
