import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSelectionColumn extends StatefulWidget {
  final List<String> images;
  const ImageSelectionColumn({Key? key, required this.images})
      : super(key: key);

  @override
  State<ImageSelectionColumn> createState() => _ImageSelectionColumnState();
}

class _ImageSelectionColumnState extends State<ImageSelectionColumn> {
  CarouselController carouselController = CarouselController();
  int _currentImageIndex = -1;
  @override
  Widget build(BuildContext context) {
    debugPrint('Image Count: ${widget.images.length}');
    return Column(
      children: [
        if (widget.images.isNotEmpty)
          CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: widget.images.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              _currentImageIndex = index;
              // show as network image for web
              if (kIsWeb) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.images[index]),
                        fit: BoxFit.cover),
                  ),
                );
              }
              // show as file image for android/ios
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(File(widget.images[index])),
                      fit: BoxFit.cover),
                ),
              );
            },
            options: CarouselOptions(
                height: 400,
                enableInfiniteScroll: false,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  _currentImageIndex = index;
                }),
          ),
        ElevatedButton.icon(
            onPressed: () {
              getImage(false);
            },
            icon: const Icon(FontAwesomeIcons.camera),
            label: const Text('Add from Camera')),
        ElevatedButton.icon(
            onPressed: (() {
              getImage(true);
            }),
            icon: const Icon(FontAwesomeIcons.images),
            label: const Text("Add from Gallery")),
        if (widget.images.isNotEmpty)
          ElevatedButton.icon(
              onPressed: (() {
                String fileToRemove = widget.images[_currentImageIndex];
                // remove file from list
                widget.images.remove(fileToRemove);
                // set state to update carousel
                setState(() {});
              }),
              icon: const Icon(FontAwesomeIcons.images),
              label: const Text("Remove Picture"))
      ],
    );
  }

  Future<void> getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // is user wants to select from gallery
    if (gallery) {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }
    // otherwise use camera
    else {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }

    setState(() {
      if (pickedFile != null) {
        widget.images.add(pickedFile.path);
      } else {
        // display error message
        debugPrint('Image Picker did not successfully pick a photo');
      }
    });
  }
}
