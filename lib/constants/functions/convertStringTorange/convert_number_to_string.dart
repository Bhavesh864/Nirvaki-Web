String convertToCroresAndLakhs(String value) {
  try {
    int numericValue = int.parse(value);
    double inCrores = numericValue / 10000000.0;
    double inLakhs = numericValue / 100000.0;

    if (inCrores >= 1) {
      return '${inCrores.toStringAsFixed(2)} Cr';
    } else if (inLakhs >= 1) {
      return '${inLakhs.toStringAsFixed(2)} L';
    } else {
      return numericValue.toString();
    }
  } catch (e) {
    return '';
  }
}
