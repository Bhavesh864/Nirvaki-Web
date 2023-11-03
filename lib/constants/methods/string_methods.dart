String toPascalCase(String input) {
  if (input.isEmpty) {
    return input;
  }

  final words = input.split(' ');
  final pascalCaseWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  });

  return pascalCaseWords.join(' ');
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
