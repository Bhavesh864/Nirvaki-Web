import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

class AssignUser extends ConsumerStatefulWidget {
  final Function(List<User> user) addUser;
  final bool status;
  final List<dynamic>? assignedUserIds;
  const AssignUser({super.key, required this.addUser, this.assignedUserIds, this.status = false});

  @override
  ConsumerState<AssignUser> createState() => _AssignUserState();
}

class _AssignUserState extends ConsumerState<AssignUser> {
  TextEditingController _textEditingController = TextEditingController();
  List<User> assignUsers = [];
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.status) {
      assignUsers = [];
    } else {
      setData();
    }
  }

  setData() async {
    final List<User> users = await User.getListOfUsersByIds(widget.assignedUserIds!);
    assignUsers.addAll(users);
    widget.addUser(assignUsers);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.read(userDataProvider);

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
              stream: FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: user?.brokerId).snapshots(),
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
                        final bool alradyExist = assignUsers.any((ele) => ele.userId == user.userId);
                        return !alradyExist && !isAssigned && fullName.contains(searchText);
                      }).map((user) => '${user.userfirstname} ${user.userlastname}');
                    } else {
                      return usersList.where((user) {
                        final String fullName = '${user.userfirstname} ${user.userlastname}'.toLowerCase();
                        final bool alradyExist = assignUsers.any((ele) => ele.userId == user.userId);
                        return !alradyExist && fullName.contains(searchText);
                      }).map((user) => '${user.userfirstname} ${user.userlastname}');
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    _textEditingController = textEditingController;
                    _focusNode = focusNode;
                    return TextField(
                      controller: _textEditingController,
                      focusNode: focusNode,
                      onTap: () {},
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    const itemHeight = 56.0;
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
                                    setState(() {
                                      assignUsers.add(selectedUser);
                                    });
                                    widget.addUser(assignUsers);
                                    _textEditingController.clear();
                                    _focusNode.unfocus();
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
                backgroundColor: AppColor.secondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                label: AppText(
                  text: '${user.userfirstname} ${user.userlastname}',
                  fontsize: 14,
                ),
                onDeleted: () {
                  setState(() {
                    assignUsers.remove(user);
                    widget.addUser(assignUsers);
                  });
                },
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
