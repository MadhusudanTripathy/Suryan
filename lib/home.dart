import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suryan/about.dart';
import 'package:suryan/quotes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'constant.dart';
import 'reusablecard.dart';
import 'yog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  final AdSize adSize = const AdSize(width: 320, height: 50);
  int rounds = 6; //13
  int timepose = 5; //5
  int rest = 5; //5
  bool _switchValue = true;
  int time_required;
  Random random = Random();
  int ran_quote_index;
  bool is_started = false;
  bool is_ad_loaded = false;
  bool is_ad2_loaded = false;
  Timer _timer;
  int count = 3;
  final arr = Quotes().arr;
  // final Player = AudioCache();
  ScrollController _controller = ScrollController();
  // final BannerAdListener listenerx = BannerAdListener(
  // );

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Future<void> setValues(int a, int b, int c) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('rounds', a);
      prefs.setInt('timepose', b);
      prefs.setInt('rest', c);
    });
  }

  Future<void> loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rounds = (prefs.getInt('rounds') ?? 12);
      timepose = (prefs.getInt('timepose') ?? 5);
      rest = (prefs.getInt('rest') ?? 5);
    });
  }

  int _start = 3;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    Yog(rounds, rest, timepose, _switchValue, 1),
              ),
              (route) => false,
            );
          });
        } else {
          setState(() {
            //Player.play('beep.wav');//
            _start--;
          });
        }
      },
    );
  }

  // Container get_ad_wid()
  // {
  //   final AdWidget adWidget = AdWidget(ad: myBanner);
  //   final Container adContainer = Container(
  //     alignment: Alignment.center,
  //     child: AdWidget(ad: myBanner),
  //     width: myBanner.size.width.toDouble(),
  //     height: myBanner.size.height.toDouble(),
  //   );
  // }
  BannerAd home_banner;
  BannerAd side_bar_banner;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home_banner = BannerAd(
      adUnitId: 'ca-app-pub-1550645510514235/7803978025',
      //my:ca-app-pub-1550645510514235/9267618414
      //test:ca-app-pub-3940256099942544/6300978111
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) {
            setState(() {
              is_ad_loaded = true;
            });
            print('Ad loaded.');
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            setState(() {
              is_ad_loaded = false;
            });
            ad.dispose();

            print('Ad failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.')),
    );
    side_bar_banner = BannerAd(
      adUnitId: 'ca-app-pub-1550645510514235/1046997981',
      //my:ca-app-pub-1550645510514235/9267618414
      //test:ca-app-pub-3940256099942544/6300978111
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) {
            setState(() {
              is_ad2_loaded = true;
            });
            print('Ad loaded.');
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            setState(() {
              is_ad2_loaded = false;
            });
            ad.dispose();

            print('Ad failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.')),
    );
    home_banner.load();
    side_bar_banner.load();
    Wakelock.disable();
    loadValues();
    ran_quote_index = random.nextInt(arr.length);
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller
          .animateTo(_controller.position.maxScrollExtent,
              duration: Duration(seconds: 1), curve: Curves.ease)
          .then((value) async {
        await Future.delayed(Duration(seconds: 1));
        _controller.animateTo(_controller.position.minScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    home_banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: Drawer(
          elevation: 10.0,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Color(0xffF38D11)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        "images/ico.png",
                      ),
                      radius: 40.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Suryan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'For Body Mind And Spirit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14.0),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              //Here you place your menu items
              ListTile(
                leading: Icon(Icons.accessibility),
                title: Text('Learn Surya Namaskar',
                    style: TextStyle(fontSize: 18)),
                onTap: () {
                  _launchURL('https://www.wikihow.com/Perform-Surya-Namaskar');
                },
              ),
              Divider(height: 3.0),
              ListTile(
                leading: Icon(Icons.whatshot_outlined),
                title: Text('Benefits', style: TextStyle(fontSize: 18)),
                onTap: () {
                  _launchURL(
                      'https://www.artofliving.org/in-en/yoga/yoga-benefits/sun-salutation-benefits');
                },
              ),
              Divider(height: 3.0),
              ListTile(
                leading: Icon(Icons.contact_page),
                title: Text('Contact Me', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => About()));
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
              ),
              (is_ad2_loaded)
                  ? Container(
                      alignment: Alignment.center,
                      child: AdWidget(ad: side_bar_banner),
                      width: side_bar_banner.size.width.toDouble(),
                      height: side_bar_banner.size.height.toDouble(),
                    )
                  : Container(),
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Color(0xffFFE194),
            iconTheme: IconThemeData(color: Color(0xffF38D11)),
            title: Text(
              'SURYAN',
              style: TextStyle(color: Color(0xffF38D11)),
            )
            // actions: <Widget>[
            //
            // ],
            ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ReusableCard((is_started)
                          ? Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.705,
                              child: Text(
                                _start == 0 ? 'Go!' : '$_start',
                                style: kResultTextStyle,
                              ))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                labelDesc(
                                    num: rounds,
                                    str: 'Rounds ',
                                    des:
                                        'Each Round Of Suryanamaskar Contains 12 Postures, You Can Set Number Of Rounds You Want To Perform'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline
                                      .alphabetic, //not affect the code i this case remove kale b kichi bhi hebani
                                  children: <Widget>[
                                    Text(
                                      rounds.toString(),
                                      style: kNumberStyle,
                                    )
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 15.0),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 30.0),
                                      thumbColor: kBottomHolderColor,
                                      overlayColor: Color(0x29eb1555),
                                      activeTrackColor: Colors.white,
                                      inactiveTrackColor: Color(0xffd8e98)),
                                  child: Slider(
                                    value: rounds.toDouble(),
                                    min: 1,
                                    max: 144,
                                    label: rounds.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        rounds = value.toInt();
                                      });
                                    },
                                  ),
                                ),
                                // Text(
                                //   "Time (in sec.)",
                                //   style: kLableTextStyle,
                                // ),
                                //
                                labelDesc(
                                    num: timepose,
                                    str: 'Posture Time (in sec.) ',
                                    des:
                                        'Set Duration (in sec.) To Perform Each Posture Out Of 12 Postures'),
                                Text(
                                  timepose.toString(),
                                  style: kNumberStyle,
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 15.0),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 30.0),
                                      thumbColor: kBottomHolderColor,
                                      overlayColor: Color(0x29eb1555),
                                      activeTrackColor: Colors.white,
                                      inactiveTrackColor: Color(0xffd8e98)),
                                  child: Slider(
                                    value: timepose.toDouble(),
                                    min: 1,
                                    max: 21,
                                    label: timepose.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        timepose = value.toInt();
                                      });
                                    },
                                  ),
                                ),
                                // Text(
                                //   "Rest Time (in sec.)",
                                //   style: kLableTextStyle,
                                // ),
                                labelDesc(
                                    num: rest,
                                    str: 'Break Time (in sec.) ',
                                    des:
                                        'Set Time(in seconds) To Take Break After Performing Each Round '),
                                Text(
                                  rest.toString(),
                                  style: kNumberStyle,
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 15.0),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 30.0),
                                      thumbColor: kBottomHolderColor,
                                      overlayColor: Color(0x29eb1555),
                                      activeTrackColor: Colors.white,
                                      inactiveTrackColor: Color(0xffd8e98)),
                                  child: Slider(
                                    value: rest.toDouble(),
                                    min: 2,
                                    max: 60,
                                    label: rest.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        rest = value.toInt();
                                      });
                                    },
                                  ),
                                )
                              ],
                            )),
                    ),

                    // Expanded(
                    //   child: ReusableCard(Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //
                    //     ],
                    //   )),
                    // ),

                    ReusableCard(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(_switchValue
                                    ? CupertinoIcons.volume_up
                                    : CupertinoIcons.volume_off),
                                CupertinoSwitch(
                                  value: _switchValue,
                                  activeColor: kBottomHolderColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _switchValue = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          backgroundColor: Color(0xffFFE194),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          content: Text(
                                            'This Is The Expected Time For Completion Of Your Suryanamaskar Session',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xffF38D11),
                                                fontSize: 20),
                                          ));
                                    });
                              },
                              child: Text(
                                'Session Time ~' +
                                    (((timepose * 12 + rest) * rounds) / 60)
                                        .ceil()
                                        .toString() +
                                    ' Minutes',
                                style: TextStyle(
                                    color: Color(0xffF38D11),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ran_quote_index = random.nextInt(arr.length);
                        });
                      },
                      child: ReusableCard(Padding(
                        padding: const EdgeInsets.all(12.0),
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
                            Text(arr[ran_quote_index]["name"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      )),
                    ),

                    (is_ad_loaded)
                        ? Container(
                            alignment: Alignment.center,
                            child: AdWidget(ad: home_banner),
                            width: home_banner.size.width.toDouble(),
                            height: home_banner.size.height.toDouble(),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                bool val;
                if (!is_started) {
                  // Player.play('beep.wav');
                  val = true;
                  setValues(rounds, timepose, rest);
                  startTimer();
                } else {
                  val = false;
                  _timer.cancel();
                }
                setState(() {
                  is_started = val;
                  _start = 3;
                });
              },
              child: Container(
                child: Center(
                  child: Text(
                    (is_started) ? "CANCEL" : "START",
                    style: KLargebuttonStyle,
                  ),
                ),
                color: kBottomHolderColor,
                padding: const EdgeInsets.only(bottom: 10.0),
                margin: const EdgeInsets.only(top: 10.0),
                width: double.infinity,
                height: kBottomContainerHeight,
              ),
            )
          ],
        ));
  }

  // Row buildSlider(String name, int val, double _min, double _max, Function go) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Expanded(child: Text('$name: $val')),
  //       Expanded(
  //         child: Slider(
  //           value: val.toDouble(),
  //           min: _min,
  //           max: _max,
  //           label: val.round().toString(),
  //           onChanged: go,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class labelDesc extends StatelessWidget {
  const labelDesc({
    Key key,
    @required this.num,
    @required this.str,
    @required this.des,
  }) : super(key: key);

  final int num;
  final String str;
  final String des;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      backgroundColor: const Color(0xffFFE194),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      content: Text(
                        des,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Color(0xffF38D11), fontSize: 20),
                      ));
                });
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: (str == "Rounds " && num == 1) ? "Round " : str,
                    style: kLableTextStyle),
                WidgetSpan(
                  child:  Icon(Icons.info, size: 20, color: Color(0xffF38D11)),
                ),
              ],
            ),
          )),
    );
  }
}
