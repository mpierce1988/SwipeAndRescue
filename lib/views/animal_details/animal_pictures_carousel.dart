import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:swipeandrescue/theme.dart';

class AnimalImagesCarousel extends StatefulWidget {
  final List<String> images;
  const AnimalImagesCarousel({Key? key, required this.images})
      : super(key: key);

  @override
  State<AnimalImagesCarousel> createState() => _AnimalImagesCarouselState();
}

class _AnimalImagesCarouselState extends State<AnimalImagesCarousel> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.images[index]),
                ),
              ),
            );
          },
          options: CarouselOptions(
              height: 300,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              onPageChanged: (id, carouselChangeReason) {
                setState(() {
                  index = id;
                });
              }),
        ),
        CarouselIndicator(
          count: widget.images.length,
          index: index,
          color: CustomColors().grey,
          activeColor: CustomColors().primary,
        ),
      ],
    );
  }
}
