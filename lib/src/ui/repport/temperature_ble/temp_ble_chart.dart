import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:provider/provider.dart';
import 'temperature_repport_provider.dart';

class TempBleChart extends StatelessWidget {
  const TempBleChart({Key? key}) : super(key: key);

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: _convertMinutesToHours(value.toInt()),
    );
  }

  // covert minutes to hours:minutes
  Widget _convertMinutesToHours(int minutes) {
    const style = TextStyle(
      fontSize: 7,
      color: Colors.purple,
      fontWeight: FontWeight.w500,
    );
    int hours = minutes ~/ 60;
    int minutesLeft = minutes % 60;
    return Column(
      children: [
        Text(
          '$hours',
          style: style,
        ),
        Text(
          minutesLeft.toString(),
          style: style,
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value.toInt()}',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // read provider
    final provider = context.read<TemperatureRepportProvider>();
    return Scaffold(
      appBar: const CustomAppBar(
        actions: [
          CloseButton(
            color: Colors.black,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(enabled: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: provider.repports.map(
                        (model) {
                          debugPrint(
                              "T---> ${model.updatedAt} -> ${model.temperature1}");
                          return FlSpot(
                            ((model.updatedAt.hour.toDouble() * 60) +
                                model.updatedAt.minute +
                                (model.updatedAt.second / 60)),
                            model.temperature1.toDouble(),
                          );
                        },
                      ).toList(),
                      isCurved: true,
                      barWidth: 1.3,
                      color: Colors.green,
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                  ],
                  maxY: 80,
                  minY: -45,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 30,
                        getTitlesWidget: bottomTitleWidgets,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: leftTitleWidgets,
                        interval: 5,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  backgroundColor: Colors.grey[300],
                  borderData: FlBorderData(
                      border: const Border(
                    left: BorderSide(
                      color: Colors.black,
                    ),
                    bottom: BorderSide(
                      color: Colors.black,
                    ),
                  )),
                  gridData: FlGridData(
                    show: false,
                    drawHorizontalLine: false,
                    drawVerticalLine: false,
                  ),
                  clipData: FlClipData.all(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
