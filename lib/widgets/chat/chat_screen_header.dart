import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';
import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';

class ChatScreenHeader extends StatelessWidget {
  const ChatScreenHeader({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const ChatUserProfile(),
              ),
            );
          },
          child: Row(
            children: [
              Hero(
                tag: user.userId,
                child: CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        NetworkImage(user.image.isEmpty ? noImg : user.image)),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "${user.userfirstname} ${user.userlastname}",
                    textColor: const Color.fromRGBO(44, 44, 46, 1),
                    fontWeight: FontWeight.w500,
                    fontsize: 16,
                  ),
                  const AppText(
                    text: "11:20",
                    textColor: Color.fromRGBO(155, 155, 155, 1),
                    fontWeight: FontWeight.w400,
                    fontsize: 15,
                    maxLines: 1,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
