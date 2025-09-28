import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';

class TwoSlicePieChart extends StatelessWidget {
  final String mainLabel; // e.g., "CPU Usage", "RAM Usage"
  final RxDouble mainValue; // value of the first slice
  final double totalValue; // total value to calculate second slice
  final Color mainColor;
  final Color secondaryColor;

  const TwoSlicePieChart({
    super.key,
    required this.mainLabel,
    required this.mainValue,
    required this.totalValue,
    this.mainColor = Colors.blue,
    this.secondaryColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double secondaryValue = totalValue - mainValue.value;
      if (secondaryValue < 0) secondaryValue = 0;

      Map<String, double> dataMap = {
        mainLabel: mainValue.value,
        "Remaining": secondaryValue,
      };

      return PieChart(
        dataMap: dataMap,
        chartRadius: MediaQuery.of(context).size.width / 3,
        chartType: ChartType.disc,
        colorList: [mainColor, secondaryColor],
        legendOptions: const LegendOptions(
          showLegends: false,
          legendPosition: LegendPosition.bottom,
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValues: true,
          showChartValuesInPercentage: true,
        ),
      );
    });
  }
}
