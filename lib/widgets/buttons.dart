import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onpressed;
  final String? text;
  final Color? color;
  final Size? minSize;

  const SubmitButton(
      {Key? key, this.onpressed, this.text, this.color, this.minSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color ?? Colors.orange[400],
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            // fixedSize: const Size(250, 40),
            minimumSize: minSize ?? const Size(200, 40),
            maximumSize: const Size(300, 40),
          ),
          child: Text(
            text!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          onPressed: onpressed,
        ),
      ),
    );
  }
}

class OrangeTextButton extends StatelessWidget {
  final Function? onpressed;
  final String? label;
  const OrangeTextButton({Key? key, this.onpressed, this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onpressed!();
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Text(
          label!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
