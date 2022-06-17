import 'package:flutter/material.dart';

class DosageSelector extends StatefulWidget {
  final ValueChanged<double>? onChanged;
  double? defaultValue;
  double? step;
  double? minValue;
  double? maxDosage;
  DosageSelector(
      {Key? key,
      this.defaultValue,
      this.onChanged,
      this.step,
      this.minValue,
      this.maxDosage})
      : super(key: key);

  @override
  _DosageSelectorState createState() => _DosageSelectorState();
}

class _DosageSelectorState extends State<DosageSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            height: 20,
            width: 20,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (widget.defaultValue! > widget.minValue!) {
                    widget.defaultValue = widget.defaultValue! - widget.step!;
                  }
                });
                widget.onChanged!(widget.defaultValue!);
              },
              child: const Icon(
                Icons.remove,
                color: Colors.black,
                size: 20,
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                primary: Colors.orange, // <-- Button color
                onPrimary: Colors.red, // <-- Splash color
              ),
            ),
          ),
          Text(
            widget.defaultValue!.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            height: 20,
            width: 20,
            child: ElevatedButton(
              onPressed: () {
                widget.maxDosage = widget.maxDosage ?? double.infinity;
                setState(() {
                  if (widget.defaultValue! < widget.maxDosage!) {
                    widget.defaultValue = widget.defaultValue! + widget.step!;
                  }
                });
                widget.onChanged!(widget.defaultValue!);
              },
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 20,
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                primary: Colors.orange, // <-- Button color
                onPrimary: Colors.red, // <-- Splash color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
