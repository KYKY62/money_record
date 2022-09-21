import 'package:flutter/material.dart';

class DrawerTitleWidget extends StatelessWidget {
  const DrawerTitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
