import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../../screens/main_screens/chat_screens/chat_list_screen.dart';

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
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(user.image.isEmpty ? noImg : user.image),
                  ),
                ),
              ),
              title: Row(
                children: [
                  AppText(
                    text: '${user.userfirstname} ${user.userlastname}',
                    textColor: const Color.fromRGBO(44, 44, 46, 1),
                    fontWeight: FontWeight.w500,
                    fontsize: 16,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // CustomChip(
                  //   label: AppText(
                  //     text: user.role,
                  //     fontsize: 9,
                  //   ),
                  // ),
                ],
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

class GroupAndUsersMergedListToForward extends StatelessWidget {
  final List<ChatItem> users;
  final List<String> selectedUser;
  final void Function(ChatItem user) toggleUser;

  const GroupAndUsersMergedListToForward({
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
            color: selectedUser.isNotEmpty && selectedUser.contains(user.id) ? AppColor.secondary : Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              onTap: () {
                toggleUser(user);
              },
              splashColor: Colors.grey[350],
              leading: Hero(
                tag: user.id,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(user.profilePic.isEmpty ? noImg : user.profilePic),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: AppText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: user.name,
                      textColor: const Color.fromRGBO(44, 44, 46, 1),
                      fontWeight: FontWeight.w500,
                      fontsize: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              trailing: selectedUser.isNotEmpty && selectedUser.contains(user.id)
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
