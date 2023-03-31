import 'package:http/http.dart' as http;
import 'dart:convert';

class ArretsRepository {
  late Map<String, dynamic> _arretsData;

  Future<void> init() async {
    _arretsData = await fetchData();
  }

  Future<Map<String, dynamic>> fetchData({String query = ''}) async {
    final response = await http.get(Uri.parse(
        'https://data.angers.fr/api/records/1.0/search/?dataset=horaires-theoriques-et-arrets-du-reseau-irigo-gtfs&q=$query&rows=5000&facet=stop_id&facet=stop_name&facet=wheelchair_boarding&timezone=Europe%2FParis'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Map<String, dynamic> get arretsData => _arretsData;
}
