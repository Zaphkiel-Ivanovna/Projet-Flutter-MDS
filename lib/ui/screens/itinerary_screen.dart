import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class ItineraryScreen extends StatefulWidget {
  final List<List<LatLng>> coordinates;
  final String ligneName;
  final String routeColor;

  ItineraryScreen(
      {Key? key,
      required this.coordinates,
      required this.ligneName,
      required this.routeColor})
      : super(key: key);

  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  int? _selectedRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ligneName),
        backgroundColor: Color(0xFF8B0000),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(16.0),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color(0xFF8B0000),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.57), //shadow for button
                            blurRadius: 5) //blur radius of shadow
                      ]),
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: DropdownButton<int>(
                      value: _selectedRoute,
                      hint: Text('Choisir un itinéraire',
                          style: TextStyle(color: Colors.white)),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedRoute = newValue;
                        });
                      },
                      isExpanded:
                          true, //make true to take width of parent widget
                      underline: Container(), //empty line
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      dropdownColor: Color(0xFF8B0000),
                      iconEnabledColor: Colors.white,
                      items: List<DropdownMenuItem<int>>.generate(
                        widget.coordinates.length + 1,
                        (index) {
                          if (index == 0) {
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text('Tous les itinéraires'),
                            );
                          } else {
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text('Itinéraire $index'),
                            );
                          }
                        },
                      ),
                    ),
                  ))),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: widget.coordinates.isNotEmpty
                    ? widget.coordinates.first.first
                    : LatLng(47.47, -0.55),
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                zoom: 13.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: _buildPolylines(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Polyline> _buildPolylines() {
    List<Polyline> polylines = [];
    if (_selectedRoute == null || _selectedRoute == 0) {
      for (int i = 0; i < widget.coordinates.length; i++) {
        polylines.add(Polyline(
          points: widget.coordinates[i],
          strokeWidth: 4.0,
          color: Color(int.parse('0xFF${widget.routeColor}')),
        ));
      }
    } else {
      int index = _selectedRoute! - 1;
      polylines.add(Polyline(
        points: widget.coordinates[index],
        strokeWidth: 4.0,
        color: Color(int.parse('0xFF${widget.routeColor}')),
      ));
    }
    return polylines;
  }
}
