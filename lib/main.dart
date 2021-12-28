import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:webview_flutter/webview_flutter.dart';

void main() async{
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

   FirebaseMessaging.instance.subscribeToTopic("news");
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const  MaterialApp(
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
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
    /*  appBar: AppBar(
        title: Text(widget.title,style: TextStyle(color:Colors.white ),),
        backgroundColor: Colors.black,
        centerTitle: true,
      ), */
      body:Container(
        margin: EdgeInsets.only(top: height),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),

          controller: _pageController,
          children: <Widget>[
            WebViewKeepAlive(url: "https://www.leadlr.io/"),
         //   WebViewKeepAlive(url: "https://www.leadlr.io/package.html"),
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
      bottomNavigationBar:  BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house),
              label: 'Home',
            ),
         /*   BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.option),
              label: 'Pakete',
            ), */
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
}
class WebViewKeepAlive extends StatefulWidget {
  final String url;

  WebViewKeepAlive({Key? key,required this.url}) : super(key: key);

  @override
  _WebViewKeepAlive createState() => _WebViewKeepAlive();
}

class _WebViewKeepAlive extends State<WebViewKeepAlive> with AutomaticKeepAliveClientMixin {

  late Future<String> _future;

  @override
  bool get wantKeepAlive => true;

  Future<String> _getUrl(String url) async {
    await Future.delayed(Duration(milliseconds: 500), () {});
    return Future.value(url);
  }

  @override
  void initState() {
    registerNotification();
    _future = _getUrl(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(color: Colors.black,));
            case ConnectionState.active:
              return Text('');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                );
              } else {
                return WebView(
                  initialUrl: snapshot.data,
                  javascriptMode: JavascriptMode.unrestricted,

                );
              }
          }
        },
    );
  }
  void registerNotification() async {
    // https://blog.logrocket.com/flutter-push-notifications-with-firebase-cloud-messaging/#iosint
    AndroidNotificationDetails notificationAndroidSpecifics = const AndroidNotificationDetails("1","News",icon: null);

    NotificationDetails notificationPlatformSpecifics = NotificationDetails(android: notificationAndroidSpecifics);

 //   await Firebase.initializeApp();

    var initializationSettingsAndroid = const AndroidInitializationSettings('logo_icon');

    FlutterLocalNotificationsPlugin().initialize( InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null));

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("message recieved");
      print(event.notification!.body);
      FlutterLocalNotificationsPlugin().show(1, event.notification!.title, event.notification!.body,notificationPlatformSpecifics);

    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');

    });

    FirebaseMessaging.instance.getToken().then((value){
      print(value);
    });
  }

}


