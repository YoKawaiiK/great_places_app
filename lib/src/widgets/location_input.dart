import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:great_places_app/src/models/place_location_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  Function addPosition;

  LocationInput({
    required this.addPosition,
  });

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // bool _isScreenLoaded = false;

  LatLng? currentPosition;
  MapController _mapController = MapController();

  final List<LatLng> _markers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentUserLocation();
  }

  Future<void> _getCurrentUserLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();

    currentPosition = LatLng(locationData.latitude!, locationData.longitude!);

    widget.addPosition(
      PlaceLocationModel(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          adress: "g"),
    );

    setState(() {
      _mapController.move(currentPosition!, 16);
      markerAdd(currentPosition!);
    });
  }

  void markerAdd(LatLng position) {
    _markers.add(position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: Theme.of(context).colorScheme.secondary)),
            child: FlutterMap(
              // key: ValueKey(MediaQuery.of(context).orientation),
              key: ValueKey("Map"),
              mapController: _mapController,
              options: MapOptions(
                onMapCreated: (c) {
                  _mapController = c;
                },
                // center: currentPosition,
                zoom: 15.3,
                maxZoom: 17,
                minZoom: 3.5,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    if (_markers.isNotEmpty)
                      ..._markers
                          .map((markerPosition) => Marker(
                                point: markerPosition,
                                builder: (ctx) => Container(
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                              ))
                          .toList(),
                  ],
                ),
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                _getCurrentUserLocation();
              },
              icon: Icon(Icons.location_on),
              label: Text(
                "Current location",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.map),
              label: Text(
                "Select on Map",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
