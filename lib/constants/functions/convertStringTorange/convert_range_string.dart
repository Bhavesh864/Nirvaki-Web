String formatValue(double value) {
  if (value >= 10000000) {
    double crores = value / 10000000;
    if (crores % 1 == 0) {
      return '₹${crores.toStringAsFixed(0)} Cr';
    } else {
      return '₹${crores.toStringAsFixed(2)} Cr';
    }
  } else if (value >= 100000) {
    double lakhs = value / 100000;
    if (lakhs % 1 == 0) {
      return '₹${lakhs.toStringAsFixed(0)} L';
    } else {
      return '₹${lakhs.toStringAsFixed(0)} L';
    }
  } else {
    return '₹${value.toStringAsFixed(0)}';
  }
}
