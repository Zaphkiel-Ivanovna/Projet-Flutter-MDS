import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class ItineraryScreen extends StatelessWidget {
  final List<LatLng> coordinates;
  final String ligneName;
  ItineraryScreen(
      {Key? key, required this.coordinates, required this.ligneName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ligneName),
        backgroundColor: Color(0xFF8B0000),
      ),
      body: FlutterMap(
        options: MapOptions(
          center:
              coordinates.isNotEmpty ? coordinates.first : LatLng(47.47, -0.55),
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          zoom: 13.0,
          maxZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: coordinates,
                strokeWidth: 4.0,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
