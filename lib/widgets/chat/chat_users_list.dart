import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/screens/main_screens/chat_screen.dart';

class ChatUserList extends StatelessWidget {
  final Function(int) onPressed;
  final List<User> users;
  const ChatUserList({
    super.key,
    required this.users,
    this.onPressed = _defaultOnTapFunction,
  });

  static void _defaultOnTapFunction(k) {}

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: users.length,
      itemBuilder: (ctx, index) {
        return Material(
          color: Colors.white,
          child: ListTile(
            minVerticalPadding: 0,
            // contentPadding: EdgeInsets.zero,
            dense: true,
            onTap: () {
              if (Responsive.isMobile(context)) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChatScreen(
                      user: users[index],
                    ),
                  ),
                );
              } else {
                onPressed(index);
              }
            },
            splashColor: Colors.grey[350],
            leading: // Hero(
                // tag: user.userId,
                CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(
                users[index].image.isEmpty ? noImg : users[index].image,
              ),
            ),
            // ),
            title: AppText(
              text: '${users[index].userfirstname} ${users[index].userlastname} ',
              textColor: const Color.fromRGBO(44, 44, 46, 1),
              fontWeight: FontWeight.w500,
              fontsize: 16,
            ),
            subtitle: const Row(
              children: [
                // if (user["seen"] == true)
                //   const Padding(
                //     padding: EdgeInsets.only(right: 5),
                //     child: Icon(
                //       Icons.done_all,
                //       size: 20,
                //       color: Color.fromRGBO(31, 162, 255, 1),
                //     ),
                //   ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: AppText(
                      overflow: TextOverflow.ellipsis,
                      text: 'Hey,',
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
              // mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(
                  text: '11:20 am',
                  textColor: Color.fromRGBO(155, 155, 155, 1),
                  fontWeight: FontWeight.w400,
                  fontsize: 10,
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
                      '2',
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
          ),
        );
      },
    );
  }
}
