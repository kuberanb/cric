import 'dart:math';
import 'package:cric/features/chart/presentation/pages/chart_screen.dart';
import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:cric/features/live/presentation/controllers/live_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LiveScreen extends StatelessWidget {
  LiveScreen({super.key});

  String formatMatchDate(String? timestampStr) {
    if (timestampStr == null) return 'N/A';

    try {
      final millis = int.tryParse(timestampStr);
      if (millis == null) return 'Invalid';

      final date = DateTime.fromMillisecondsSinceEpoch(millis);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return 'Invalid';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Matches"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchLiveData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.liveData.value == null && controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        final liveData = controller.liveData.value;
        if (liveData == null || liveData.typeMatches == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final List liveMatches = liveData.typeMatches!
            .expand((type) => type.seriesMatches ?? [])
            .expand((series) => series.seriesAdWrapper?.matches ?? [])
            .toList();

        // ✅ Sort live matches (not 'complete') to the top
        liveMatches.sort((a, b) {
          final aLive = (a.matchInfo?.state?.toLowerCase() ?? '') != 'complete';
          final bLive = (b.matchInfo?.state?.toLowerCase() ?? '') != 'complete';
          return bLive.toString().compareTo(aLive.toString());
        });

        if (liveMatches.isEmpty) {
          return const Center(child: Text("No matches available."));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final isDesktop = constraints.maxWidth >= 1024;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: liveMatches.length,
              itemBuilder: (context, index) {
                final match = liveMatches[index];
                final matchInfo = match.matchInfo;
                final score = match.matchScore;

                if (matchInfo == null) return const SizedBox();

                final team1 = matchInfo.team1?.teamName ?? "Team 1";
                final team2 = matchInfo.team2?.teamName ?? "Team 2";
                final team1Score = score?.team1Score?.inngs1;
                final team2Score = score?.team2Score?.inngs1;

                // ✅ Match is live unless its state is 'complete'
                final isLive =
                    (matchInfo.state?.toLowerCase() ?? '') != 'complete';

                // final rng = Random();
                // final odds1 = (rng.nextDouble() * 0.8 + 0.1).toStringAsFixed(2);
                // final odds2 = (rng.nextDouble() * 0.8 + 0.1).toStringAsFixed(2);

                final latestOdds1 =
                    match.matchOdds?.team1OddsHistory?.isNotEmpty == true
                    ? match.matchOdds!.team1OddsHistory!.last.value
                          ?.toStringAsFixed(2)
                    : 'N/A';

                final latestOdds2 =
                    match.matchOdds?.team2OddsHistory?.isNotEmpty == true
                    ? match.matchOdds!.team2OddsHistory!.last.value
                          ?.toStringAsFixed(2)
                    : 'N/A';

                return Card(
                  elevation: isLive ? 5 : 2,
                  color: isLive ? Colors.lightGreen[50] : null,
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${matchInfo.seriesName ?? ''} - ${matchInfo.matchDesc ?? ''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isLive ? Colors.green[700] : null,
                            ),
                          ),
                        ),
                        if (isLive)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text("Status: ${matchInfo.status ?? 'N/A'}"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: isTablet || isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildMatchInfo(matchInfo)),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildScoreSection(
                                      team1,
                                      team1Score,
                                      team2,
                                      team2Score,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildOddsSection(
                                      team1,
                                      // odds1
                                      latestOdds1,
                                      team2,

                                      // odds2
                                      latestOdds2,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  if (isLive)
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          Get.to(
                                            () => ChartScreen(
                                              matchOdds: match.matchOdds,
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.bar_chart_sharp),
                                      ),
                                    ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildMatchInfo(matchInfo),
                                  const Divider(height: 20),
                                  _buildScoreSection(
                                    team1,
                                    team1Score,
                                    team2,
                                    team2Score,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildOddsSection(
                                    team1,
                                    latestOdds1,
                                    team2,
                                    latestOdds2,
                                  ),
                                  const SizedBox(height: 12),
                                  if (isLive)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.to(
                                              () => ChartScreen(
                                                matchOdds: match.matchOdds,
                                              ),
                                            );
                                          },
                                          child: Text("Chart"),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildMatchInfo(MatchInfo matchInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Match Info"),
        _infoRow("Match", matchInfo.matchDesc),
        _infoRow("Format", matchInfo.matchFormat),
        _infoRow("Ground", matchInfo.venueInfo?.ground),
        _infoRow("City", matchInfo.venueInfo?.city),
        _infoRow("Start", formatMatchDate(matchInfo.startDate)),
        _infoRow("End", formatMatchDate(matchInfo.endDate)),
        _infoRow("Status", matchInfo.status),
      ],
    );
  }

  Widget _buildScoreSection(
    String team1,
    Inngs1? team1Score,
    String team2,
    Inngs1? team2Score,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Score"),
        scoreRow(team1, team1Score),
        scoreRow(team2, team2Score),
      ],
    );
  }

  Widget _buildOddsSection(
    String team1,
    String odds1,
    String team2,
    String odds2,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Odds"),
        oddsRow(team1, odds1),
        oddsRow(team2, odds2),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  Widget scoreRow(String team, Inngs1? inngs) {
    if (inngs == null) return Text("$team: Yet to bat");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(child: Text(team)),
          Text(
            "${inngs.runs}/${inngs.wickets} in ${inngs.overs?.toStringAsFixed(1) ?? '-'} ov",
          ),
        ],
      ),
    );
  }

  Widget oddsRow(String team, String odds) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(child: Text(team)),
          Text("Win Odds: $odds"),
        ],
      ),
    );
  }
}
