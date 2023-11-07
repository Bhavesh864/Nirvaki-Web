String formatValue(double value) {
  if (value >= 10000000) {
    double crores = value / 10000000;
    if (crores % 1 == 0) {
      return '₹${crores.toStringAsFixed(0)} Cr';
    } else {
      return '₹${crores.toStringAsFixed(1)} Cr';
    }
  } else if (value >= 100000) {
    double lakhs = value / 100000;
    if (lakhs % 1 == 0) {
      return '₹${lakhs.toStringAsFixed(2)} L';
    } else {
      return '₹${lakhs.toStringAsFixed(2)} L';
    }
  } else {
    return '₹${value.toStringAsFixed(0)}';
  }
}

String formatValueforOnlyNumbers(double value) {
  if (value >= 10000000) {
    double result = value / 10000000;
    if (result % 1 == 0) {
      return result.toStringAsFixed(0);
    } else {
      return result.toStringAsFixed(2);
    }
  } else if (value >= 100000) {
    double result = value / 100000;
    if (result % 1 == 0) {
      return result.toStringAsFixed(0);
    } else {
      return result.toStringAsFixed(2);
    }
  } else {
    return value.toStringAsFixed(0);
  }
}

String formatValueForAcre(double value) {
  double result;
  if (value >= 10000000) {
    result = value / 10000000;
  } else if (value >= 100000) {
    result = value / 100000;
  } else {
    result = value;
  }

  return result.toStringAsFixed(2);
}
