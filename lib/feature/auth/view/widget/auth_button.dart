import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget{
  const AuthButton( 
    {
      super.key, 
      required this.name,
      required this.onTap
    }
  );

  final String name;
  final VoidCallback onTap;

  @override 
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, 
      child: Text(
        name
      )
    );
  }
}