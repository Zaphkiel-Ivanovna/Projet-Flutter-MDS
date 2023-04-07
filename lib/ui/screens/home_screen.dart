// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:herewego/repositories/arrets_repository.dart';
import 'package:herewego/utils/map_utils.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class Home extends StatefulWidget {
  final ArretsRepository arretsRepository;

  const Home({Key? key, required this.arretsRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Home> with TickerProviderStateMixin {
  MarkerLayer markerLayerOptions = const MarkerLayer(markers: []);
  Map<String, dynamic> _arretsData = {};
  List<LatLng> _arretsCoords = [];
  final MapController _mapController = MapController();
  late ByteData _busPinData;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBusPin();
  }

  Future<void> _loadBusPin() async {
    _busPinData = await rootBundle.load('lib/assets/bus-station.svg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Container(
            color: Color(0xFFF2F2F2),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(47.4667, -0.55),
                zoom: 13.0,
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                markerLayerOptions,
              ],
            ),
          ),
        ),
        Container(
          color: Color(0xFF8B0000),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un arrêt',
              filled: true,
              fillColor: Color(0xFF600000),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
            onSubmitted: (String value) {
              _performSearch(value);
            },
          ),
        ),
      ],
    ));
  }

  void _performSearch(String query) async {
    if (query.isEmpty || query.length < 4) {
      return;
    }

    _arretsData = await widget.arretsRepository.fetchData(query: query);
    _arretsCoords = _arretsData["records"]
        .map<LatLng>((record) => LatLng(record["geometry"]["coordinates"][1],
            record["geometry"]["coordinates"][0]))
        .toList();
    addMarkers(_arretsCoords);
    if (_arretsCoords.isNotEmpty) {
      animatedMapMove(
        _mapController,
        _arretsCoords.first,
        18.0,
        this,
      );
    }
  }

  void addMarkers(List<LatLng> points) {
    final markers = <Marker>[];
    for (var point in points) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: point,
          builder: (ctx) => Container(
            child: SvgPicture.memory(
              _busPinData.buffer.asUint8List(),
              width: 5.0,
              height: 5.0,
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
