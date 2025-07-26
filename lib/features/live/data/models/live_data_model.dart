class LiveDataModel {
  List<TypeMatches>? typeMatches;
  Filters? filters;
  AppIndex? appIndex;
  String? responseLastUpdated;

  LiveDataModel({
    this.typeMatches,
    this.filters,
    this.appIndex,
    this.responseLastUpdated,
  });

  LiveDataModel.fromJson(Map<String, dynamic> json) {
    if (json['typeMatches'] != null) {
      typeMatches = <TypeMatches>[];
      json['typeMatches'].forEach((v) {
        typeMatches!.add(TypeMatches.fromJson(v));
      });
    }
    filters = json['filters'] != null
        ? Filters.fromJson(json['filters'])
        : null;
    appIndex = json['appIndex'] != null
        ? AppIndex.fromJson(json['appIndex'])
        : null;
    responseLastUpdated = json['responseLastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (typeMatches != null) {
      data['typeMatches'] = typeMatches!.map((v) => v.toJson()).toList();
    }
    if (filters != null) {
      data['filters'] = filters!.toJson();
    }
    if (appIndex != null) {
      data['appIndex'] = appIndex!.toJson();
    }
    data['responseLastUpdated'] = responseLastUpdated;
    return data;
  }
}

class TypeMatches {
  String? matchType;
  List<SeriesMatches>? seriesMatches;

  TypeMatches({this.matchType, this.seriesMatches});

