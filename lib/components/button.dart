import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color? color;
  final void Function()? onTap;
  const MyButton({super.key, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: color),
        child: const Center(child: Icon(Icons.contrast))
      ),
    );
  }
}