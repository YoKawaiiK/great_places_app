import 'package:flutter/material.dart';

class AddPlaceScreen extends StatefulWidget {
  static const String routeName = 'AddPlaceScreen';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new place"),
      ),
      body: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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

          
        ],
      )),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
    );
  }
}
