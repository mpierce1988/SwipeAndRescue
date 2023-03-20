import 'package:flutter/material.dart';

class DecoratedDropdown extends StatelessWidget {
  final int? valueToWatch;
  final List<DropdownMenuItem<int>> dropDownMenuItems;
  final Function(int? value) onChangedMethod;

  const DecoratedDropdown(
      {Key? key,
      required this.valueToWatch,
      required this.dropDownMenuItems,
      required this.onChangedMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
              width: 3, color: Theme.of(context).secondaryHeaderColor),
          borderRadius: BorderRadius.circular(50)),
      child: DropdownButton<int?>(
        isExpanded: true,
        dropdownColor: Theme.of(context).primaryColor,
        style: const TextStyle(color: Colors.white),
        value: valueToWatch,
        items: dropDownMenuItems,
        onChanged: (value) {
          onChangedMethod(value!);
        },
      ),
    );
  }
}
