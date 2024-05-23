import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class Floor extends Equatable {
  final int number;
  final List<LatLng> points;

  const Floor({
    required this.number,
    required this.points,
  });

  @override
  List<Object> get props => [number, points];


}
