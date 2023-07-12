import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryQuestionsIndex extends StateNotifier<int> {
  InventoryQuestionsIndex() : super(0);

  void increament() {
    state++;
  }

  void decreament() {
    state--;
  }
}
