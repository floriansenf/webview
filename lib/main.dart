import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // FirebaseCrashlytics.instance.crash();
  FirebaseMessaging.instance.subscribeToTopic("test");
  /*
  For iOS; you must have a physical iOS device to receive messages. Firebase Cloud Messaging integrates with the Apple Push Notification service (APNs), however APNs only works with real devices.
  */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Leadlr',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Leadlr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  @override
  void initState() {
    registerNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.only(top: height),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: const <Widget>[
            WebViewKeepAlive(url: "https://www.leadlr.io/"),
            WebViewKeepAlive(url: "https://www.leadlr.io/dashboard/login"),
            WebViewKeepAlive(url: "https://www.leadlr.io/contact.php"),
          ],
          onPageChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_right_circle),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.envelope),
            label: 'Kontakt',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  void onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              /*    await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(payload),
                  ),
                ); */
            },
          )
        ],
      ),
    );
  }

  void registerNotification() async {
    final bool? result = await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  
   
    // https://blog.logrocket.com/flutter-push-notifications-with-firebase-cloud-messaging/#iosint
    AndroidNotificationDetails notificationAndroidSpecifics =
        const AndroidNotificationDetails("1", "News", icon: null);

    NotificationDetails notificationPlatformSpecifics =
        NotificationDetails(android: notificationAndroidSpecifics);

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('logo_icon');

    FlutterLocalNotificationsPlugin().initialize(InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null));

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message recieved");
      print(event.notification!.body);
      FlutterLocalNotificationsPlugin().show(1, event.notification!.title,
          event.notification!.body, notificationPlatformSpecifics);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
    });
  }
}

class WebViewKeepAlive extends StatefulWidget {
  final String url;

  const WebViewKeepAlive({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewKeepAlive createState() => _WebViewKeepAlive();
}

class _WebViewKeepAlive extends State<WebViewKeepAlive>
    with AutomaticKeepAliveClientMixin {
  late Future<String> _future;

  @override
  bool get wantKeepAlive => true;

  Future<String> _getUrl(String url) async {
    await Future.delayed(Duration(milliseconds: 500), () {});
    return Future.value(url);
  }

  var subscription;
  @override
  void initState() {
    print("init");

    _future = _getUrl(widget.url);

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        // _future = _getUrl(widget.url);
      });
    });

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<ConnectivityResult> getconnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Build");
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('none');
          case ConnectionState.waiting:
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          case ConnectionState.active:
            return Text('');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {
              return FutureBuilder(
                  future: Connectivity().checkConnectivity(),
                  builder: (context, AsyncSnapshot<ConnectivityResult> result) {
                    if (result.data == ConnectivityResult.wifi || result.data == ConnectivityResult.mobile ) {
                      return WebView(
                          initialUrl: snapshot.data,
                          javascriptMode: JavascriptMode.unrestricted);
                    } else {
                      return const Center(
                        child: Text(
                          "Verbindung verloren",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                  });
            }
        }
      },
    );
  }
}
