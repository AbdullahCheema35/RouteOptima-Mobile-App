import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  MyPieChartState createState() => MyPieChartState();
}

class MyPieChartState extends State<MyPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pie Chart Example'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 10,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              centerSpaceRadius: 100,
              sections: [
                PieChartSectionData(
                  color: touchedIndex == 0 ? Colors.grey : Colors.blue,
                  value: 40,
                  title: '40%',
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: touchedIndex == 1 ? Colors.grey : Colors.green,
                  value: 30,
                  title: '30%',
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: touchedIndex == 2 ? Colors.grey : Colors.orange,
                  value: 20,
                  title: '20%',
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: touchedIndex == 3 ? Colors.grey : Colors.red,
                  value: 10,
                  title: '10%',
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
