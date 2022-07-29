import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextEntryColumn extends StatefulWidget {
  final List<TextEditingController> entries;

  const TextEntryColumn({Key? key, this.entries = const []}) : super(key: key);

  @override
  State<TextEntryColumn> createState() => _TextEntryColumnState();
}

class _TextEntryColumnState extends State<TextEntryColumn> {
  int count = 0;
  //List<TextEditingController> textEditingControllers = [];
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < count; i++) {
      if (i >= widget.entries.length) {
        // list does not already have a text editing controller for this
        // index
        widget.entries.add(TextEditingController());
      }
    }
    return Column(
      children: [
        for (int i = 0; i < count; i++) _newTextBox(i),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => setState(() {
                // only allow up to 6 fields
                if (widget.entries.length >= 6) return;

                count++;
              }),
              icon: const Icon(Icons.plus_one),
              label: const Text('Add Field'),
            ),
            ElevatedButton.icon(
              onPressed: (() => setState(() {
                    // do nothing if entries is already empty
                    if (widget.entries.isEmpty) return;
                    // get rid of last text editing controller
                    widget.entries.removeLast();
                    // decrement the count
                    count--;
                  })),
              icon: const Icon(FontAwesomeIcons.minus),
              label: const Text('Remove Field'),
            ),
          ],
        ),
      ],
    );
  }

  _newTextBox(int index) {
    return Row(
      children: [
        const Flexible(flex: 1, child: Icon(Icons.arrow_right)),
        Flexible(
          flex: 3,
          child: TextFormField(
            //expands: true,
            controller: widget.entries[index],
          ),
        )
      ],
    );
  }
}
