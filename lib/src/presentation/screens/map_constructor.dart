import 'package:closed_map_constructor/closed_map_constructor.dart';
import 'package:closed_map_constructor/src/presentation/cubits/map_control/map_control_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapConstructor extends StatefulWidget {
  const MapConstructor({super.key});

  @override
  State<MapConstructor> createState() => _MapConstructorState();
}

class _MapConstructorState extends State<MapConstructor> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapControlCubit>(
      create: (context) => MapControlCubit(),
      child: const MapConstructorWidget(),
    );
  }
}
