part of 'map_control_cubit.dart';

enum Status {
  initial,
  loading,
  loaded,
  error,
  empty,
}

class MapControlState extends Equatable {
  final Status status;
  final double initialZoom;
  final double maxZoom;
  final double currentZoom;
  final double minZoomForPolygons;

  const MapControlState({
    this.status = Status.initial,
    this.initialZoom = 15.0,
    this.maxZoom = 27,
    this.currentZoom = 15,
    this.minZoomForPolygons = 18,
  });

  MapControlState copyWith({
    double? initialZoom,
    double? maxZoom,
    double? currentZoom,
    double? minZoomForPolygons,
  }) {
    return MapControlState(
      initialZoom: initialZoom ?? this.initialZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      currentZoom: currentZoom ?? this.currentZoom,
      minZoomForPolygons: minZoomForPolygons ?? this.minZoomForPolygons,
    );
  }

  @override
  List<Object> get props => [
    initialZoom,
    maxZoom,
    currentZoom,
  ];
}
