import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/device.dart';
import '../../../utils/styles.dart';
import 'download_today_repport.dart';
import 'temp_graphic_provider.dart';

class TempGraphicView extends StatelessWidget {
  final Device device;
  const TempGraphicView({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TempGraphicProvider>(
        create: (context) => TempGraphicProvider(device),
        builder: (context, __) {
          final provider = context.watch<TempGraphicProvider>();
          return SizedBox(
            height: 150,
            child: Column(
              children: [
                Expanded(
                  child: LineChart(
                    LineChartData(
                    
                      lineTouchData: LineTouchData(enabled: true),
                      lineBarsData: [
                        LineChartBarData(
                          barWidth: 3,
                          showingIndicators: [0],
                          shadow: const Shadow(
                            blurRadius: 8,
                            color: Colors.black26,
                          ),
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
                            //getTitlesWidget: bottomTitleWidgets,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
/*                             interval:
                              ((provider.maxTemp - provider.minTemp) ~/ 3).toDouble(),  */
/*                 getTitlesWidget: leftTitleWidgets,
                          interval:
                              ((provider.maxTemp - provider.minTemp) ~/ 3).toDouble(), */
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
                const DownloadTodayRepport(),
              ],
            ),
          );
        });
  }
}
