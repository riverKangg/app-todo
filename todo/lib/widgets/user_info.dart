import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage("assets/kingbob.webp"),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "지선",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "앱으로 자유찾기",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
