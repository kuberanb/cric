import 'dart:developer';

import 'package:cric/core/simple_background_handler.dart';
import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:cric/features/live/domain/usecases/get_live_data.dart';
import 'package:get/get.dart';

import 'dart:async';

class LiveController extends GetxController {
  final GetLiveData getLiveDataUseCase;

  Rx<LiveDataModel?> liveData = Rx<LiveDataModel?>(null);
  RxString error = ''.obs;
  RxBool isLoading = false.obs;

  Timer? _timer;
  int _retryCount = 0;

  LiveController({required this.getLiveDataUseCase});

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _startPeriodicRefresh();
  }

  Future<void> _initializeData() async {
    // Load cached data first
    await loadCachedData();
    
    // Then fetch fresh data if internet is available
    await fetchLiveData();
  }

  Future<void> loadCachedData() async {
    try {
      final cachedData = await SimpleBackgroundHandler.getCachedLiveData();
      if (cachedData != null) {
        liveData.value = cachedData;
        log("📱 Loaded cached live data");
      }
    } catch (e) {
      log("Error loading cached data: $e");
    }
  }

  void _startPeriodicRefresh() {
    // Initialize and start background tasks
    SimpleBackgroundHandler.initialize().then((_) {
      SimpleBackgroundHandler.registerPeriodicTask();
    });
    
    // Keep a timer for immediate UI updates (every 30 seconds)
    _timer = Timer.periodic(Duration(seconds: 30), (_) async {
      if (await SimpleBackgroundHandler.isInternetAvailable()) {
        await fetchLiveData();
      }
    });
  }

  Future<void> fetchLiveData() async {
    log("🔄 Fetching live data...");
    
    try {
      isLoading.value = true;
      error.value = '';
      
      // Check internet connectivity
      if (!await SimpleBackgroundHandler.isInternetAvailable()) {
        log("📡 No internet connection, using cached data");
        error.value = 'No internet connection';
        isLoading.value = false;
        return;
      }

      final data = await getLiveDataUseCase();
      liveData.value = data;
      
      // Save to cache
      await SimpleBackgroundHandler.saveLiveData(data);
      
      _retryCount = 0;
      log("✅ Live data fetched and cached successfully");
    } catch (e) {
      log("❌ Exception occurred in fetchLiveData: $e");
      _retryCount++;
      error.value = 'Error fetching live data ($_retryCount)';
      
      if (_retryCount >= 3) {
        log("🛑 Max retry attempts reached, stopping timer");
        _timer?.cancel();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Manual refresh method
  Future<void> refreshData() async {
    await fetchLiveData();
  }



  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
