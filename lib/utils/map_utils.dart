import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projet_flutter_mds/repositories/arrets_repository.dart';
import 'package:projet_flutter_mds/models/arrets.dart';

void animatedMapMove(MapController mapController, LatLng destLocation,
    double destZoom, TickerProvider vsync) {
  final latTween = Tween<double>(
      begin: mapController.center.latitude, end: destLocation.latitude);
  final lngTween = Tween<double>(
      begin: mapController.center.longitude, end: destLocation.longitude);
  final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

  final controller = AnimationController(
      duration: const Duration(milliseconds: 500), vsync: vsync);
  final Animation<double> animation =
      CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

  controller.addListener(() {
    mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation));
  });

  animation.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      controller.dispose();
    } else if (status == AnimationStatus.dismissed) {
      controller.dispose();
    }
  });

  controller.forward();
}

Future<void> performSearch({
  required MapController mapController,
  required TickerProvider vsync,
  required ArretsRepository arretsRepository,
  required String query,
  required Function(List<LatLng>) addMarkers,
}) async {
  final arretsData = await arretsRepository.fetchData(query: query);
  final arretsCoords = arretsData["records"]
      .map<LatLng>((record) => LatLng(
            record["geometry"]["coordinates"][1],
            record["geometry"]["coordinates"][0],
          ))
      .toList();
  addMarkers(arretsCoords);

  if (arretsCoords.isNotEmpty) {
    animatedMapMove(mapController, arretsCoords.first, 18, vsync);
  }
}
