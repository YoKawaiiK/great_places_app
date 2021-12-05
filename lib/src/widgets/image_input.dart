import 'dart:io';

import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Color get _colorImage {
    if (_storedImage != null) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size device = MediaQuery.of(context).size;

    return Container(
      // width: 100,
      height: device.height / 3,

      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: _colorImage,
        ),
      ),
      alignment: Alignment.center,
      child: _storedImage != null
          ? Image.file(
              _storedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
            )
          : Text(
              "Take picture",
              style: TextStyle(
                  color: _colorImage,
                  fontSize: Theme.of(context).textTheme.headline6!.fontSize),
              textAlign: TextAlign.center,
            ),
    );
  }
}
