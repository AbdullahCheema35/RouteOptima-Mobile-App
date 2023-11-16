import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _BarChart extends StatelessWidget {
  const _BarChart({required this.statsData, required this.isShowingMonth});

  final Map<String, dynamic> statsData;
  final bool isShowingMonth;

  @override
  Widget build(BuildContext context) {
    // calculate max in order to set the max y value
    int max = 0;
    for (var entry in statsData.entries) {
      final value = entry.value;
      final int averageWorkingHours = value['averageWorkingHours'].ceil();
      if (averageWorkingHours > max) {
        max = averageWorkingHours;
      }
    }

    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: max + 5,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue.shade200,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    // print("Inisde get titles -> value: $value");
    final intValue = value.toInt();
    if (isShowingMonth) {
      switch (intValue) {
        case 1:
          text = 'Jan';
          break;
        case 2:
          text = 'Feb';
          break;
        case 3:
          text = 'Mar';
          break;
        case 4:
          text = 'Apr';
          break;
        case 5:
          text = 'May';
          break;
        case 6:
          text = 'Jun';
          break;
        case 7:
          text = 'Jul';
          break;
        case 8:
          text = 'Aug';
          break;
        case 9:
          text = 'Sep';
          break;
        case 10:
          text = 'Oct';
          break;
        case 11:
          text = 'Nov';
          break;
        case 12:
          text = 'Dec';
          break;
        default:
          text = '';
      }
    } else {
      text = intValue.toString();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue.shade200,
          Colors.cyan.shade400,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups {
    return statsData.entries.map((entry) {
      final monthYear = entry.key;
      final value = entry.value;

      final averageWorkingHours = value['averageWorkingHours'].toString();

      return BarChartGroupData(
        x: int.parse(
            monthYear), // calculate x-axis value based on month/year (you might use an index or another approach),
        barRods: [
          BarChartRodData(
            toY: double.parse(averageWorkingHours).roundToDouble(),
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  // List<BarChartGroupData> get barGroups => [
  //       BarChartGroupData(
  //         x: 0,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 8,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 1,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 10,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 2,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 14,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 3,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 15,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 4,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 13,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 5,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 10,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 6,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 16,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //     ];
}

class WorkingHoursBarChart extends StatelessWidget {
  const WorkingHoursBarChart(
      {super.key, required this.statsData, required this.isShowingMonth});

  final Map<String, dynamic> statsData;
  final bool isShowingMonth;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(
        isShowingMonth: isShowingMonth,
        statsData: statsData,
      ),
    );
  }
}
