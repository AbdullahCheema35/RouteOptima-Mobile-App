// OnTimeDeliveriesPieChart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// class OnTimeDeliveriesPieChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const AspectRatio(
//       aspectRatio: 1.3,
//       child: PieChart(

//       ),
//     );
//   }
// }

class OnTimeDeliveriesPieChart extends StatefulWidget {
  const OnTimeDeliveriesPieChart({super.key, required this.statsData});

  final Map<String, dynamic> statsData;

  @override
  State<StatefulWidget> createState() => OnTimeDeliveriesPieChartState();
}

class OnTimeDeliveriesPieChartState extends State<OnTimeDeliveriesPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
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
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildIndicator(
                color: Colors.blue,
                text: 'On-Time', // Update text
                value: widget.statsData[
                    'onTimeDeliveries'], // Use on-time deliveries value
              ),
              const SizedBox(
                height: 4,
              ),
              buildIndicator(
                color: Colors.yellow,
                text: 'Late', // Update text
                value: widget
                    .statsData['lateDeliveries'], // Use late deliveries value
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  Widget buildIndicator(
      {required Color color, required String text, required int value}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          // '$text: $value', // Display value
          text, // Display value
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    int onTime = widget.statsData['onTimeDeliveries'];
    int late = widget.statsData['lateDeliveries'];
    int total = onTime + late;

    return [
      PieChartSectionData(
        color: Colors.blue,
        value: onTime.toDouble(),
        title:
            '${((onTime / total) * 100).toStringAsFixed(0)}%', // Calculate percentage
        radius: touchedIndex == 0 ? 60.0 : 50.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 25.0 : 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: late.toDouble(),
        title:
            '${((late / total) * 100).toStringAsFixed(0)}%', // Calculate percentage
        radius: touchedIndex == 1 ? 60.0 : 50.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 25.0 : 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ];
  }
}
