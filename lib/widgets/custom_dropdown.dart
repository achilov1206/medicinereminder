import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final ValueChanged<String>? onValueChanged;
  String? defaultValue, dropdownHint;
  List<String>? itemsList;

  CustomDropdown({
    Key? key,
    this.itemsList,
    this.defaultValue,
    this.dropdownHint,
    this.onValueChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      color: Colors.white,
      child: DropdownButton<String>(
        icon: const Icon(
          Icons.arrow_downward,
          size: 20,
        ),
        items: widget.itemsList!.map(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
        value: _value ?? widget.defaultValue,
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            widget.onValueChanged!(value!);
            _value = value;
          });
        },
        hint: Text(widget.dropdownHint!),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        iconEnabledColor: Colors.black,
        iconSize: 14,
        underline: Container(),
      ),
    );
  }
}
