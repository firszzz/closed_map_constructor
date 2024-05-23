import 'package:flutter/material.dart';
import 'package:closed_map_constructor/closed_map_constructor.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: MapConstructor()),
  ));
}