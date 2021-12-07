import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:great_places_app/src/models/place_location_model.dart';
import 'package:great_places_app/src/utils/check_internet.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as Location;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = "MapScreen";
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition;
  String? _adress;

  late final _mapController = MapController();

  final List<LatLng> _markers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentUserLocation();
  }

  Future<void> _backScreenWithData(BuildContext context) async {
    final placeLocationModel = PlaceLocationModel(
      latitude: _currentPosition?.latitude ?? 0,
      longitude: _currentPosition?.longitude ?? 0,
      adress: _adress ?? "No data",
    );

    Navigator.of(context).pop(placeLocationModel);
  }

  Future<void> _getCurrentUserLocation() async {
    final location = Location.Location();

    bool _serviceEnabled;
    Location.PermissionStatus _permissionGranted;
    Location.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == Location.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != Location.PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();

    _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);

    await _getAdress();

    setState(() {
      markerAdd(_currentPosition!);
      _mapController.move(_currentPosition!, 16);
    });
  }

  Future<void> _getAdress() async {
    final isHasInternet = await check();
    // print(isHasInternet);
    if (!isHasInternet) return;


      List<Geocoding.Placemark> placemarks =
          await Geocoding.placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      _adress =
          "${placemarks[0].country}, ${placemarks[0].administrativeArea}, ${placemarks[0].street}";
    
  }

  Future<void> _getWritedAdress(BuildContext context, String adress) async {
    try {
          final isHasInternet = await check();
    // print(isHasInternet);
    if (!isHasInternet) return;

    final place = await Geocoding.locationFromAddress(adress);

    _currentPosition!.latitude = place[0].latitude;
    _currentPosition!.longitude = place[0].longitude;
    _adress = adress;

    setState(() {
      markerAdd(_currentPosition!);
    });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Incorrect adress."))
      );
    }
  }

  void markerAdd(LatLng position) {
    _markers.clear();
    _markers.add(position);
  }

  void _onLongMapPress(LatLng latLng) async {
    await _getAdress();
    setState(() {
      markerAdd(latLng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _backScreenWithData(context);
        return false;
      },
      child: Scaffold(
          // appBar: AppBar(
          //   title: Text("Select your location"),
          // ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              FlutterMap(
                // key: ValueKey(MediaQuery.of(context).orientation),
                key: const ValueKey("Map"),
                mapController: _mapController,
                options: MapOptions(
                  // center: currentPosition,

                  onLongPress: (_position, latLng) {
                    _onLongMapPress(latLng);
                  },
                  zoom: 17,
                  maxZoom: 20,
                  minZoom: 15,
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
                                  builder: (ctx) => Icon(
                                    Icons.location_on,
                                    size: 50,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ))
                            .toList(),
                    ],
                  ),
                ],
              ),
              FloatingSearchBar(
                automaticallyImplyBackButton: false,
                onSubmitted: (v) {
                  if (v.isEmpty) return;
                  _getWritedAdress(context, v);
                },
                builder: (_ctx, transition) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // child: Material(
                    //   color: Colors.white,
                    //   elevation: 4.0,
                    // ),
                  );
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _getCurrentUserLocation();
            },
            child: Icon(Icons.my_location),
          )),
    );
  }
}