  TypeMatches.fromJson(Map<String, dynamic> json) {
    matchType = json['matchType'];
    if (json['seriesMatches'] != null) {
      seriesMatches = <SeriesMatches>[];
      json['seriesMatches'].forEach((v) {
        seriesMatches!.add(SeriesMatches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matchType'] = matchType;
    if (seriesMatches != null) {
      data['seriesMatches'] = seriesMatches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeriesMatches {
  SeriesAdWrapper? seriesAdWrapper;

  SeriesMatches({this.seriesAdWrapper});

  SeriesMatches.fromJson(Map<String, dynamic> json) {
    seriesAdWrapper = json['seriesAdWrapper'] != null
        ? SeriesAdWrapper.fromJson(json['seriesAdWrapper'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (seriesAdWrapper != null) {
      data['seriesAdWrapper'] = seriesAdWrapper!.toJson();
    }
    return data;
  }
}

class SeriesAdWrapper {
  int? seriesId;
  String? seriesName;
  List<Matches>? matches;

  SeriesAdWrapper({this.seriesId, this.seriesName, this.matches});

  SeriesAdWrapper.fromJson(Map<String, dynamic> json) {
    seriesId = json['seriesId'];
    seriesName = json['seriesName'];
    if (json['matches'] != null) {
      matches = <Matches>[];
      json['matches'].forEach((v) {
        matches!.add(Matches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seriesId'] = seriesId;
    data['seriesName'] = seriesName;
    if (matches != null) {
      data['matches'] = matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Matches {
  MatchInfo? matchInfo;
  MatchScore? matchScore;
  MatchOdds? matchOdds; // ✅ New field

  Matches({this.matchInfo, this.matchScore, this.matchOdds});

  Matches.fromJson(Map<String, dynamic> json) {
    matchInfo = json['matchInfo'] != null
        ? MatchInfo.fromJson(json['matchInfo'])
        : null;
    matchScore = json['matchScore'] != null
        ? MatchScore.fromJson(json['matchScore'])
        : null;
    matchOdds = json['matchOdds'] != null
        ? MatchOdds.fromJson(json['matchOdds'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (matchInfo != null) {
      data['matchInfo'] = matchInfo!.toJson();
    }
    if (matchScore != null) {
      data['matchScore'] = matchScore!.toJson();
    }
    if (matchOdds != null) data['matchOdds'] = matchOdds!.toJson();

    return data;
  }
}

// ✅ NEW: MatchOdds and OddsPoint
class MatchOdds {
  List<OddsPoint>? team1OddsHistory;
  List<OddsPoint>? team2OddsHistory;

  MatchOdds({this.team1OddsHistory, this.team2OddsHistory});

  MatchOdds.fromJson(Map<String, dynamic> json) {
    if (json['team1OddsHistory'] != null) {
      team1OddsHistory = List<OddsPoint>.from(
        json['team1OddsHistory'].map((x) => OddsPoint.fromJson(x)),
      );
    }
    if (json['team2OddsHistory'] != null) {
      team2OddsHistory = List<OddsPoint>.from(
        json['team2OddsHistory'].map((x) => OddsPoint.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'team1OddsHistory': team1OddsHistory?.map((x) => x.toJson()).toList(),
    'team2OddsHistory': team2OddsHistory?.map((x) => x.toJson()).toList(),
  };
}

class OddsPoint {
  double? value;
  DateTime? timestamp;

  OddsPoint({this.value, this.timestamp});

  OddsPoint.fromJson(Map<String, dynamic> json) {
    value = (json['value'] as num?)?.toDouble();
    timestamp = json['timestamp'] != null
        ? DateTime.tryParse(json['timestamp'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    'value': value,
    'timestamp': timestamp?.toIso8601String(),
  };
}

class MatchInfo {
  int? matchId;
  int? seriesId;
  String? seriesName;
  String? matchDesc;
  String? matchFormat;
  String? startDate;
  String? endDate;
  String? state;
  String? status;
  Team1? team1;
  Team1? team2;
  VenueInfo? venueInfo;
  int? currBatTeamId;
  String? seriesStartDt;
  String? seriesEndDt;
  bool? isTimeAnnounced;
  String? stateTitle;

  MatchInfo({
    this.matchId,
    this.seriesId,
    this.seriesName,
    this.matchDesc,
    this.matchFormat,
    this.startDate,
    this.endDate,
    this.state,
    this.status,
    this.team1,
    this.team2,
    this.venueInfo,
    this.currBatTeamId,
    this.seriesStartDt,
    this.seriesEndDt,
    this.isTimeAnnounced,
    this.stateTitle,
  });

  MatchInfo.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId'];
    seriesId = json['seriesId'];
    seriesName = json['seriesName'];
    matchDesc = json['matchDesc'];
    matchFormat = json['matchFormat'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    state = json['state'];
    status = json['status'];
    team1 = json['team1'] != null ? Team1.fromJson(json['team1']) : null;
    team2 = json['team2'] != null ? Team1.fromJson(json['team2']) : null;
    venueInfo = json['venueInfo'] != null
        ? VenueInfo.fromJson(json['venueInfo'])
        : null;
    currBatTeamId = json['currBatTeamId'];
    seriesStartDt = json['seriesStartDt'];
    seriesEndDt = json['seriesEndDt'];
    isTimeAnnounced = json['isTimeAnnounced'];
    stateTitle = json['stateTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matchId'] = matchId;
    data['seriesId'] = seriesId;
    data['seriesName'] = seriesName;
    data['matchDesc'] = matchDesc;
    data['matchFormat'] = matchFormat;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['state'] = state;
    data['status'] = status;
    if (team1 != null) {
      data['team1'] = team1!.toJson();
    }
    if (team2 != null) {
      data['team2'] = team2!.toJson();
    }
    if (venueInfo != null) {
      data['venueInfo'] = venueInfo!.toJson();
    }
    data['currBatTeamId'] = currBatTeamId;
    data['seriesStartDt'] = seriesStartDt;
    data['seriesEndDt'] = seriesEndDt;
    data['isTimeAnnounced'] = isTimeAnnounced;
    data['stateTitle'] = stateTitle;
    return data;
  }
}

class Team1 {
  int? teamId;
  String? teamName;
  String? teamSName;
  int? imageId;

  Team1({this.teamId, this.teamName, this.teamSName, this.imageId});

  Team1.fromJson(Map<String, dynamic> json) {
    teamId = json['teamId'];
    teamName = json['teamName'];
    teamSName = json['teamSName'];
    imageId = json['imageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teamId'] = teamId;
    data['teamName'] = teamName;
    data['teamSName'] = teamSName;
    data['imageId'] = imageId;
    return data;
  }
}

class VenueInfo {
  int? id;
  String? ground;
  String? city;
  String? timezone;
  String? latitude;
  String? longitude;

  VenueInfo({
    this.id,
    this.ground,
    this.city,
    this.timezone,
    this.latitude,
    this.longitude,
  });

  VenueInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ground = json['ground'];
    city = json['city'];
    timezone = json['timezone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ground'] = ground;
    data['city'] = city;
    data['timezone'] = timezone;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class MatchScore {
  Team1Score? team1Score;
  Team1Score? team2Score;

  MatchScore({this.team1Score, this.team2Score});

  MatchScore.fromJson(Map<String, dynamic> json) {
    team1Score = json['team1Score'] != null
        ? Team1Score.fromJson(json['team1Score'])
        : null;
    team2Score = json['team2Score'] != null
        ? Team1Score.fromJson(json['team2Score'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (team1Score != null) {
      data['team1Score'] = team1Score!.toJson();
    }
    if (team2Score != null) {
      data['team2Score'] = team2Score!.toJson();
    }
    return data;
  }
}

class Team1Score {
  Inngs1? inngs1;
  Inngs1? inngs2;

  Team1Score({this.inngs1, this.inngs2});

  Team1Score.fromJson(Map<String, dynamic> json) {
    inngs1 = json['inngs1'] != null ? Inngs1.fromJson(json['inngs1']) : null;
    inngs2 = json['inngs2'] != null ? Inngs1.fromJson(json['inngs2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (inngs1 != null) {
      data['inngs1'] = inngs1!.toJson();
    }
    if (inngs2 != null) {
      data['inngs2'] = inngs2!.toJson();
    }
    return data;
  }
}

class Inngs1 {
  int? inningsId;
  int? runs;
  int? wickets;
  double? overs;

  Inngs1({this.inningsId, this.runs, this.wickets, this.overs});

  Inngs1.fromJson(Map<String, dynamic> json) {
    inningsId = json['inningsId'];
    runs = json['runs'];
    wickets = json['wickets'];
    overs = json['overs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inningsId'] = inningsId;
    data['runs'] = runs;
    data['wickets'] = wickets;
    data['overs'] = overs;
    return data;
  }
}

class Filters {
  List<String>? matchType;

  Filters({this.matchType});

  Filters.fromJson(Map<String, dynamic> json) {
    matchType = json['matchType'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matchType'] = matchType;
    return data;
  }
}

class AppIndex {
  String? seoTitle;
  String? webURL;

  AppIndex({this.seoTitle, this.webURL});

  AppIndex.fromJson(Map<String, dynamic> json) {
    seoTitle = json['seoTitle'];
    webURL = json['webURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seoTitle'] = seoTitle;
    data['webURL'] = webURL;
    return data;
  }
}
