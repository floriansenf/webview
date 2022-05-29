import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
   final String url;
  HomePage({
    Key? key, 
  required this.url}) : super(key: key);
 
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).padding.top;
    String ur=widget().url;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.only(top: height),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            
          WebViewKeepAlive(url: ur),
          const WebViewKeepAlive(url: "https://verbrauchercheck.net/pkv-optimierung-gdn/"),
          const WebViewKeepAlive(url: "https://verbrauchercheck.net/kontakt"),
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
            label: 'Pkv',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.envelope),
            label: 'Kontakt',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromRGBO(0, 107, 99, 1),
        selectedItemColor: const Color.fromRGBO(0, 107, 99, 1),
        onTap: (index) {
          if(index==0){
            Navigator.push(
                context,
                
                MaterialPageRoute(builder: (context) => MyHomePage(title: "PKV"),
              ),
            );
          }else{
            setState(() => _selectedIndex = index);
            _pageController.jumpToPage(index);
          }
        
        },
      ),
    );
  }

}