import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/chatModels/group_model.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

// ignore: must_be_immutable
class AddGroupMembers extends StatefulWidget {
  AddGroupMembers({super.key, required this.userInfo, required this.contactId});
  List<String> userInfo;
  final String contactId;

  @override
  State<AddGroupMembers> createState() => _AddGroupMembersState();
}

class _AddGroupMembersState extends State<AddGroupMembers> {
  List<String> selectedUser = [];

  void toggleUser(User user) {
    setState(() {
      if (selectedUser.contains(user.userId)) {
        selectedUser.remove(user.userId);
      } else {
        selectedUser.add(user.userId);
      }
    });
  }

  onSubmit() {
    if (selectedUser.isEmpty) {
      customSnackBar(context: context, text: 'Atleast one user has to be selected');
      return;
    }
    Group.addMembersOnGroup(groupId: widget.contactId, userids: selectedUser);
    customSnackBar(context: context, text: 'Added successfully');
    Navigator.of(context).pop();
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const ChatListScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        // backgroundColor: Colors.white,
        iconTheme: const IconThemeData(size: 22),
        title: const AppText(
          text: 'Add Members',
          textColor: Color.fromARGB(255, 57, 57, 57),
          fontWeight: FontWeight.w600,
          fontsize: 16,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: currentUser["brokerId"]).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasData) {
                final usersListSnapshot = snapshot.data!.docs;
                List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
                List<User> filterUser = usersList.where((element) => !widget.userInfo.contains(element.userId)).toList();

                if (filterUser.isEmpty) {
                  return const Center(
                    child: AppText(
                      text: 'Empty User List',
                      textColor: Color.fromRGBO(44, 44, 46, 1),
                      fontWeight: FontWeight.w500,
                      fontsize: 16,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filterUser.length,
                  itemBuilder: (ctx, index) {
                    final user = filterUser[index];

                    return Container(
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
                    );
                  },
                );
              }
              return const SizedBox();
            }),
      ),
      floatingActionButton: selectedUser.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: onSubmit,
              backgroundColor: AppColor.primary,
              child: const Icon(Icons.check),
            ),
    );
  }
}
