import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'home.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xffFFE194),
          scaffoldBackgroundColor: Color(0xffffffff),
        ),
        home: AnimatedSplashScreen(
            duration: 700,
            splash: Image.asset(
              "images/ico.png",
            ),
            nextScreen: Home(),
            splashTransition: SplashTransition.rotationTransition,
            pageTransitionType: PageTransitionType.bottomToTop,
            backgroundColor: Colors.white));
  }
}

/*
Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    arr[i]["quote"],
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffF38D11)),
                  ),
                ),
                // Text(arr[i]["name"],
                //     textAlign: TextAlign.center,
                //     style:
                //         TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
              ],
            )

 */

// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// Container(
// child: Center(
// child: Text(
// "I've been into exercise my whole life, been a runner and been into health and fitness always.I've been into exercise my whole life, been a runner and been into health and fitness always.I've been into exercise my whole life, been a runner and been into health and fitness always.",
// style: TextStyle(
// fontSize: 20.0,
// fontWeight: FontWeight.w600,
// color: Color(0xffF38D11)),
// ),
// ),
// ),
// Expanded(
// child: Text(arr[i]["name"],
// style: TextStyle(
// fontSize: 18.0, fontWeight: FontWeight.w400)),
// )
// ],
// )
