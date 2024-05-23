import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';

class ImageEditor {
  final List<LatLng> points;
  final Function? callbackRefresh;
  final Widget pointIcon;
  final Size pointIconSize;

  ImageEditor({
    required this.points,
    this.callbackRefresh,
    this.pointIcon = const Icon(Icons.square_outlined),
    this.pointIconSize = const Size(30, 30),
  });

  int? _markerToUpdate;

  void updateMarker(details, LatLng point) {
    if (_markerToUpdate != null) {
      points[_markerToUpdate!] = LatLng(point.latitude, point.longitude);
    }

    callbackRefresh?.call();
  }

  List add(List<LatLng> pointsList, List<LatLng> points) {
    pointsList.addAll(points);
    callbackRefresh?.call();

    return pointsList;
  }

  List<DragMarker> edit() {
    List<DragMarker> markersList = [];

    for (var i = 0; i < points.length; i++) {
      final indexClosure = i;
      markersList.add(DragMarker(
        point: points[i],
        size: pointIconSize,
        builder: (_, __, ___) => pointIcon,
        onDragStart: (_, __) => _markerToUpdate = indexClosure,
        onDragUpdate: updateMarker,
      ));
    }

    return markersList;
  }
}