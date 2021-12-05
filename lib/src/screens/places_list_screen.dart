import 'package:flutter/material.dart';
import 'package:great_places_app/src/screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  static const String routeName = "PlacesListScreen";

  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your places'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
          }, icon: Icon(Icons.add)),
        ],
      ),
      body: Center( 
        child: CircularProgressIndicator(),
      ),
    );
  }
}
