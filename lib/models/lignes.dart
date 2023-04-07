class Lignes {
  final String route_id;
  final String route_long_name;
  final String route_short_name;
  final String route_color;
  final List<List<List<double>>> coordinates;
  bool isFavorite;

  Lignes(
      {required this.route_id,
      required this.route_long_name,
      required this.route_short_name,
      required this.route_color,
      required this.coordinates,
      this.isFavorite = false});

  Map<String, dynamic> toJson() {
    return {
      'route_id': route_id,
      'route_long_name': route_long_name,
      'route_short_name': route_short_name,
      'route_color': route_color,
      'coordinates': coordinates,
      'isFavorite': isFavorite,
    };
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  factory Lignes.fromJson(String routeId, String nameRoutes, String shortRoutes,
      String color, List coordinates) {
    return Lignes(
      route_id: routeId,
      route_long_name: nameRoutes,
      route_short_name: shortRoutes,
      route_color: color,
      coordinates: coordinates
          .map((coordsList) => (coordsList as List)
              .map((coords) =>
                  (coords as List).map((coord) => coord as double).toList())
              .toList())
          .toList(),
      isFavorite: false,
    );
  }

  factory Lignes.fromtest(Map<String, dynamic> json) {
    return Lignes(
      route_id: json['route_id'],
      route_long_name: json['route_long_name'],
      route_short_name: json['route_short_name'],
      route_color: json['route_color'],
      coordinates: json['shape']?['coordinates'] != null
          ? (json['shape']['coordinates'] as List<dynamic>)
              .map<List<List<double>>>((route) => (route as List)
                  .map<List<double>>((coordsList) => (coordsList as List)
                      .map<double>((coords) => coords as double)
                      .toList())
                  .toList())
              .toList()
          : [],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  String toText() {
    return "$route_id, $route_long_name, $route_short_name, $route_color, $coordinates";
  }
}
