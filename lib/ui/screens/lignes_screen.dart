import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:projet_flutter_mds/provider/lignes_provider.dart';
import 'package:projet_flutter_mds/ui/screens/itinerary_screen.dart';
import '../../repositories/lignes_repository.dart';
import '../../models/lignes.dart';

class LignesScreen extends StatefulWidget {
  final LignesRepository lignesRepository;
  LignesScreen({Key? key, required this.lignesRepository}) : super(key: key);

  @override
  State<LignesScreen> createState() => _LigneScreenState();
}

class _LigneScreenState extends State<LignesScreen> {
  final ValueNotifier<List<Lignes>> _lignesData =
      ValueNotifier<List<Lignes>>([]);
  late List<Lignes> _allLignes;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _fetchData().then((lignes) {
      _lignesData.value = lignes;
      _allLignes = lignes;
      _isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000),
        title: Text('Lignes de transport'),
      ),
      body: Container(
        color: Color(0xFFF2F2F2),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une ligne',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) async {
                  _updateLignesList(value);
                },
              ),
            ),
            Expanded(
              child: Stack(children: [
                ValueListenableBuilder<List<Lignes>>(
                  valueListenable: _lignesData,
                  builder: (context, lignes, child) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(int.parse(
                                    '0xFF${lignes[index].route_color}')),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  lignes[index].route_short_name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(lignes[index].route_long_name),
                            trailing: IconButton(
                              icon: Icon(
                                lignes[index].isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: lignes[index].isFavorite
                                    ? Colors.red
                                    : null,
                              ),
                              onPressed: () {
                                Provider.of<Lignesnotifier>(context,
                                        listen: false)
                                    .toggleFavorite(lignes[index], index);
                              },
                            ),
                            onTap: () {
                              var coordinates = lignes[index]
                                  .coordinates
                                  .map((coords) => LatLng(coords[1], coords[0]))
                                  .toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItineraryScreen(
                                    coordinates: coordinates,
                                    ligneName: lignes[index].route_long_name,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8);
                      },
                      itemCount: lignes.length,
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isLoading,
                  builder: (context, isLoading, child) {
                    if (isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Lignes>> _fetchData() async {
    final response = await widget.lignesRepository.fetchData();
    _allLignes = response
        .map<Lignes>((record) => Lignes.fromJson(record.route_long_name,
            record.route_short_name, record.route_color, record.coordinates))
        .toList();
    return _allLignes;
  }

  void _updateLignesList(String query) {
    _lignesData.value = _allLignes.where((ligne) {
      return ligne.route_long_name
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          ligne.route_short_name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
