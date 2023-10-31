import 'package:flutter_riverpod/flutter_riverpod.dart';

final headerTextProvider = StateNotifierProvider<HeaderTextStateNotifier, String>((ref) {
  return HeaderTextStateNotifier();
});

class HeaderTextStateNotifier extends StateNotifier<String> {
  HeaderTextStateNotifier() : super('');
}
