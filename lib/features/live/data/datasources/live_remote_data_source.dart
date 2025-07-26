import 'dart:convert';
import 'dart:math';
import 'dart:developer' as d;

import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class LiveRemoteDataSource {
  Future<LiveDataModel> fetchLiveData();
}

class LiveRemoteDataSourceImpl implements LiveRemoteDataSource {
  final Dio dio;
  LiveRemoteDataSourceImpl(this.dio);

  LiveDataModel previousData = LiveDataModel();
  void injectRandomOdds(LiveDataModel newData, LiveDataModel? oldData) {
    final now = DateTime.now();
    final random = Random();

    for (var i = 0; i < (newData.typeMatches?.length ?? 0); i++) {
      final newTypeMatch = newData.typeMatches![i];
      final oldTypeMatch = (oldData?.typeMatches?.length ?? 0) > i
          ? oldData!.typeMatches![i]
          : null;

      for (var j = 0; j < (newTypeMatch.seriesMatches?.length ?? 0); j++) {
        final newSeriesMatch = newTypeMatch.seriesMatches![j];
        final oldSeriesMatch = ((oldTypeMatch?.seriesMatches?.length ?? 0) > j)
            ? oldTypeMatch!.seriesMatches![j]
            : null;

        for (
          var k = 0;
          k < (newSeriesMatch.seriesAdWrapper?.matches?.length ?? 0);
          k++
        ) {
          final newMatch = newSeriesMatch.seriesAdWrapper!.matches![k];
          final oldMatch =
              (oldSeriesMatch?.seriesAdWrapper?.matches?.length ?? 0) > k
              ? oldSeriesMatch!.seriesAdWrapper!.matches![k]
              : null;

          newMatch.matchOdds ??= MatchOdds();
          newMatch.matchOdds!.team1OddsHistory ??= [];
          newMatch.matchOdds!.team2OddsHistory ??= [];

          // ⏳ Merge previous history
          if (oldMatch?.matchOdds?.team1OddsHistory != null) {
            newMatch.matchOdds!.team1OddsHistory!.addAll(
              oldMatch!.matchOdds!.team1OddsHistory!,
            );
          }

          if (oldMatch?.matchOdds?.team2OddsHistory != null) {
            newMatch.matchOdds!.team2OddsHistory!.addAll(
              oldMatch!.matchOdds!.team2OddsHistory!,
            );
          }

          // ➕ Add new random odds
          final oddsPoint1 = OddsPoint(
            value: double.parse(
              ((random.nextDouble() * 0.7) + 0.2).toStringAsFixed(2),
            ),
            timestamp: now,
          );
          final oddsPoint2 = OddsPoint(
            value: double.parse(
              ((random.nextDouble() * 0.7) + 0.2).toStringAsFixed(2),
            ),
            timestamp: now,
          );

          newMatch.matchOdds!.team1OddsHistory!.add(oddsPoint1);
          newMatch.matchOdds!.team2OddsHistory!.add(oddsPoint2);

          debugPrint(
            '✅ [${newMatch}] Odds History Lengths: Team1 = ${newMatch.matchOdds!.team1OddsHistory!.length}, Team2 = ${newMatch.matchOdds!.team2OddsHistory!.length}',
          );
        }
      }
    }
  }

