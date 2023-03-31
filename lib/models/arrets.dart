class Arrets {
  final String street;
  final String city;
  final String postcode;

  const Arrets(
      {required this.street, required this.city, required this.postcode});

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postcode': postcode,
    };
  }

  factory Arrets.fromJson(Map<String, dynamic> json) {
    return LatLng(
      street: json['street'],
      city: json['city'],
      postcode: json['postcode'],
    );
  }

  String toText() {
    return "$street, $city $postcode";
  }
}
