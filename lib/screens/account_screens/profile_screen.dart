import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 150,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
            ),
          ),
        ),
        Container(
          // height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
