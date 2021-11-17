import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Verbrauchercheck',
      debugShowCheckedModeBanner: false,

      home: MyHomePage(title: 'Verbrauchercheck'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: TextStyle(color:Color.fromRGBO(252, 186, 57, 100) ),),
        backgroundColor: Color.fromRGBO(1, 108, 99, 100),
        centerTitle: true,
      ),
      body:PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          WebViewKeepAlive(url: "https://verbrauchercheck.net/"),
          WebViewKeepAlive(url: "https://verbrauchercheck.net/pkv-optimierung/"),
          WebViewKeepAlive(url: "https://verbrauchercheck.net/kontakt/"),
        ],
        onPageChanged: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(1, 108, 99, 100),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Leads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: 'Kontakt',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(252, 186, 57, 100),
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
              return Center(child: CircularProgressIndicator(color: Color.fromRGBO(1, 108, 99, 100),));
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
}


