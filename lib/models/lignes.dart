
class Lignes {
  final String route_long_name;
  final String route_short_name;

   const Lignes(
      {required this.route_long_name, required this.route_short_name});

  Map<String, dynamic> toJson() {
    return {
      'route_long_name': route_long_name,
      'route_short_name': route_short_name,
    };
  }

  factory Lignes.fromJson(Map<String, dynamic> json) {
    return Lignes(
      route_long_name: json['route_long_name'],
      route_short_name: json['route_short_name'],
    );
  }

  String toText() {
    return "$route_long_name, $route_short_name";
  }
}