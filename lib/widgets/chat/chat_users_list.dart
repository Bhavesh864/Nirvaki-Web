import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';

class ChatUserList extends StatelessWidget {
  const ChatUserList({super.key, required this.users});

  // ignore: prefer_typing_uninitialized_variables
  final users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, index) => UserList(user: users[index]));
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key, required this.user});

  // ignore: prefer_typing_uninitialized_variables
  final user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        customSnackBar(context: context, text: 'text');
      },
      splashColor: Colors.grey[350],
      // contentPadding: const EdgeInsets.all(0),
      leading: const CircleAvatar(
          radius: 26, backgroundImage: AssetImage(profileImage)),
      title: const Flexible(
        child: AppText(
          text: "Madhav Sewag",
          textColor: Color.fromRGBO(44, 44, 46, 1),
          fontWeight: FontWeight.w500,
          fontsize: 16,
        ),
      ),
      subtitle: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Icon(
              Icons.done_all,
              color: Color.fromRGBO(31, 162, 255, 1),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: AppText(
                overflow: TextOverflow.ellipsis,
                text: "Hey, how are you",
                textColor: Color.fromRGBO(155, 155, 155, 1),
                fontWeight: FontWeight.w400,
                fontsize: 15,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
      trailing: Column(
        children: [
          const AppText(
            text: "14.24",
            textColor: Color.fromRGBO(155, 155, 155, 1),
            fontWeight: FontWeight.w400,
            fontsize: 12,
            maxLines: 1,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
