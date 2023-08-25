import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';
import 'package:yes_broker/screens/main_screens/chat_screen.dart';

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
    return Material(
      color: Colors.white,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ChatScreen(
                user: user,
              ),
            ),
          );
        },
        splashColor: Colors.grey[350],
        leading: Hero(
          tag: user["id"],
          child: const CircleAvatar(
              radius: 26, backgroundImage: AssetImage(profileImage)),
        ),
        title: Flexible(
          child: AppText(
            text: '${user["title"]}',
            textColor: const Color.fromRGBO(44, 44, 46, 1),
            fontWeight: FontWeight.w500,
            fontsize: 16,
          ),
        ),
        subtitle: Row(
          children: [
            // ignore: unrelated_type_equality_checks
            if (user["seen"] == true)
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.done_all,
                  size: 20,
                  color: Color.fromRGBO(31, 162, 255, 1),
                ),
              ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: AppText(
                  overflow: TextOverflow.ellipsis,
                  text: '${user["message"]}',
                  textColor: const Color.fromRGBO(155, 155, 155, 1),
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
            AppText(
              text: '${user["time"]}',
              textColor: const Color.fromRGBO(155, 155, 155, 1),
              fontWeight: FontWeight.w400,
              fontsize: 12,
              maxLines: 1,
            ),
            // ignore: unrelated_type_equality_checks
            if (user["seen"] == true)
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${user["unRead"]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
