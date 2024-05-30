import 'package:latlong2/latlong.dart';

class Room {
  final String title;
  final String color;
  final List<LatLng> points;

  const Room({
    this.title = "Комната",
    this.color = '#000000',
    required this.points,
  });
}
