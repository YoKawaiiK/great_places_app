import 'package:flutter/material.dart';
import 'package:great_places_app/src/providers/great_places_provider.dart';
import 'package:great_places_app/src/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  static const String routeName = "PlacesListScreen";

  const PlacesListScreen({Key? key}) : super(key: key);

  void _goToAddPlaceScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your places'),
        actions: [
          IconButton(
              onPressed: () {
                _goToAddPlaceScreen(context);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: Consumer<GreatPlacesProvider>(
        child: const Center(
          child: Text("Its empty"),
        ),
        builder: (_ctx, greatPlaces, child) {
          if (greatPlaces.places.isEmpty) {
            return child!;
          }

          return ListView.builder(
            itemCount: greatPlaces.places.length,
            itemBuilder: (_ctx, i) => ListTile(
              leading: CircleAvatar(
                backgroundImage: FileImage(greatPlaces.places[i].image),
              ),
              title: Text(greatPlaces.places[i].title),
            ),
          );
        },
      ),

      // Center(
      //   child: CircularProgressIndicator(),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToAddPlaceScreen(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
