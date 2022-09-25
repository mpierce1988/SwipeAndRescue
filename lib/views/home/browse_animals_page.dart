import 'package:flutter/material.dart';
import 'package:swipeandrescue/constants.dart';

import 'package:swipeandrescue/controllers/browse_animals_controller.dart';
import 'package:swipeandrescue/models/animal_model.dart';
import 'package:swipeandrescue/theme.dart';
import 'package:swipeandrescue/widgets/browse_animals_card.dart';

class BrowseAnimalsPage extends StatefulWidget {
  const BrowseAnimalsPage({Key? key}) : super(key: key);

  @override
  State<BrowseAnimalsPage> createState() => _BrowseAnimalsPageState();
}

class _BrowseAnimalsPageState extends State<BrowseAnimalsPage>
    with AutomaticKeepAliveClientMixin {
  final BrowseAnimalsController browseAnimalsController =
      BrowseAnimalsController();
  late Future<List<Animal>> futureAnimals =
      browseAnimalsController.getAnimals();

  @override
  void initState() {
    //futureAnimals = browseAnimalsController.getAnimals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final BrowseAnimalsController browseAnimalsController =
    //     BrowseAnimalsController();
    return FutureBuilder(
        future: futureAnimals,
        builder: (context, AsyncSnapshot<List<Animal>> snapshot) {
          debugPrint("Building Browse Animals page...");
          if (snapshot.connectionState == ConnectionState.waiting) {
            // show circular loading
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            // show error message
            return Center(
              child: Text(
                  'The following error has occured: ${snapshot.error.toString()}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // show animal results
            //return _displayAnimals(snapshot.data!);
            return RefreshIndicator(
              onRefresh: _pullRefresh,
              child: _displayAnimals(snapshot.data!),
            );
          }

          // else no results were found
          return RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView(children: const [
              Center(
                child: Text('No animals were found, sorry.'),
              ),
            ]),
          );
        });
  }

  Future<void> _pullRefresh() async {
    List<Animal> newAnimals = await browseAnimalsController.getAnimals();
    setState(() {
      futureAnimals = Future.value(newAnimals);
    });
  }

  Widget _browseAnimalsColumn(List<Animal> animals) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: ListView.separated(
        itemCount: animals.length,
        separatorBuilder: (context, index) =>
            Divider(color: CustomColors().night),
        itemBuilder: ((context, index) {
          return BrowseAnimalsCard(
            animal: animals[index],
            width: 400,
            height: 600,
          );
        }),
      ),
    );
  }

  Widget _browseAnimalsGrid(List<Animal> animals) {
    debugPrint('Using animals grid view...');
    return Container(
      padding: const EdgeInsets.all(30),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: animals.length,
          itemBuilder: (BuildContext context, int idx) {
            return BrowseAnimalsCard(
              animal: animals[idx],
              width: 800,
              height: 800,
            );
          }),
    );
  }

  Widget _displayAnimals(List<Animal> animals) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= Constants().mediumWidth) {
          // small layout
          return _browseAnimalsColumn(animals);
        } else if (constraints.maxWidth <= Constants().largeWidth) {
          // medium layout
          return _browseAnimalsGrid(animals);
        }

        // large layout
        return _browseAnimalsGrid(animals);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
