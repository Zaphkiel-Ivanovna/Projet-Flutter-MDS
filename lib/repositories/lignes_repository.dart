import 'package:http/http.dart' as http;
import 'dart:convert';

class LignesRepository {

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://data.angers.fr/api/records/1.0/search/?dataset=irigo_gtfs_lines&rows=-1&facet=nomcourtligne&facet=numeroligne'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
