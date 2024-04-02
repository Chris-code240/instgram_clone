import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  const FollowButton(
      {super.key,
      this.function,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
          onPressed: widget.function,
          child: Container(
            width: 250,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                border: Border.all(
                  color: widget.borderColor,
                ),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                    color: widget.textColor, fontWeight: FontWeight.bold),
              ),
            ),
          )),
    );
  }
}
