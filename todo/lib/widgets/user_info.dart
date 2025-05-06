import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 300;

        final avatar = const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/kingbob.webp'),
        );

        final textColumn = Column(
          crossAxisAlignment:
              isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: const [
            Text(
              "지선",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "앱으로 자유찾기",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [avatar, const SizedBox(height: 12), textColumn],
          );
        } else {
          return Row(
            children: [
              const SizedBox(width: 10),
              avatar,
              const SizedBox(width: 15),
              textColumn,
            ],
          );
        }
      },
    );
  }
}
