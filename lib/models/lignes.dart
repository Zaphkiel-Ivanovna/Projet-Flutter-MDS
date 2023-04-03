class Lignes {
  final String route_long_name;
  final String route_short_name;
  final String route_color;

  const Lignes(
      {required this.route_long_name,
      required this.route_short_name,
      required this.route_color});

  Map<String, dynamic> toJson() {
    return {
      'route_long_name': route_long_name,
      'route_short_name': route_short_name,
      'route_color ': route_color
    };
  }

  factory Lignes.fromJson(String nameRoutes, String shortRoutes, String color) {
    return Lignes(
      route_long_name: nameRoutes,
      route_short_name: shortRoutes,
      route_color: color,
    );
  }

  factory Lignes.fromtest(Map<String, dynamic> json) {
    return Lignes(
      route_long_name: json['route_long_name'],
      route_short_name: json['route_short_name'],
      route_color: json['route_color'],
    );
  }

  String toText() {
    return "$route_long_name, $route_short_name, $route_color";
  }
}
