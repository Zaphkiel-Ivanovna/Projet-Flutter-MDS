class Lignes {
  final String route_long_name;
  final String route_short_name;
  final String route_color;
  final List<List<double>> coordinates;

  const Lignes(
      {required this.route_long_name,
      required this.route_short_name,
      required this.route_color,
      required this.coordinates});

  Map<String, dynamic> toJson() {
    return {
      'route_long_name': route_long_name,
      'route_short_name': route_short_name,
      'route_color ': route_color,
      'coordinates': coordinates
    };
  }

  factory Lignes.fromJson(String nameRoutes, String shortRoutes, String color, List coordinates) {
    return Lignes(
      route_long_name: nameRoutes,
      route_short_name: shortRoutes,
      route_color: color,
      coordinates: coordinates
          .map((coordsList) => (coordsList as List)
              .map((coords) => coords as double)
              .toList())
          .toList(),
    );
  }

  factory Lignes.fromtest(Map<String, dynamic> json) {
    return Lignes(
      route_long_name: json['route_long_name'],
      route_short_name: json['route_short_name'],
      route_color: json['route_color'],
      coordinates: (json['shape']['coordinates'][0] as List)
          .map((coordsList) => (coordsList as List)
              .map((coords) => coords as double)
              .toList())
          .toList(),
    );
  }

  String toText() {
    return "$route_long_name, $route_short_name, $route_color, $coordinates";
  }
}
