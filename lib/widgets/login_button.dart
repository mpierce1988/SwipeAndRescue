import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function(BuildContext context) loginMethod;

  const LoginButton(
      {Key? key,
      required this.color,
      required this.icon,
      required this.text,
      required this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => loginMethod(context),
      icon: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
      label: Text(text),
      style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24), backgroundColor: color),
    );
  }
}
