import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

class NewGroupUserList extends StatelessWidget {
  final List<User> users;
  final List<String> selectedUser;
  final void Function(User user) toggleUser;

  const NewGroupUserList({
    super.key,
    required this.users,
    required this.selectedUser,
    required this.toggleUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (ctx, index) {
        final user = users[index];
        return Material(
          color: Colors.white,
          child: Container(
            color: selectedUser.isNotEmpty && selectedUser.contains(user.userId) ? AppColor.secondary : Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              onTap: () {
                toggleUser(user);
              },
              splashColor: Colors.grey[350],
              leading: Hero(
                tag: user.userId,
                child: CircleAvatar(radius: 26, backgroundImage: NetworkImage(user.image.isEmpty ? noImg : user.image)),
              ),
              title: AppText(
                text: '${user.userfirstname} ${user.userlastname}',
                textColor: const Color.fromRGBO(44, 44, 46, 1),
                fontWeight: FontWeight.w500,
                fontsize: 16,
              ),
              trailing: selectedUser.isNotEmpty && selectedUser.contains(user.userId)
                  ? const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppColor.primary,
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
