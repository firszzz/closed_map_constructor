import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

TileLayer get openStreetMapTileLayer => TileLayer(
  tileProvider: CancellableNetworkTileProvider(),
  maxNativeZoom: 18,
  maxZoom: 25,
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  subdomains: const ['a', 'b', 'c'],
);

TileLayer get jawqMapTileLayer => TileLayer(
  maxNativeZoom: 18,
  maxZoom: 25,
  tileProvider: CancellableNetworkTileProvider(),
  urlTemplate:
  'https://{s}.tile.jawg.io/jawg-dark/{z}/{x}/{y}{r}.png?access-token=MHAPZKXUyIRzWFWmeocWBRt703TlxIBUfmo1bnR7VLf51SSnZqfNMCHMH93WukNM&lang=locale',
);

TileLayer get mapboxMapTileLayer => TileLayer(
  urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoidG1jdyIsImEiOiJja2twd25qdWowMXBuMnVxdDZodXJzaDZoIn0.UL4e2OtC7xrGr9hohU1odg',
  maxNativeZoom: 18,
  maxZoom: 25,
  tileProvider: CancellableNetworkTileProvider(),
);
