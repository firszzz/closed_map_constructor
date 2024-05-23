import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_control_state.dart';

class MapControlCubit extends Cubit<MapControlState> {
  MapControlCubit() : super(const MapControlState());

  void setZoom(double? zoom) {
    emit(state.copyWith(currentZoom: zoom));
  }
}
