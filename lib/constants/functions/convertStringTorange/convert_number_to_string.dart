String convertToCroresAndLakhs(String value) {
  try {
    int numericValue = int.parse(value);

    if (numericValue >= 100000) {
      double inCrores = numericValue / 10000000.0;
      if (inCrores >= 1) {
        return '${inCrores.toStringAsFixed(0)} Crore';
      } else {
        double inLakhs = numericValue / 100000.0;
        if (inLakhs >= 1) {
          return '${inLakhs.toStringAsFixed(0)} Lakh';
        } else {
          return numericValue.toString();
        }
      }
    } else {
      return numericValue.toString();
    }
  } catch (e) {
    return 'Invalid input';
  }
}
