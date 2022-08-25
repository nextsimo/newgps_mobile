import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/utils/styles.dart';
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
          '$hours h',
          style: style,
        ),
        Text(
          '$minutesLeft m',
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
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ]);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            CloseButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.portraitUp,
                ]);
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // titlew
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: true),
                    lineBarsData: [
                      LineChartBarData(
                        barWidth: 3,
                        showingIndicators: provider.showIndexed,
                        shadow: const Shadow(
                          blurRadius: 8,
                          color: Colors.black26,
                        ),
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
                        color: Colors.red,
                        dotData: FlDotData(
                          show: true,
                        ),
                      ),
                    ],
                    maxY: provider.maxTemp,
                    minY: provider.minTemp,
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
                          interval: ((provider.maxTemp - provider.minTemp) ~/ 3)
                              .toDouble(),
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    backgroundColor: AppConsts.mainColor.withOpacity(0.2),
                    borderData: FlBorderData(
                      border: const Border(
                        left: BorderSide(
                          color: Colors.black,
                        ),
                        bottom: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: false,
                      drawHorizontalLine: false,
                      drawVerticalLine: false,
                    ),
                    //clipData: FlClipData.all(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
