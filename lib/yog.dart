import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wakelock/wakelock.dart';

import 'constant.dart';
import 'home.dart';
import 'rest.dart';
import 'reusablecard.dart';

class Yog extends StatefulWidget {
  final int rounds;
  final int rest;
  final int timepose;
  final bool on_off;
  final int flag;
  Yog(this.rounds, this.rest, this.timepose, this.on_off, this.flag);
  @override
  _YogState createState() => _YogState();
}
// flutterTts.setLanguage("hin");

class _YogState extends State<Yog> {
  int steps = 1;
  String Asana_View;
  FlutterTts flutterTts = FlutterTts();
  Timer _timer;
  String breathe;

  final Player = AudioCache();
  static int current_round = 1;
  int img;
  bool is_ad_loaded=false;
  final AdSize adSize = AdSize(width: 320, height: 50);
  Future<void> speak_mantra_asana(int step, bool on) async {
    String msg;
    String asana;
    flutterTts.setLanguage('hi');
    switch (step) {
      case 1:
        msg = "Oṃ Mitrāya Namaḥ affectionate to all";
        asana = "Tadasana";
        breathe = "Out";
        img = 1;
        break;
      case 2:
        msg = "Oṃ Ravaye Namaḥ cause of all changes";
        asana = "Urdhva Hastasana ";
        breathe = "In";
        img = 2;
        break;
      case 3:
        msg = "Oṃ Sūryāya Namaḥ who induces all activity";
        asana = "Padahastasana ";
        breathe = "Out";
        img = 3;
        break;
      case 4:
        msg = "Oṃ Bhānave Namaḥ who diffuses light";
        asana = "Ashwa Sanchalanasana";
        breathe = "In";
        img = 4;
        break;
      case 5:
        msg = "Oṃ Khagāya Namaḥ who moves in the sky";
        asana = "Parvatasana ";
        breathe = "Out";
        img = 5;
        break;
      case 6:
        msg = "Oṃ Pūṣṇe Namaḥ who nourishes all";
        asana = "Ashtanga Namaskara ";
        breathe = "Hold";
        img = 6;
        break;
      case 7:
        msg = "Oṃ Hiraṇya Garbhāya Namaḥ who contains everything";
        asana = "Bhujangasana ";
        breathe = "In";
        img = 7;
        break;
      case 8:
        msg = "Oṃ Marīcaye Namaḥ	who possesses raga";
        asana = "Parvatasana ";
        breathe = "Out";
        img = 8;
        break;
      case 9:
        msg = "Oṃ Ādityāya Namaḥ	Son Of Aditi";
        asana = "Ashwa Sanchalanasana";
        breathe = "In";
        img = 9;
        break;
      case 10:
        msg = "Oṃ Savitre Namaḥ	who produces everything";
        asana = "Padahastasana ";
        breathe = "Out";
        img = 10;
        break;
      case 11:
        msg = "Arkāya Namaḥ	fit to be worshipped";
        asana = "Urdhva Hastasana	";
        breathe = "In";
        img = 11;
        break;
      case 12:
        msg = "Oṃ Bhāskarāya Namaḥ	cause of lustre";
        asana = "Tadasana";
        breathe = "Out";
        img = 12;
        break;
    }
    setState(() {
      Asana_View = asana;
    });
    Player.play('beep.wav');
    print(on);
    if (on && msg != null) {
      flutterTts.setErrorHandler((msgx) {
        print("error: $msgx");
      });
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(msg);
    }
  }
 BannerAd yog_page;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    yog_page=BannerAd(
      adUnitId: 'ca-app-pub-1550645510514235/9200836085',
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
    yog_page.load();
    setState(() {
      if (widget.flag == 1) current_round = 1;
    });
    speak_mantra_asana(steps, widget.on_off);
    Wakelock.enable();
    _timer = new Timer.periodic(Duration(seconds: widget.timepose), (timer) {
      setState(() {
        steps++;

        if (steps <= 12) speak_mantra_asana(steps, widget.on_off);
        if (steps == 13) {
          sleep(const Duration(seconds: 1));
          timer.cancel();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Rest(widget.rounds,
                  widget.rest, widget.timepose, widget.on_off, current_round),
            ),
            (route) => false,
          );
          current_round++;
          steps = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    yog_page.dispose();
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
        body: Center(
          child: Column(
            children: [
              Container(
                  width: double.infinity,

                  // decoration: BoxDecoration(
                  //     border: Border.all(width: 1, color: Colors.white)),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/nm/im_$img.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                      Text(
                        Asana_View,
                        style: TextStyle(
                            fontSize: 22,
                            color: kBottomHolderColor,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
              Expanded(
                child: ReusableCard(Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Current Round :' + current_round.toString(),
                        style: TextStyle(
                            fontSize: 30,
                            color: Color(0xffF38D11),
                            fontWeight: FontWeight.bold),
                    )
                      ),
                    Center(
                      child: Text(
                        'Breathe :' + breathe,
                        style: TextStyle(fontSize: 21, color: Colors.green),
                      ),
                    ),

                  ],
                )),
              ),
              GestureDetector(
                onTap: () {
                  Wakelock.disable();
                  _timer.cancel();
                  setState(() {
                    current_round = 1;
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()),
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
              ),

            (is_ad_loaded)?Container(
          alignment: Alignment.center,
          child: AdWidget(ad: yog_page),
          width: yog_page.size.width.toDouble(),
          height: yog_page.size.height.toDouble(),
        ):Container()
            ],
          ),
        ));
  }
}
