import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:great_places_app/src/models/add_place_model.dart';
import 'package:great_places_app/src/models/place_model.dart';

class GreatPlacesProvider with ChangeNotifier {
  List<PlaceModel> _places = [];

  List<PlaceModel> get places => [..._places];

  void addPlace(AddPlaceModel addPlace) {
    final newPlace = PlaceModel(
      id: DateTime.now().toString(),
      title: addPlace.placeTitle!,
      location: null,
      image: addPlace.pickedImage!,
    );

    _places.add(newPlace);
    notifyListeners();
  }
}
