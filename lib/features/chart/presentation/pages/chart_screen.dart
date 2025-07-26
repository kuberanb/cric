import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:cric/features/chart/presentation/controllers/chart_controller.dart';
import 'package:cric/features/chart/presentation/widgets/odds_line_chart.dart';

class ChartScreen extends StatelessWidget {
  final MatchOdds matchOdds;

  const ChartScreen({super.key, required this.matchOdds});

  @override
  Widget build(BuildContext context) {
    Get.put(ChartController(matchOdds: matchOdds), permanent: false);
    final controller = Get.find<ChartController>();
    log(
      "methodOdds l : ${matchOdds.team1OddsHistory?.length ?? 0}  n : ${matchOdds.team2OddsHistory?.length ?? 0} ",
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Win Probability Trend")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: OddsLineChart(
                team1Data: controller.matchOdds.team1OddsHistory ?? [],
                team2Data: controller.matchOdds.team2OddsHistory ?? [],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                LegendDot(color: Colors.blue, label: "Team 1"),
                LegendDot(color: Colors.red, label: "Team 2"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Row(
      children: [
        Container(
          width: 14 * textScale,
          height: 14 * textScale,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(label, style: TextStyle(fontSize: 14 * textScale)),
      ],
    );
  }
}
