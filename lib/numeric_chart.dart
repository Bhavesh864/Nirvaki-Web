import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:yes_broker/constants/utils/colors.dart';

class _SalesData {
  _SalesData(this.year, this.sales);

  final int year;
  final double sales;
}

Widget buildChart() {
  return SfCartesianChart(
    title: ChartTitle(text: 'Cartesian Chart'),
    margin: EdgeInsets.all(0),
    primaryXAxis: NumericAxis(isVisible: false),
    primaryYAxis: NumericAxis(isVisible: false, maximum: 4),
    series: [
      // SplineAreaSeries<_SalesData, double>(
      //   dataSource: getChartData,
      //   xValueMapper: (datum, index) => datum.sales,
      //   yValueMapper: (datum, index) => datum.year,
      // ),
      StackedColumn100Series<_SalesData, int>(
          color: AppColor.primary,
          dataSource: getChartData,
          xValueMapper: (_SalesData sales, _) => sales.year,
          yValueMapper: (_SalesData sales, index) => sales.sales,
          width: 0.2,
          spacing: 0 // Adjust the width factor here
          ),
    ],
  );
}

List<_SalesData> getChartData = [
  _SalesData(2001, 34000),
  _SalesData(2002, 5000),
  _SalesData(2003, 36000),
  _SalesData(2004, 37000),
  _SalesData(2005, 38000),
  _SalesData(2006, 31000),
];
