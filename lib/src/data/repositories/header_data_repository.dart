import 'package:closed_map_constructor/src/domain/entities/header_option.dart';
import 'package:flutter/material.dart';

class HeaderDataRepository {
  Future<List<HeaderOption>> getHeaderOptions() async {
    return[
      /// TODO Control map option
      HeaderOption(
        icon: const Icon(Icons.ads_click, color: Colors.black, ),
        callback: () {
          print('select option');
        },
      ),

      /// Polygon option
      HeaderOption(
        icon: const Icon(Icons.polyline, color: Colors.black,),
        callback: () {
          print('polygon option');
        }
      ),

      /// TODO Image option
      HeaderOption(
        icon: const Icon(Icons.image_outlined, color: Colors.black,),
        callback: () {
          print('image option');
        },
      ),

      /// TODO Marker option
      HeaderOption(
        icon: const Icon(Icons.icecream_sharp, color: Colors.black,),
        callback: () {
          print('marker option');
        },
      ),

      /// TODO Stairs option
      HeaderOption(
        icon: const Icon(Icons.stairs_outlined, color: Colors.black,),
        callback: () {
          print('stairs option');
        },
      ),

      /// TODO Wall option
      HeaderOption(
        icon: const Icon(Icons.wallet_outlined, color: Colors.black,),
        callback: () {
          print('wall option');
        },
      ),
    ];
  }
}