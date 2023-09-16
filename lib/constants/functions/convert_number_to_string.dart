String convertToWords(int number) {
  if (number == 0) {
    return 'Zero';
  }

  List<String> units = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];
  List<String> teens = ['Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
  List<String> tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

  List<String> scales = ['', 'Thousand', 'Million', 'Billion', 'Trillion', 'Quadrillion'];

  String result = '';
  int scaleIndex = 0;

  while (number > 0) {
    int currentSegment = number % 1000;
    if (currentSegment > 0) {
      if (result.isNotEmpty) {
        result = ' ${scales[scaleIndex]}$result';
      }
      if (currentSegment >= 100) {
        result = '${units[currentSegment ~/ 100]} Hundred$result';
        currentSegment %= 100;
      }

      if (currentSegment >= 20) {
        result = '${tens[currentSegment ~/ 10]}${currentSegment % 10 > 0 ? ' ${units[currentSegment % 10]}' : ''}$result';
      } else if (currentSegment >= 10) {
        result = '${teens[currentSegment - 10]}$result';
      } else if (currentSegment > 0) {
        result = '${units[currentSegment]}$result';
      }
    }

    number ~/= 1000;
    scaleIndex++;
  }

  return result.trim();
}
