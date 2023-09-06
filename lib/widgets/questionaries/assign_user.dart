import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

class AssignUser extends StatefulWidget {
  final Function(User user) addUser;
  final bool status;
  final List<dynamic>? assignedUserIds;
  const AssignUser({
    super.key,
    required this.addUser,
    this.assignedUserIds,
    this.status = false,
  });

  @override
  State<AssignUser> createState() => _AssignUserState();
}

class _AssignUserState extends State<AssignUser> {
  List<User> assignUsers = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8, right: 8, left: 2, bottom: 3),
          child: CustomText(
            title: 'Assign to',
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 45,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: currentUser["brokerId"]).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const CircularProgressIndicator.adaptive();
                }
                final usersListSnapshot = snapshot.data!.docs;
                List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
                return Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    final String searchText = textEditingValue.text.toLowerCase();
                    if (widget.status == true) {
                      return usersList.where((user) {
                        final String fullName = '${user.userfirstname} ${user.userlastname}'.toLowerCase();
                        final bool isAssigned = widget.assignedUserIds!.contains(user.userId);
                        return !isAssigned && fullName.contains(searchText);
                      }).map((user) => '${user.userfirstname} ${user.userlastname}');
                    } else {
                      return usersList.where((user) {
                        final String fullName = '${user.userfirstname} ${user.userlastname}'.toLowerCase();
                        return fullName.contains(searchText);
                      }).map((user) => '${user.userfirstname} ${user.userlastname}');
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onTap: () {},
                      decoration: InputDecoration(
                        hintText: '@',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    const itemHeight = 56.0; // Height of each option ListTile
                    final itemCount = options.length;
                    final dropdownHeight = itemHeight * itemCount;
                    return SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: Responsive.isMobile(context) ? 310 : 450,
                          height: dropdownHeight,
                          child: Material(
                            elevation: 4,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(3.0),
                              shrinkWrap: true,
                              itemCount: itemCount,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                    User selectedUser = usersList.firstWhere((user) => '${user.userfirstname} ${user.userlastname}' == option);
                                    widget.addUser(selectedUser);
                                    assignUsers.add(selectedUser);
                                    // setState(() {});
                                  },
                                  child: ListTile(
                                    title: Text(option),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
        const SizedBox(height: 10),
        Wrap(
          children: assignUsers.map((user) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Chip(
                label: Text('${user.userfirstname} ${user.userlastname}'),
                onDeleted: () {
                  setState(() {
                    assignUsers.remove(user);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
