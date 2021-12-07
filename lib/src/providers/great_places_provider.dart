import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:great_places_app/src/models/add_place_model.dart';
import 'package:great_places_app/src/models/place_model.dart';

import '../helpers/db_helper.dart' as DBHelper;
import '../constants/database.dart' as DBconstants;

class GreatPlacesProvider with ChangeNotifier {
  List<PlaceModel> _places = [];

  List<PlaceModel> get places => [..._places];

  void addPlace(AddPlaceModel addPlace) {
    final newPlace = PlaceModel(
      id: DateTime.now().toString(),
      title: addPlace.placeTitle!,
      location: addPlace.placeLocation,
      image: addPlace.pickedImage!,
    );

    _places.add(newPlace);
    notifyListeners();

    DBHelper.insert(DBconstants.userPlaces, {
      DBconstants.placesId: newPlace.id,
      DBconstants.placesTitle: newPlace.title,
      DBconstants.placesImage: newPlace.image.path,
    });
  }

  Future<void> loadAndSetPlaces() async {
    final placesData = await DBHelper.select(DBconstants.userPlaces);

    _places = placesData.map((item) {
      return PlaceModel(
        id: item[DBconstants.placesId],
        title: item[DBconstants.placesTitle],
        image: File(item[DBconstants.placesImage]),
        location: null,
      );
    }).toList();

    notifyListeners();
  }
}
