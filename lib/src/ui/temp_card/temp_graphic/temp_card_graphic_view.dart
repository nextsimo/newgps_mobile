import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/device.dart';
import 'temp_graphic_provider.dart';

class TempGraphicView extends StatelessWidget {
  final Device device;
  const TempGraphicView({super.key, required this.device});

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (value == 0) {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: _convertMinutesToHours(value.toInt()),
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

  // covert minutes to hours:minutes
  Widget _convertMinutesToHours(int minutes) {
    const style = TextStyle(
      fontSize: 7,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    );
    int hours = minutes ~/ 60;
    return Text(
      '$hours h',
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TempGraphicProvider>(
        create: (context) => TempGraphicProvider(device),
        builder: (context, __) {
          final provider = context.watch<TempGraphicProvider>();
          if (provider.loading) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          if (provider.repportsChart.isEmpty) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Veuillez contactez service après vente pour plus d\'informations.',
                  style: TextStyle(
                    height: 1.8,
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
          return SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: true),
                lineBarsData: [
                  LineChartBarData(
                    barWidth: 1.5,
                    isCurved: true,
                    spots: provider.repportsChart.map(
                      (model) {
                        return FlSpot(
                          ((model.updatedAt.hour.toDouble() * 60) +
                              model.updatedAt.minute +
                              (model.updatedAt.second / 60)),
                          model.temperature1.toDouble(),
                        );
                      },
                    ).toList(),
                    color: Colors.blue,
                    dotData: const FlDotData(show: true),
                    isStrokeCapRound: true,
                    isStrokeJoinRound: true,
                  ),
                ],
                maxY: provider.maxTemp,
                minY: provider.minTemp,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 80,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
/*                       getTitlesWidget: leftTitleWidgets,
                      interval: ((provider.maxTemp - provider.minTemp) ~/ 3)
                          .toDouble(), */
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                backgroundColor: const Color.fromARGB(23, 136, 190, 61),
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
                gridData: const FlGridData(
                  show: false,
                  drawHorizontalLine: false,
                  drawVerticalLine: false,
                ),
                //clipData: FlClipData.all(),
              ),
            ),
          );
        });
  }
}
