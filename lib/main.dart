import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:push/home/home_view.dart';
import 'package:push/service_init.dart';

// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  serviceInit();
  runApp(HomeView());
  initPlatformState();
  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initPlatformState() async {
  // Configure BackgroundFetch.
  BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: BackgroundFetchConfig.NETWORK_TYPE_NONE),
      () async {
    // This is the fetch-event callback.
    print('[BackgroundFetch] Event received');
//    setState(() {
//      _events.insert(0, new DateTime.now());
//    });
    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish();
  }).then((int status) {
    print('[BackgroundFetch] configure success: $status');
//    setState(() {
//      _status = status;
//    });
  }).catchError((e) {
    print('[BackgroundFetch] configure ERROR: $e');
//    setState(() {
//      _status = e;
//    });
  });

  // Optionally query the current BackgroundFetch status.
  int status = await BackgroundFetch.status;
//  setState(() {
//    _status = status;
//  });

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
//  if (!mounted) return;
}
