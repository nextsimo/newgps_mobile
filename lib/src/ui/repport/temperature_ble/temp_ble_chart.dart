

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';

import '../../../utils/styles.dart';

class TempBleChart extends StatelessWidget {
  const TempBleChart({Key? key}) : super(key: key);

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 8,
      color: Colors.purple,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '08h';
        break;
      case 1:
        text = '09h';
        break;
      case 2:
        text = '10';
        break;
      case 3:
        text = '11h';
        break;
      case 4:
        text = '12h';
        break;
      case 5:
        text = '13h';
        break;
      case 6:
        text = '14h';
        break;
      case 7:
        text = '15h';
        break;
      case 8:
        text = '16h';
        break;
      case 9:
        text = '17h';
        break;
      case 10:
        text = '18h';
        break;
      case 11:
        text = '19h';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value + 0.5}',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(    
              border: Border(
                bottom: BorderSide(
                  color: AppConsts.mainColor,
                  width: 1,
                ),
              ),
            ),
            child: const Text(
              'Diagramme de température',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio:1.2,
              child: Padding(
                padding: const EdgeInsets.only(left: 28, right: 18),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 4),
                          FlSpot(1, 3.5),
                          FlSpot(2, 4.5),
                          FlSpot(3, 1),
                          FlSpot(4, 4),
                          FlSpot(5, 6),
                          FlSpot(6, 6.5),
                          FlSpot(7, 6),
                          FlSpot(8, 4),
                          FlSpot(9, 6),
                          FlSpot(10, 6),
                          FlSpot(11, 7),
                        ],
                        isCurved: true,
                        barWidth: 1.3,
                        color: Colors.green,
                        dotData: FlDotData(
                          show: false,
                        ),
                      ),
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 0),
                          FlSpot(1, 3),
                          FlSpot(2, 4),
                          FlSpot(3, 5),
                          FlSpot(4, 8),
                          FlSpot(5, 3),
                          FlSpot(6, 5),
                          FlSpot(7, 8),
                          FlSpot(8, 4),
                          FlSpot(9, 7),
                          FlSpot(10, 7),
                          FlSpot(11, 8),
                        ],
                        isCurved: true,
                        barWidth: 2,
                        color: Colors.blue,
                        dotData: FlDotData(
                          show: false,
                        ),
                      ),
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 7),
                          FlSpot(1, 3),
                          FlSpot(2, 4),
                          FlSpot(3, 0),
                          FlSpot(4, 3),
                          FlSpot(5, 4),
                          FlSpot(6, 5),
                          FlSpot(7, 3),
                          FlSpot(8, 2),
                          FlSpot(9, 4),
                          FlSpot(10, 1),
                          FlSpot(11, 3),
                        ],
                        isCurved: false,
                        barWidth: 2,
                        color: Colors.red,
                        dotData: FlDotData(
                          show: false,
                        ),
                      ),
                    ],
/*                     betweenBarsData: [
                      BetweenBarsData(
                        fromIndex: 0,
                        toIndex: 2,
                        color: Colors.red.withOpacity(0.3),
                      )
                    ], */
                    minY: 0,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: bottomTitleWidgets,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: leftTitleWidgets,
                          interval: 1,
                          reservedSize: 36,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      checkToShowHorizontalLine: (double value) {
                        return value == 1 || value == 6 || value == 4 || value == 5;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}