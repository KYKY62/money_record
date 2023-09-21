import 'package:flutter/material.dart';

class HomeTitleWidget extends StatelessWidget {
  const HomeTitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}
