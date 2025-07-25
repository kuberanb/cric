
import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:dio/dio.dart';


abstract class LiveRemoteDataSource {
  Future<LiveDataModel> fetchLiveData();
}

class LiveRemoteDataSourceImpl implements LiveRemoteDataSource {
  final Dio dio;
  LiveRemoteDataSourceImpl(this.dio);

  @override
  Future<LiveDataModel> fetchLiveData() async {
    final response = await dio.get(
      'https://cricbuzz-cricket.p.rapidapi.com/matches/v1/live',
      options: Options(headers: {
        'X-RapidAPI-Key': '8902fcd258msha865ed62fabebe0p1e05a7jsn5f4d3c2a45a7',
        'X-RapidAPI-Host': 'cricbuzz-cricket.p.rapidapi.com',
      }),
    );
    return LiveDataModel.fromJson(response.data,);
  }
}
