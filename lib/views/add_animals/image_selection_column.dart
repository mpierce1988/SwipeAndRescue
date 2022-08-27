import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSelectionColumn extends StatefulWidget {
  final List<XFile> imagesFromPicker;
  final List<String> imagesFromWebUrls;
  const ImageSelectionColumn(
      {Key? key,
      required this.imagesFromPicker,
      required this.imagesFromWebUrls})
      : super(key: key);

  @override
  State<ImageSelectionColumn> createState() => _ImageSelectionColumnState();
}

class _ImageSelectionColumnState extends State<ImageSelectionColumn> {
  CarouselController carouselController = CarouselController();
  int _currentImageIndex = -1;
  @override
  Widget build(BuildContext context) {
    debugPrint(
        'Image Count: ${widget.imagesFromPicker.length + widget.imagesFromWebUrls.length}');
    return Column(
      children: [
        if (widget.imagesFromPicker.isNotEmpty ||
            widget.imagesFromWebUrls.isNotEmpty)
          CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: widget.imagesFromPicker.length +
                widget.imagesFromWebUrls.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              _currentImageIndex = index;
              // show as network image for web
              if (kIsWeb) {
                debugPrint('Showing web image at index $index...');
                return _showWebImage(index);
              }

              // show as combined web urls and picked images for android/ios
              return _showDeviceImage(index);
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
        if (widget.imagesFromPicker.isNotEmpty)
          ElevatedButton.icon(
              onPressed: (() {
                if (_currentImageIndex < widget.imagesFromWebUrls.length) {
                  // remove web image
                  widget.imagesFromWebUrls.removeAt(_currentImageIndex);
                } else {
                  // remove file from list
                  widget.imagesFromPicker.removeAt(
                      _currentImageIndex - widget.imagesFromWebUrls.length);
                }

                // set state to update carousel
                setState(() {});
              }),
              icon: const Icon(FontAwesomeIcons.images),
              label: const Text("Remove Picture"))
      ],
    );
  }

  Widget _showDeviceImage(int index) {
    // show web urls first
    if (index < widget.imagesFromWebUrls.length) {
      // show web urls
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(widget.imagesFromWebUrls[index]),
              fit: BoxFit.cover),
        ),
      );
    }
    // show picked file images
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: FileImage(File(widget
                .imagesFromPicker[index - widget.imagesFromWebUrls.length]
                .path)),
            fit: BoxFit.cover),
      ),
    );
  }

  Widget _showWebImage(int index) {
    // show web urls first
    if (index < widget.imagesFromWebUrls.length) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(widget.imagesFromWebUrls[index]),
              fit: BoxFit.cover),
        ),
      );
    } else {
      // show picked images
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(widget
                  .imagesFromPicker[index - widget.imagesFromWebUrls.length]
                  .path),
              fit: BoxFit.cover),
        ),
      );
    }
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
        widget.imagesFromPicker.add(pickedFile);
      } else {
        // display error message
        debugPrint('Image Picker did not successfully pick a photo');
      }
    });
  }
}
