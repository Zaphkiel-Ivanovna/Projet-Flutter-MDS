import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:herewego/models/lignes.dart';

class LignesRepository {
  Future<List<Lignes>> fetchData() async {
    var lignesList = <Lignes>[];
    final response = await http.get(Uri.parse(
        'https://data.angers.fr/api/records/1.0/search/?dataset=irigo_gtfs_lines&rows=-1&facet=nomcourtligne&facet=numeroligne'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> infoLignes = json['records'];
      for (int i = 0; i < infoLignes.length; i++) {
        lignesList.add(Lignes.fromJson(
            infoLignes[i]['fields']['route_id'].toString(),
            infoLignes[i]['fields']['route_long_name'].toString(),
            infoLignes[i]['fields']['route_short_name'].toString(),
            infoLignes[i]['fields']['route_color'].toString(),
            infoLignes[i]['fields']['shape']['coordinates']));
      }
      return lignesList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Lignes>> searchData(String search) async {
    List<Lignes> lignesList = [];
    final response = await http.get(Uri.parse(
        'https://data.angers.fr/api/records/1.0/search/?dataset=irigo_gtfs_lines&q=$search'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> infoLignes = json['records'];
      for (var i = 0; i < infoLignes.length; i++) {
        lignesList.add(Lignes.fromJson(
            infoLignes[i]['fields']['route_id'].toString(),
            infoLignes[i]['fields']['route_long_name'].toString(),
            infoLignes[i]['fields']['route_short_name'].toString(),
            infoLignes[i]['fields']['route_color'].toString(),
            infoLignes[i]['fields']['shape']['coordinates']));
      }
      return lignesList;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
