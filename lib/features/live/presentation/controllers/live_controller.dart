import 'dart:developer';

import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:cric/features/live/domain/usecases/get_live_data.dart';
import 'package:get/get.dart';

import 'dart:async';

class LiveController extends GetxController {
  final GetLiveData getLiveDataUseCase;

  Rx<LiveDataModel?> liveData = Rx<LiveDataModel?>(null);
  RxString error = ''.obs;

  Timer? _timer;
  int _retryCount = 0;

  LiveController({required this.getLiveDataUseCase});

  @override
  void onInit() {
    super.onInit();
    fetchLiveData();
    _timer = Timer.periodic(Duration(seconds: 10), (_) => fetchLiveData());
  }

  Future<void> fetchLiveData() async {
    log("fetch Live Data Api Called");
    try {
      error.value = '';
      final data = await getLiveDataUseCase();
      liveData.value = data;
      _retryCount = 0;
    } catch (e) {
      log("excption occured in fetchLiveData api : $e");
      _retryCount++;
      error.value = 'Error fetching live data ($_retryCount)';
      if (_retryCount >= 3) _timer?.cancel();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
