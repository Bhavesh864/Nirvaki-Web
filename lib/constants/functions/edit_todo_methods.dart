import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../firebase/detailsModels/card_details.dart';
import '../firebase/detailsModels/todo_details.dart';

void startEditingTodoName(String todoName, bool isEditingTodoName, TextEditingController todoNameEditingController) {
  // setState(() {
  isEditingTodoName = true;
  todoNameEditingController.text = todoName;
  // });
}

void cancelEditingTodoName(bool isEditingTodoName, TextEditingController todoNameEditingController) {
  // setState(() {
  isEditingTodoName = false;
  todoNameEditingController.clear();
  // });
}

void startEditingTodoDescription(String des, bool iseditingTodoDescription, TextEditingController todoDescriptionEditingController) {
  // setState(() {
  iseditingTodoDescription = true;
  todoDescriptionEditingController.text = des;
  // });
}

void cancelEditingTodoDescription(bool iseditingTodoDescription, TextEditingController todoDescriptionEditingController) {
  // setState(() {
  iseditingTodoDescription = false;
  todoDescriptionEditingController.clear();
  // });
}

void updateDate(itemid, BuildContext context) {
  showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 1),
  ).then(
    (pickedDate) {
      if (pickedDate == null) {
        return;
      }
      DateFormat formatter = DateFormat('dd-MM-yyyy');
      TodoDetails.updateCardDate(id: itemid, duedate: formatter.format(pickedDate));
      CardDetails.updateCardDate(id: itemid, duedate: formatter.format(pickedDate));
    },
  );
}
