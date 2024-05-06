import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isLoading,
      required this.color,
      this.titleColor = Colors.black});
  final String title;
  final Color color;
  final VoidCallback onPressed;
  final bool? isLoading;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            minimumSize: Size(MediaQuery.of(context).size.width, 48),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11))),
        child: isLoading == true
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                title,
                style: TextStyle(color: titleColor, fontSize: 18),
              ));
  }
}
