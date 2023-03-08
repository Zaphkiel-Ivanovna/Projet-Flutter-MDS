import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projet_flutter_mds/repositories/arrets_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final arretsRepository = ArretsRepository();
  await arretsRepository.init();
  runApp(MyApp(arretsRepository: arretsRepository));
}

class MyApp extends StatefulWidget {
  final ArretsRepository arretsRepository;

  const MyApp({Key? key, required this.arretsRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MarkerLayer markerLayerOptions = const MarkerLayer(markers: []);
  late Map<String, dynamic> _arretsData;
  late List<LatLng> _arretsCoords;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _arretsData = widget.arretsRepository.arretsData;

    _arretsCoords = _arretsData["records"]
        .map<LatLng>((record) => LatLng(record["geometry"]["coordinates"][1],
            record["geometry"]["coordinates"][0]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon application',
      home: Scaffold(
        body: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(47.4667, -0.55),
                  zoom: 13.0,
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
            TextButton(
              child: const Text('Ajouter des marqueurs'),
              onPressed: () {
                addMarkers(_arretsCoords);
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Carte',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
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
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: const Center(
              child: Icon(
                Icons.location_pin,
                color: Color.fromARGB(255, 253, 0, 0),
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
