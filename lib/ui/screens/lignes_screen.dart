import 'package:flutter/material.dart';
import '../../repositories/lignes_repository.dart';
import '../../models/lignes.dart';

class LignesScreen extends StatefulWidget {
  final LignesRepository lignesRepository;
  LignesScreen({Key? key, required this.lignesRepository}) : super(key: key);

  @override
  State<LignesScreen> createState() => _LigneScreenState();
}

class _LigneScreenState extends State<LignesScreen> {
  late Future<List<Lignes>> _lignesData;

  @override
  void initState() {
    super.initState();
    _lignesData = _performSearch();
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
                onChanged: (value) async {},
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Lignes>>(
                future: _lignesData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child:
                            Text('Erreur lors de la récupération des données'));
                  }
                  final lignes = snapshot.data!;
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
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Lignes>> _performSearch() async {
    final response = await widget.lignesRepository.fetchData();
    final records = response['records'];
    return records
        .map<Lignes>((record) => Lignes.fromJson(record['fields']))
        .toList();
  }
}
