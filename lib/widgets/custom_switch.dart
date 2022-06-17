import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool? defaultValue;
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({
    Key? key,
    this.defaultValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool? _value;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.4,
      // width: 80,
      // height: 30,
      // color: Colors.red,
      child: Switch(
        onChanged: (value) {
          setState(() {
            _value = value;
          });
          widget.onChanged!(value);
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: _value ?? widget.defaultValue!,
        activeTrackColor: Colors.orange,
        activeColor: Colors.black,
      ),
    );
  }
}
