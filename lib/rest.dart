import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:suryan/quotes.dart';
import 'package:suryan/reusablecard.dart';
import 'package:wakelock/wakelock.dart';
import 'constant.dart';
import 'home.dart';
import 'yog.dart';

class Rest extends StatefulWidget {
  final int rounds;
  final int rest;
  final int timepose;
  final bool on_off;
  final int current_round;
  Rest(this.rounds, this.rest, this.timepose, this.on_off, this.current_round);
  @override
  _RestState createState() => _RestState();
}

class _RestState extends State<Rest> {
  int steps = 0;
  bool is_ad_loaded=false;
  static int counter = 0;
  int ran_quote_index;
  FlutterTts flutterTts = FlutterTts();
  Future _speak(String Text, int language) async {
    if (language == 1) flutterTts.setLanguage('hi');
    await flutterTts.speak(Text);
  }
  final AdSize adSize = AdSize(width: 320, height: 50);
  Timer _timer;
  final arr=Quotes().arr;
  Random random = new Random();
  BannerAd rest_page;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ran_quote_index = random.nextInt(arr.length);
    Wakelock.enable();
    rest_page=BannerAd(
      adUnitId: 'ca-app-pub-1550645510514235/6574672745',
      //my:ca-app-pub-1550645510514235/9267618414
      //test:ca-app-pub-3940256099942544/6300978111
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
          onAdLoaded: (Ad ad){
            setState(() {
              is_ad_loaded=true;
            });
            print('Ad loaded.');
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            setState(() {
              is_ad_loaded=false;
            });
            ad.dispose();

            print('Ad failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.')
      ),
    );
    rest_page.load();
    _speak("Take A Break", 0);
    counter++;
    print("Count=$counter\n rounds=");
    print(widget.rounds);
    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        steps++;
        if (steps == widget.rest) {
          timer.cancel();
          if (counter == widget.rounds) {
            _speak(
                "Congratulations! You Have completed $counter rounds of surya namaskar",
                0);
            counter = 0;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Home(),
              ),
              (route) => false,
            );
          } else {
            _speak("Be Ready", 0);
            sleep(const Duration(seconds: 1));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Yog(widget.rounds,
                    widget.rest, widget.timepose, widget.on_off, 0),
              ),
              (route) => false,
            );
          }
          steps = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    rest_page.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffFFE194),
          title: Text(
            'SURYA NAMASKAR',
            style: TextStyle(color: Color(0xffF38D11)),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (steps + 1).toString(),
                  style: kResultTextStyle,
                ),
                Text(
                  (widget.rounds + 1 != widget.current_round)
                      ? 'Ready For Round ' + widget.current_round.toString()
                      : 'Take A Break',
                  style: TextStyle(fontSize: 30, color: Color(0xffF38D11)),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      ran_quote_index = random.nextInt(arr.length);
                    });
                  },
                  child: ReusableCard(Padding(
                    padding: const EdgeInsets.symmetric(vertical:40,horizontal:8),
                    child: Column(
                      children: <Widget>[
                        Text(
                          arr[ran_quote_index]["quote"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffF38D11)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(arr[ran_quote_index]["name"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  )),
                ),

              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (is_ad_loaded)?Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: rest_page),
                  width: rest_page.size.width.toDouble(),
                  height: rest_page.size.height.toDouble(),
                ):Container(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Home(),
                      ),
                          (route) => false,
                    );
                  },
                  child: Container(
                    child: Center(
                      child: Text(
                        "CANCEL",
                        style: KLargebuttonStyle,
                      ),
                    ),
                    color: kBottomHolderColor,
                    padding: EdgeInsets.only(bottom: 10.0),
                    margin: EdgeInsets.only(top: 10.0),
                    width: double.infinity,
                    height: kBottomContainerHeight,
                  ),
                )
              ],
            ),

          ],
        ));
  }
}
// flutterTts.setLanguage("hi");
