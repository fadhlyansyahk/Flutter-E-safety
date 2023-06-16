import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String btnText;
  final Function onBtnPressed;

  const RoundedButton(
      {Key? key, required this.btnText, required this.onBtnPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
      child: MaterialButton(
        onPressed: () {
          onBtnPressed();
        },
        minWidth: 280,
        height: 55,
        child: Text(
          btnText,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
