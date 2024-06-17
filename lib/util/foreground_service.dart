import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

void initializeForegroundService() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'foreground_service',
      channelName: 'Noa Service',
      channelImportance: NotificationChannelImportance.MIN,
      iconData: null,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      isOnceEvent: true,
    ),
  );
}

void startForegroundService() async {
  if (await FlutterForegroundTask.isRunningService) {
    FlutterForegroundTask.restartService();
  } else {
    FlutterForegroundTask.startService(
      notificationTitle: 'Noa is standing by',
      notificationText: 'Tap to return to the app',
      callback: _startForegroundCallback,
    );
  }
}

@pragma('vm:entry-point')
void _startForegroundCallback() {
  FlutterForegroundTask.setTaskHandler(_ForegroundFirstTaskHandler());
}

class _ForegroundFirstTaskHandler extends TaskHandler {
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    print("Starting foreground task");
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    print("Foreground task tick");
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
    print("Destroying foreground task");
    FlutterForegroundTask.stopService();
  }
}
