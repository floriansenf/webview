import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
import 'main.dart';
class Home extends StatelessWidget{

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      primary: false,
      
      padding: const EdgeInsets.only(top: 70,left: 10,right: 10),
      children: <Widget> [
        Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage( url: 'https://www.verbrauchercheck.net',)),
              );
            },
            child: Container(
              color: const Color.fromRGBO(0, 107, 99, 1),
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                  Icon(CupertinoIcons.house,size: 40,color: Colors.white,),
                  Text("Home",style: TextStyle(color: Colors.white,fontSize: 20),),
                ],),
             
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage( url: 'https://verbrauchercheck.net/pkv-optimierung-gdn/',)),
              );
            },
            child: Container(
              color: const Color.fromRGBO(0, 107, 99, 1),
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                  Icon(Icons.local_hospital_outlined,size: 40,color: Colors.white,),
                  Text("PKV optimieren",style: TextStyle(color: Colors.white,fontSize: 20),),
                ],),
             
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage( url: 'https://verbrauchercheck.net/blog',)),
              );
            },
            child: Container(
              color: const Color.fromRGBO(0, 107, 99, 1),
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                  Icon(CupertinoIcons.news,size: 40,color: Colors.white,),
                  Text("News",style: TextStyle(color: Colors.white,fontSize: 20),),
                ],),
             
            ),
          ),
        ),
         Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage( url: 'https://www.facebook.com',)),
              );
            },
            child: Container(
              color: const Color.fromRGBO(0, 107, 99, 1),
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                  Icon(Icons.facebook_outlined,size: 40,color: Colors.white,),
                  Text("Facebook",style: TextStyle(color: Colors.white,fontSize: 20),),
                ],),
             
            ),
          ),
        ),
      ],);
  }
}