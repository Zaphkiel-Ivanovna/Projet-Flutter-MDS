import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
