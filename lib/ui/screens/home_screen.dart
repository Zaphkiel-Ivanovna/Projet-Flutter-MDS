// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projet_flutter_mds/repositories/arrets_repository.dart';

class Home extends StatefulWidget {
  final ArretsRepository arretsRepository;

  const Home({Key? key, required this.arretsRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> {
  MarkerLayer markerLayerOptions = const MarkerLayer(markers: []);
  Map<String, dynamic> _arretsData = {};
  List<LatLng> _arretsCoords = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // _arretsData = widget.arretsRepository.arretsData;

    // _arretsCoords = _arretsData["records"]
    //     .map<LatLng>((record) => LatLng(record["geometry"]["coordinates"][1],
    //         record["geometry"]["coordinates"][0]))
    //     .toList();
  }

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        body: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: _mapController, // Ajoutez cette ligne
                options: MapOptions(
                  center: LatLng(47.4667, -0.55),
                  zoom: 13.0,
                  maxZoom: 19.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  markerLayerOptions,
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Recherche',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onSubmitted: (String value) {
                        _performSearch(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _performSearch(_searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      );
  }

  void _performSearch(String query) async {
    _arretsData = await widget.arretsRepository.fetchData(query: query);
    _arretsCoords = _arretsData["records"]
        .map<LatLng>((record) => LatLng(record["geometry"]["coordinates"][1],
            record["geometry"]["coordinates"][0]))
        .toList();
    addMarkers(_arretsCoords);
    if (_arretsCoords.isNotEmpty) {
      _mapController.move(_arretsCoords.first, 18.0);
    }
  }

  void addMarkers(List<LatLng> points) {
    final List<Marker> markers = [];
    for (LatLng point in points) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: point,
          builder: (ctx) => Container(
            // decoration: BoxDecoration(
            //   color: Colors.blue.withOpacity(0.7),
            //   borderRadius: BorderRadius.circular(100.0),
            // ),
            child: const Center(
              child: Icon(
                Icons.location_pin,
                color: Color.fromARGB(255, 228, 61, 61),
                size: 40.0,
              ),
            ),
          ),
        ),
      );
    }

    setState(() {
      markerLayerOptions = MarkerLayer(markers: markers);
    });
  }
}