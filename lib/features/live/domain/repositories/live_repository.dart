

import 'package:cric/features/live/data/models/live_data_model.dart';

abstract class LiveRepository {
  Future<LiveDataModel> getLiveData();
}
