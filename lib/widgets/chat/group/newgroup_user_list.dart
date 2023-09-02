import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

class NewGroupUserList extends StatelessWidget {
  final List<User> users;
  final List<User> selectedUser;
  final void Function(User user) toggleUser;
  const NewGroupUserList(
      {super.key,
      required this.users,
      required this.selectedUser,
      required this.toggleUser});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (ctx, index) => UserList(
        user: users[index],
        selectedUser: selectedUser,
        toggleUser: (user) {
          toggleUser(user);
        },
      ),
    );
  }
}

class UserList extends ConsumerStatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final User user;
  final List<User> selectedUser;
  final void Function(User user) toggleUser;
  const UserList(
      {super.key,
      required this.user,
      required this.toggleUser,
      required this.selectedUser});

  @override
  UserListState createState() => UserListState();
}

class UserListState extends ConsumerState<UserList> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        color: widget.selectedUser.isNotEmpty &&
                widget.selectedUser.contains(widget.user)
            ? AppColor.secondary
            : Colors.white,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          onTap: () {
            widget.toggleUser(widget.user);
          },
          splashColor: Colors.grey[350],
          leading: Hero(
            tag: widget.user.userId,
            child: CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(
                    widget.user.image.isEmpty ? noImg : widget.user.image)),
          ),
          title: AppText(
            text: '${widget.user.userfirstname} ${widget.user.userlastname}',
            textColor: const Color.fromRGBO(44, 44, 46, 1),
            fontWeight: FontWeight.w500,
            fontsize: 16,
          ),
          trailing: widget.selectedUser.isNotEmpty &&
                  widget.selectedUser.contains(widget.user)
              ? const Icon(
                  Icons.check_circle,
                  size: 20,
                  color: AppColor.primary,
                )
              : null,
        ),
      ),
    );
  }
}
