import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/src/models/add_place_model.dart';
import 'package:great_places_app/src/providers/great_places_provider.dart';
import 'package:great_places_app/src/widgets/image_input.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const String routeName = 'AddPlaceScreen';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final GlobalKey<FormState> _form = GlobalKey();
  bool _isValid = false;

  AddPlaceModel addPlace = AddPlaceModel();

  // File? _pickedImage;

  void _selectImage(File pickedImage) {
    setState(() {
      addPlace.pickedImage = pickedImage;
      _isFormValid();
    });
  }

  void _isFormValid() {
    if (!_form.currentState!.validate() || addPlace.pickedImage == null) {
      _isValid = false;
    } else {
      _isValid = true;
    }
  }

  void _savePlace(BuildContext context) {
    _isFormValid();
    print(_isValid);
    if (!_isValid) return;

    _form.currentState!.save();

    Provider.of<GreatPlacesProvider>(context, listen: false).addPlace(addPlace);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new place"),
      ),
      body: Form(
        onChanged: () {
          setState(() {
            _isFormValid();
          });
        },
        key: _form,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text('User Inputs...'),
                    // ElevatedButton.icon(
                    //   label: Text("Add place"),
                    //   style: ElevatedButton.styleFrom(
                    //     elevation: 0,
                    //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.zero,
                    //     ),
                    //   ),
                    //   onPressed: () {},
                    //   icon: Icon(Icons.add),
                    // ),

                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      onChanged: (v) {
                        addPlace.placeTitle = v;
                      },
                      validator: (v) {
                        if (v == null || v.length == 0)
                          return "Please fill this field.";
                        if (v.length < 5 || v.length > 200)
                          return "the field should not contain more than 200 symbols and less than 5 characters";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(
                      onSelectImage: _selectImage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isValid
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add),
        onPressed: () {
          _savePlace(context);
        },
      ),
    );
  }
}
