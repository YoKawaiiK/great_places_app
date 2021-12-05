import 'package:flutter/widgets.dart';
import 'package:great_places_app/src/models/place_model.dart';

class GreatPlacesProvider with ChangeNotifier {
  List<PlaceModel> _places = [];

  List<PlaceModel> get places => [..._places];

  
}
