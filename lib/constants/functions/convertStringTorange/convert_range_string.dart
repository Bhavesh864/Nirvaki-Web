String formatValue(double value) {
  if (value >= 10000000) {
    double crores = value / 10000000;
    return '₹${crores.toStringAsFixed(0)} Crores';
  } else if (value >= 100000) {
    double lakhs = value / 100000;
    return '₹${lakhs.toStringAsFixed(0)} Lakhs';
  } else {
    return '₹${value.toStringAsFixed(0)}';
  }
}
