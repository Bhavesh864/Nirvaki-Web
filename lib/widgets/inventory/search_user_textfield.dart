import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';

class SearchByUser extends StatefulWidget {
  final Question question;
  final Function(Map<String, dynamic> data) onpressed;
  const SearchByUser({
    super.key,
    required this.question,
    required this.onpressed,
  });

  @override
  State<SearchByUser> createState() => _SearchByUserState();
}

class _SearchByUserState extends State<SearchByUser> {
  TextEditingController controller = TextEditingController();
  String name = "";
  String getNextSearchValue() {
    if (name.isEmpty) {
      return 'a';
    } else {
      final lastChar = name.codeUnitAt(name.length - 1);
      final nextChar = String.fromCharCode(lastChar + 1);
      return name.substring(0, name.length - 1) + nextChar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelTextInputField(
          inputController: controller,
          labelText: widget.question.questionTitle,
          onChanged: (value) {
            setState(() {
              name = value.toLowerCase();
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter ${widget.question.questionTitle}";
            }
            return null;
          },
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("userfirstname",
                  isGreaterThanOrEqualTo: name,
                  isLessThan: getNextSearchValue())
              .snapshots(),
          builder: (context, snapshot) {
            return ConnectionState.waiting == snapshot.connectionState
                ? const Center()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index].data();
                      return GestureDetector(
                        onTap: () {
                          widget.onpressed(data!);
                        },
                        child: ListTile(
                          title: Text(data?["userfirstname"]),
                          subtitle: Text(data?["email"]),
                        ),
                      );
                    },
                  );
          },
        )
      ],
    );
  }
}