  @override
  Future<LiveDataModel> fetchLiveData() async {
    // final response = await dio.get(
    //   'https://cricbuzz-cricket.p.rapidapi.com/matches/v1/live',
    //   options: Options(
    //     headers: {
    //       'X-RapidAPI-Key':
    //       '8902fcd258msha865ed62fabebe0p1e05a7jsn5f4d3c2a45a7',
    //       'X-RapidAPI-Host': 'cricbuzz-cricket.p.rapidapi.com',
    //     },
    //   ),
    // );

    //    LiveDataModel  data = LiveDataModel.fromJson(response.data);

    await Future.delayed(Duration(seconds: 2));

    LiveDataModel data = LiveDataModel.fromJson(
      jsonDecode('''{
    "typeMatches": [
        {
            "matchType": "International",
            "seriesMatches": [
                {
                    "seriesAdWrapper": {
                        "seriesId": 8786,
                        "seriesName": "India tour of England, 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 105778,
                                    "seriesId": 8786,
                                    "seriesName": "India tour of England, 2025",
                                    "matchDesc": "4th Test",
                                    "matchFormat": "TEST",
                                    "startDate": "1753264800000",
                                    "endDate": "1753635600000",
                                    "state": "Stumps",
                                    "status": "Day 3: Stumps - England lead by 186 runs",
                                    "team1": {
                                        "teamId": 2,
                                        "teamName": "India",
                                        "teamSName": "IND",
                                        "imageId": 719031
                                    },
                                    "team2": {
                                        "teamId": 9,
                                        "teamName": "England",
                                        "teamSName": "ENG",
                                        "imageId": 172123
                                    },
                                    "venueInfo": {
                                        "id": 65,
                                        "ground": "Emirates Old Trafford",
                                        "city": "Manchester",
                                        "timezone": "+01:00",
                                        "latitude": "53.463066",
                                        "longitude": "-2.291301"
                                    },
                                    "currBatTeamId": 9,
                                    "seriesStartDt": "1750291200000",
                                    "seriesEndDt": "1754352000000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Stumps"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 358,
                                            "wickets": 10,
                                            "overs": 114.1
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 544,
                                            "wickets": 7,
                                            "overs": 134.6
                                        }
                                    }
                                }
                            }
                        ]
                    }
                },
                {
                    "seriesAdWrapper": {
                        "seriesId": 10498,
                        "seriesName": "Budapest Cup, 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 128820,
                                    "seriesId": 10498,
                                    "seriesName": "Budapest Cup, 2025",
                                    "matchDesc": "3rd Match",
                                    "matchFormat": "T20",
                                    "startDate": "1753448400000",
                                    "endDate": "1753461000000",
                                    "state": "Complete",
                                    "status": "Hungary won by 70 runs",
                                    "team1": {
                                        "teamId": 550,
                                        "teamName": "Hungary",
                                        "teamSName": "HUN",
                                        "imageId": 172602
                                    },
                                    "team2": {
                                        "teamId": 537,
                                        "teamName": "Luxembourg",
                                        "teamSName": "LUX",
                                        "imageId": 172588
                                    },
                                    "venueInfo": {
                                        "id": 1689,
                                        "ground": "GB Oval",
                                        "city": "Szodliget",
                                        "timezone": "+02:00",
                                        "latitude": "47.730150",
                                        "longitude": "19.146060"
                                    },
                                    "currBatTeamId": 550,
                                    "seriesStartDt": "1753315200000",
                                    "seriesEndDt": "1753660800000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 148,
                                            "wickets": 8,
                                            "overs": 19.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 78,
                                            "wickets": 10,
                                            "overs": 15.1
                                        }
                                    }
                                }
                            }
                        ]
                    }
                },
                {
                    "seriesAdWrapper": {
                        "seriesId": 10471,
                        "seriesName": "Rwanda T20I Tri-Series, 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 127571,
                                    "seriesId": 10471,
                                    "seriesName": "Rwanda T20I Tri-Series, 2025",
                                    "matchDesc": "10th Match",
                                    "matchFormat": "T20",
                                    "startDate": "1753427700000",
                                    "endDate": "1753440300000",
                                    "state": "Complete",
                                    "status": "Bahrain won by 114 runs",
                                    "team1": {
                                        "teamId": 543,
                                        "teamName": "Bahrain",
                                        "teamSName": "BHR",
                                        "imageId": 172594
                                    },
                                    "team2": {
                                        "teamId": 569,
                                        "teamName": "Rwanda",
                                        "teamSName": "RWA",
                                        "imageId": 172621
                                    },
                                    "venueInfo": {
                                        "id": 818,
                                        "ground": "Gahanga International Cricket Stadium",
                                        "city": "Kigali City",
                                        "timezone": "+02:00",
                                        "latitude": "-1.950851",
                                        "longitude": "30.061507"
                                    },
                                    "currBatTeamId": 543,
                                    "seriesStartDt": "1752710400000",
                                    "seriesEndDt": "1753660800000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 163,
                                            "wickets": 6,
                                            "overs": 19.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 49,
                                            "wickets": 10,
                                            "overs": 14.3
                                        }
                                    }
                                }
                            },
                            {
                                "matchInfo": {
                                    "matchId": 127582,
                                    "seriesId": 10471,
                                    "seriesName": "Rwanda T20I Tri-Series, 2025",
                                    "matchDesc": "11th Match",
                                    "matchFormat": "T20",
                                    "startDate": "1753443900000",
                                    "endDate": "1753456500000",
                                    "state": "Complete",
                                    "status": "Bahrain won by 8 wkts",
                                    "team1": {
                                        "teamId": 553,
                                        "teamName": "Malawi",
                                        "teamSName": "MWI",
                                        "imageId": 172605
                                    },
                                    "team2": {
                                        "teamId": 543,
                                        "teamName": "Bahrain",
                                        "teamSName": "BHR",
                                        "imageId": 172594
                                    },
                                    "venueInfo": {
                                        "id": 818,
                                        "ground": "Gahanga International Cricket Stadium",
                                        "city": "Kigali City",
                                        "timezone": "+02:00",
                                        "latitude": "-1.950851",
                                        "longitude": "30.061507"
                                    },
                                    "currBatTeamId": 543,
                                    "seriesStartDt": "1752710400000",
                                    "seriesEndDt": "1753660800000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "BHR Won"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 113,
                                            "wickets": 9,
                                            "overs": 19.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 114,
                                            "wickets": 2,
                                            "overs": 16.3
                                        }
                                    }
                                }
                            }
                        ]
                    }
                },
                {
                    "ad": {
                        "name": "native_matches",
                        "layout": "native_large",
                        "position": 3
                    }
                },
                {
                    "seriesAdWrapper": {
                        "seriesId": 10410,
                        "seriesName": "Pearl of Africa T20I Series 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 127098,
                                    "seriesId": 10410,
                                    "seriesName": "Pearl of Africa T20I Series 2025",
                                    "matchDesc": "9th Match",
                                    "matchFormat": "T20",
                                    "startDate": "1753426800000",
                                    "endDate": "1753439400000",
                                    "state": "Complete",
                                    "status": "Uganda won by 6 wkts",
                                    "team1": {
                                        "teamId": 14,
                                        "teamName": "Kenya",
                                        "teamSName": "KEN",
                                        "imageId": 172129
                                    },
                                    "team2": {
                                        "teamId": 44,
                                        "teamName": "Uganda",
                                        "teamSName": "UGA",
                                        "imageId": 495000
                                    },
                                    "venueInfo": {
                                        "id": 1783,
                                        "ground": "Entebbe Cricket Oval",
                                        "city": "Entebbe",
                                        "timezone": "+03:00",
                                        "latitude": "0.0534611",
                                        "longitude": "32.4667118"
                                    },
                                    "currBatTeamId": 44,
                                    "seriesStartDt": "1752624000000",
                                    "seriesEndDt": "1753660800000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "UGA Won"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 124,
                                            "wickets": 8,
                                            "overs": 19.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 125,
                                            "wickets": 4,
                                            "overs": 18.1
                                        }
                                    }
                                }
                            }
                        ]
                    }
                },
                {
                    "seriesAdWrapper": {
                        "seriesId": 10443,
                        "seriesName": "Finland tour of Estonia 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 127291,
                                    "seriesId": 10443,
                                    "seriesName": "Finland tour of Estonia 2025",
                                    "matchDesc": "1st Match",
                                    "matchFormat": "T20",
                                    "startDate": "1753446600000",
                                    "endDate": "1753459200000",
                                    "state": "Complete",
                                    "status": "Finland won by 16 runs",
                                    "team1": {
                                        "teamId": 556,
                                        "teamName": "Finland",
                                        "teamSName": "FIN",
                                        "imageId": 172608
                                    },
                                    "team2": {
                                        "teamId": 526,
                                        "teamName": "Estonia",
                                        "teamSName": "EST",
                                        "imageId": 172576
                                    },
                                    "venueInfo": {
                                        "id": 1552,
                                        "ground": "Estonian National Cricket and Rugby Field",
                                        "city": "Tallinn",
                                        "timezone": "+03:00",
                                        "latitude": "59.43696",
                                        "longitude": "24.75353"
                                    },
                                    "currBatTeamId": 556,
                                    "seriesStartDt": "1753315200000",
                                    "seriesEndDt": "1753660800000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 180,
                                            "wickets": 5,
                                            "overs": 19.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 164,
                                            "wickets": 8,
                                            "overs": 19.6
                                        }
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
        },
        {
            "matchType": "League",
            "seriesMatches": [
                {
                    "seriesAdWrapper": {
                        "seriesId": 10361,
                        "seriesName": "World Championship of Legends 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 125173,
                                    "seriesId": 10361,
                                    "seriesName": "World Championship of Legends 2025",
                                    "matchDesc": "9th Match",
                                    "matchFormat": "T20",
                                    "startDate": "1753457400000",
                                    "endDate": "1753470000000",
                                    "state": "Complete",
                                    "status": "Pakistan Champions won by 31 runs",
                                    "team1": {
                                        "teamId": 2046,
                                        "teamName": "Pakistan Champions",
                                        "teamSName": "PAKCH",
                                        "imageId": 510034
                                    },
                                    "team2": {
                                        "teamId": 2014,
                                        "teamName": "South Africa Champions",
                                        "teamSName": "SACH",
                                        "imageId": 510030
                                    },
                                    "venueInfo": {
                                        "id": 222,
                                        "ground": "Grace Road",
                                        "city": "Leicester",
                                        "timezone": "+01:00",
                                        "latitude": "52.607861",
                                        "longitude": "-1.142709"
                                    },
                                    "currBatTeamId": 2046,
                                    "seriesStartDt": "1752710400000",
                                    "seriesEndDt": "1754179200000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 198,
                                            "wickets": 5,
                                            "overs": 19.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 167,
                                            "wickets": 9,
                                            "overs": 19.6
                                        }
                                    }
                                }
                            }
                        ]
                    }
                },
                {
                    "seriesAdWrapper": {
                        "seriesId": 10350,
                        "seriesName": "Pondicherry Premier League 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 124095,
                                    "seriesId": 10350,
                                    "seriesName": "Pondicherry Premier League 2025",
                                    "matchDesc": "Qualifier 2",
                                    "matchFormat": "T20",
                                    "startDate": "1753450200000",
                                    "endDate": "1753462800000",
                                    "state": "Complete",
                                    "status": "Mahe Megalo Strikers won by 9 runs",
                                    "team1": {
                                        "teamId": 2565,
                                        "teamName": "Mahe Megalo Strikers",
                                        "teamSName": "MMS",
                                        "imageId": 725536
                                    },
                                    "team2": {
                                        "teamId": 2547,
                                        "teamName": "Genid Yanam Royals",
                                        "teamSName": "GYR",
                                        "imageId": 725543
                                    },
                                    "venueInfo": {
                                        "id": 543,
                                        "ground": "Cricket Association Puducherry Siechem Ground",
                                        "city": "Puducherry",
                                        "timezone": "+05:30",
                                        "latitude": "11.912200",
                                        "longitude": "79.737396"
                                    },
                                    "currBatTeamId": 2565,
                                    "seriesStartDt": "1751673600000",
                                    "seriesEndDt": "1753660800000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 212,
                                            "wickets": 5,
                                            "overs": 19.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 203,
                                            "wickets": 9,
                                            "overs": 19.6
                                        }
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
        },
        {
            "matchType": "Domestic",
            "seriesMatches": [
                {
                    "seriesAdWrapper": {
                        "seriesId": 9360,
                        "seriesName": "County Championship Division One 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 113157,
                                    "seriesId": 9360,
                                    "seriesName": "County Championship Division One 2025",
                                    "matchDesc": "50th Match",
                                    "matchFormat": "TEST",
                                    "startDate": "1753178400000",
                                    "endDate": "1753462800000",
                                    "state": "Complete",
                                    "status": "Warwickshire won by 5 wkts",
                                    "team1": {
                                        "teamId": 147,
                                        "teamName": "Worcestershire",
                                        "teamSName": "WORCS",
                                        "imageId": 172214
                                    },
                                    "team2": {
                                        "teamId": 140,
                                        "teamName": "Warwickshire",
                                        "teamSName": "WARKS",
                                        "imageId": 172207
                                    },
                                    "venueInfo": {
                                        "id": 20,
                                        "ground": "Edgbaston",
                                        "city": "Birmingham",
                                        "timezone": "+01:00",
                                        "latitude": "52.455774",
                                        "longitude": "-1.902624"
                                    },
                                    "currBatTeamId": 140,
                                    "seriesStartDt": "1743638400000",
                                    "seriesEndDt": "1759017600000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 333,
                                            "wickets": 10,
                                            "overs": 108.1
                                        },
                                        "inngs2": {
                                            "inningsId": 3,
                                            "runs": 243,
                                            "wickets": 10,
                                            "overs": 86.4
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 184,
                                            "wickets": 10,
                                            "overs": 58.5
                                        },
                                        "inngs2": {
                                            "inningsId": 4,
                                            "runs": 396,
                                            "wickets": 5,
                                            "overs": 93.2
                                        }
                                    }
                                }
                            },
                            {
                                "matchInfo": {
                                    "matchId": 113136,
                                    "seriesId": 9360,
                                    "seriesName": "County Championship Division One 2025",
                                    "matchDesc": "47th Match",
                                    "matchFormat": "TEST",
                                    "startDate": "1753178400000",
                                    "endDate": "1753462800000",
                                    "state": "Complete",
                                    "status": "Match drawn",
                                    "team1": {
                                        "teamId": 139,
                                        "teamName": "Nottinghamshire",
                                        "teamSName": "NOTTS",
                                        "imageId": 172206
                                    },
                                    "team2": {
                                        "teamId": 153,
                                        "teamName": "Hampshire",
                                        "teamSName": "HAM",
                                        "imageId": 172220
                                    },
                                    "venueInfo": {
                                        "id": 21,
                                        "ground": "The Rose Bowl",
                                        "city": "Southampton",
                                        "timezone": "+01:00",
                                        "latitude": "50.924131",
                                        "longitude": "-1.322163"
                                    },
                                    "seriesStartDt": "1743638400000",
                                    "seriesEndDt": "1759017600000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 578,
                                            "wickets": 8,
                                            "overs": 132.3
                                        },
                                        "inngs2": {
                                            "inningsId": 3,
                                            "runs": 108,
                                            "wickets": 1,
                                            "overs": 33.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 454,
                                            "wickets": 10,
                                            "overs": 178.3
                                        }
                                    }
                                }
                            },
                            {
                                "matchInfo": {
                                    "matchId": 113148,
                                    "seriesId": 9360,
                                    "seriesName": "County Championship Division One 2025",
                                    "matchDesc": "49th Match",
                                    "matchFormat": "TEST",
                                    "startDate": "1753178400000",
                                    "endDate": "1753462800000",
                                    "state": "Complete",
                                    "status": "Match drawn",
                                    "team1": {
                                        "teamId": 146,
                                        "teamName": "Yorkshire",
                                        "teamSName": "YORKS",
                                        "imageId": 172213
                                    },
                                    "team2": {
                                        "teamId": 148,
                                        "teamName": "Surrey",
                                        "teamSName": "SUR",
                                        "imageId": 172215
                                    },
                                    "venueInfo": {
                                        "id": 220,
                                        "ground": "North Marine Road Ground",
                                        "city": "Scarborough",
                                        "timezone": "+01:00",
                                        "latitude": "54.288277",
                                        "longitude": "-0.40539"
                                    },
                                    "seriesStartDt": "1743638400000",
                                    "seriesEndDt": "1759017600000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 517,
                                            "wickets": 6,
                                            "overs": 129.6
                                        },
                                        "inngs2": {
                                            "inningsId": 3,
                                            "runs": 120,
                                            "wickets": 5,
                                            "overs": 56.3
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 537,
                                            "wickets": 10,
                                            "overs": 119.6
                                        }
                                    }
                                }
                            }
                        ]
                    }
                },
                {
                    "seriesAdWrapper": {
                        "seriesId": 9369,
                        "seriesName": "County Championship Division Two 2025",
                        "matches": [
                            {
                                "matchInfo": {
                                    "matchId": 113568,
                                    "seriesId": 9369,
                                    "seriesName": "County Championship Division Two 2025",
                                    "matchDesc": "40th Match",
                                    "matchFormat": "TEST",
                                    "startDate": "1753178400000",
                                    "endDate": "1753462800000",
                                    "state": "Complete",
                                    "status": "Lancashire won by 9 wkts",
                                    "team1": {
                                        "teamId": 143,
                                        "teamName": "Lancashire",
                                        "teamSName": "LANCS",
                                        "imageId": 172210
                                    },
                                    "team2": {
                                        "teamId": 151,
                                        "teamName": "Gloucestershire",
                                        "teamSName": "GLOUCS",
                                        "imageId": 172218
                                    },
                                    "venueInfo": {
                                        "id": 352,
                                        "ground": "College Ground",
                                        "city": "Cheltenham",
                                        "timezone": "+01:00",
                                        "latitude": "51.898963",
                                        "longitude": "-2.061148"
                                    },
                                    "currBatTeamId": 143,
                                    "seriesStartDt": "1743638400000",
                                    "seriesEndDt": "1759017600000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 557,
                                            "wickets": 10,
                                            "overs": 141.4
                                        },
                                        "inngs2": {
                                            "inningsId": 4,
                                            "runs": 111,
                                            "wickets": 1,
                                            "overs": 20.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 381,
                                            "wickets": 10,
                                            "overs": 113.4
                                        },
                                        "inngs2": {
                                            "inningsId": 3,
                                            "runs": 285,
                                            "wickets": 10,
                                            "overs": 97.6
                                        }
                                    }
                                }
                            },
                            {
                                "matchInfo": {
                                    "matchId": 113559,
                                    "seriesId": 9369,
                                    "seriesName": "County Championship Division Two 2025",
                                    "matchDesc": "39th Match",
                                    "matchFormat": "TEST",
                                    "startDate": "1753178400000",
                                    "endDate": "1753462800000",
                                    "state": "Complete",
                                    "status": "Leicestershire won by 189 runs",
                                    "team1": {
                                        "teamId": 145,
                                        "teamName": "Leicestershire",
                                        "teamSName": "LEIC",
                                        "imageId": 172212
                                    },
                                    "team2": {
                                        "teamId": 144,
                                        "teamName": "Derbyshire",
                                        "teamSName": "DERBY",
                                        "imageId": 172211
                                    },
                                    "venueInfo": {
                                        "id": 226,
                                        "ground": "County Ground",
                                        "city": "Derby",
                                        "timezone": "+01:00",
                                        "latitude": "52.927517",
                                        "longitude": "-1.461188"
                                    },
                                    "currBatTeamId": 145,
                                    "seriesStartDt": "1743638400000",
                                    "seriesEndDt": "1759017600000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 398,
                                            "wickets": 10,
                                            "overs": 117.1
                                        },
                                        "inngs2": {
                                            "inningsId": 3,
                                            "runs": 236,
                                            "wickets": 9,
                                            "overs": 42.3
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 189,
                                            "wickets": 10,
                                            "overs": 71.1
                                        },
                                        "inngs2": {
                                            "inningsId": 4,
                                            "runs": 256,
                                            "wickets": 10,
                                            "overs": 116.3
                                        }
                                    }
                                }
                            },
                            {
                                "matchInfo": {
                                    "matchId": 113550,
                                    "seriesId": 9369,
                                    "seriesName": "County Championship Division Two 2025",
                                    "matchDesc": "38th Match",
                                    "matchFormat": "TEST",
                                    "startDate": "1753178400000",
                                    "endDate": "1753462800000",
                                    "state": "Complete",
                                    "status": "Middlesex won by an innings and 107 runs",
                                    "team1": {
                                        "teamId": 74,
                                        "teamName": "Middlesex",
                                        "teamSName": "MDX",
                                        "imageId": 172170
                                    },
                                    "team2": {
                                        "teamId": 142,
                                        "teamName": "Northamptonshire",
                                        "teamSName": "NHNTS",
                                        "imageId": 172209
                                    },
                                    "venueInfo": {
                                        "id": 385,
                                        "ground": "Merchant Taylors' School Ground",
                                        "city": "Northwood",
                                        "timezone": "+01:00",
                                        "latitude": "51.63656",
                                        "longitude": "-0.4275100"
                                    },
                                    "currBatTeamId": 74,
                                    "seriesStartDt": "1743638400000",
                                    "seriesEndDt": "1759017600000",
                                    "isTimeAnnounced": true,
                                    "stateTitle": "Complete"
                                },
                                "matchScore": {
                                    "team1Score": {
                                        "inngs1": {
                                            "inningsId": 1,
                                            "runs": 625,
                                            "wickets": 8,
                                            "overs": 145.6
                                        }
                                    },
                                    "team2Score": {
                                        "inngs1": {
                                            "inningsId": 2,
                                            "runs": 261,
                                            "wickets": 10,
                                            "overs": 81.3
                                        },
                                        "inngs2": {
                                            "inningsId": 3,
                                            "runs": 257,
                                            "wickets": 10,
                                            "overs": 89.6
                                        }
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
        }
    ],
    "filters": {
        "matchType": [
            "International",
            "League",
            "Domestic",
            "Women"
        ]
    },
    "appIndex": {
        "seoTitle": "Live Cricket Score - Scorecard and Match Results",
        "webURL": "www.cricbuzz.com/live-cricket-scores/"
    },
    "responseLastUpdated": "1753473692"
}'''),
    );

    // 🔁 Inject or merge old odds history
    injectRandomOdds(data, previousData);

    // 🔁 Save current data for next merge
    previousData = data;

    return data;

    // LiveDataModel.fromJson(response.data,);
  }
}
