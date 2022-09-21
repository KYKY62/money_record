import 'package:flutter/material.dart';

class ListtileWidget extends StatelessWidget {
  const ListtileWidget({
    Key? key,
    required this.title,
    required this.ontap,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback ontap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      leading: icon,
      horizontalTitleGap: 0,
      title: Text(title),
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
