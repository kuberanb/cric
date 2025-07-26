import 'dart:convert';
import 'dart:developer' as d;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cric/features/live/data/models/live_data_model.dart';
import 'package:cric/features/live/data/datasources/live_remote_data_source.dart';
import 'package:dio/dio.dart';

class SimpleBackgroundHandler {
  static const String fetchLiveDataTask = 'fetchLiveDataTask';
  static const String liveDataKey = 'live_data_cache';
  static const String lastFetchTimeKey = 'last_fetch_time';

  // Initialize workmanager
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  }

  // Register periodic task
  static Future<void> registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      fetchLiveDataTask,
      fetchLiveDataTask,
      frequency: const Duration(minutes: 5),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
    d.log('✅ Background task registered successfully');
  }

  // Cancel all tasks
  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
    d.log('❌ All background tasks cancelled');
  }

  // Check if internet is available using connectivity_plus
  static Future<bool> isInternetAvailable() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      d.log('Error checking connectivity: $e');
      return false;
    }
  }

  // Save data to shared preferences
  static Future<void> saveLiveData(LiveDataModel data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(data.toJson());
      await prefs.setString(liveDataKey, jsonData);
      await prefs.setString(lastFetchTimeKey, DateTime.now().toIso8601String());
      d.log('💾 Live data saved to cache');
    } catch (e) {
      d.log('Error saving live data: $e');
    }
  }

  // Get cached data from shared preferences
  static Future<LiveDataModel?> getCachedLiveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(liveDataKey);
      if (jsonData != null) {
        final data = LiveDataModel.fromJson(jsonDecode(jsonData));
        d.log('📱 Retrieved cached live data');
        return data;
      }
    } catch (e) {
      d.log('Error retrieving cached live data: $e');
    }
    return null;
  }

  // Get last fetch time
  static Future<DateTime?> getLastFetchTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timeString = prefs.getString(lastFetchTimeKey);
      if (timeString != null) {
        return DateTime.parse(timeString);
      }
    } catch (e) {
      d.log('Error getting last fetch time: $e');
    }
    return null;
  }

  // Fetch live data with error handling
  static Future<LiveDataModel?> fetchLiveData() async {
    try {
      // Check internet connectivity
      if (!await isInternetAvailable()) {
        d.log('📡 No internet connection available');
        return null;
      }

      // Fetch live data
      final dio = Dio();
      final dataSource = LiveRemoteDataSourceImpl(dio);
      final liveData = await dataSource.fetchLiveData();

      // Save to cache
      await saveLiveData(liveData);

      d.log('✅ Live data fetched successfully');
      return liveData;
    } catch (e) {
      d.log('❌ Error fetching live data: $e');
      return null;
    }
  }
}

// Background task callback function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    d.log('🔄 Background task started: $task');

    try {
      switch (task) {
        case SimpleBackgroundHandler.fetchLiveDataTask:
          return await _handleFetchLiveDataTask();
        default:
          d.log('❌ Unknown task: $task');
          return false;
      }
    } catch (e) {
      d.log('❌ Error in background task: $e');
      return false;
    }
  });
}

// Handle fetch live data task
Future<bool> _handleFetchLiveDataTask() async {
  try {
    // Check internet connectivity
    if (!await SimpleBackgroundHandler.isInternetAvailable()) {
      d.log('📡 No internet connection available');
      return false;
    }

    // Fetch live data
    final dio = Dio();
    final dataSource = LiveRemoteDataSourceImpl(dio);
    final liveData = await dataSource.fetchLiveData();

    // Save to cache
    await SimpleBackgroundHandler.saveLiveData(liveData);

    d.log('✅ Background fetch completed successfully');
    return true;
  } catch (e) {
    d.log('❌ Error in background fetch: $e');
    return false;
  }
}
