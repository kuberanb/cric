import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OddsLineChart extends StatelessWidget {
  final List<OddsPoint> team1Data;
  final List<OddsPoint> team2Data;

  const OddsLineChart({
    super.key,
    required this.team1Data,
    required this.team2Data,
  });

  List<FlSpot> _convertToSpots(List<OddsPoint> data) {
    return data
        .where((e) => e.value != null && e.timestamp != null)
        .map(
          (e) =>
              FlSpot(e.timestamp!.millisecondsSinceEpoch.toDouble(), e.value!),
        )
        .toList();
  }

  String _formatTimestamp(double millis) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis.toInt());
    return DateFormat.Hm().format(date); // e.g. 12:30
  }

  @override
  Widget build(BuildContext context) {
    final team1Spots = _convertToSpots(team1Data);
    final team2Spots = _convertToSpots(team2Data);

    if (team1Spots.isEmpty && team2Spots.isEmpty) {
      return const Center(child: Text("No data available for chart."));
    }

    final allSpots = [...team1Spots, ...team2Spots];
    allSpots.sort((a, b) => a.x.compareTo(b.x));

    final minX = allSpots.first.x;
    final maxX = allSpots.last.x;
    const minY = 0.0;
    const maxY = 1.0;

    final safeIntervalX = ((maxX - minX) / 4)
        .clamp(60000, double.infinity)
        .toDouble(); // min 1 min

    final textScale = MediaQuery.of(context).textScaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Team Win Probability Over Time",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18 * textScale,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black26),
                  bottom: BorderSide(color: Colors.black26),
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.2,
                    getTitlesWidget: (value, meta) => Text(
                      '${(value * 100).round()}%',
                      style: TextStyle(fontSize: 10 * textScale),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: safeIntervalX,
                    getTitlesWidget: (value, meta) => Text(
                      _formatTimestamp(value),
                      style: TextStyle(fontSize: 10 * textScale),
                    ),
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: team1Spots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: team2Spots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
