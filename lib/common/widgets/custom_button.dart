import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 40,
      child: ElevatedButton(
        child: Text(text.toUpperCase()),
        onPressed: onPressed,
        //style: ElevatedButton.styleFrom(primary: Colors.),
      ),
    );
  }
}
