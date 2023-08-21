import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

class AssignUser extends StatelessWidget {
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
                final QuerySnapshot<Map<String, dynamic>> usersListSnapshot = snapshot.data!;
                final List<User> usersList = usersListSnapshot.docs
                    .map((doc) => User(
                          whatsAppNumber: doc["whatsAppNumber"],
                          brokerId: doc['brokerId'],
                          status: doc['status'],
                          userfirstname: doc['userfirstname'],
                          userlastname: doc['userlastname'],
                          userId: doc['userId'],
                          mobile: doc['mobile'],
                          email: doc['email'],
                          role: doc['role'],
                          image: doc['image'],
                        ))
                    .toList();
                return Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    // if (textEditingValue.text.isEmpty) {
                    //   return const Iterable<String>.empty();
                    // }
                    final String searchText = textEditingValue.text.toLowerCase();
                    if (status == true) {
                      return usersList.where((user) {
                        final String fullName = '${user.userfirstname} ${user.userlastname}'.toLowerCase();
                        final bool isAssigned = assignedUserIds!.contains(user.userId);
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
                                    addUser(selectedUser);
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
      ],
    );
  }
}
