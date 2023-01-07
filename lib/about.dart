import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool is_ad_loaded=false;
  final AdSize adSize = AdSize(width: 320, height: 50);
  BannerAd about_banner;
  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
  @override
  void initState() {
    // TODO: implement initState
    about_banner = BannerAd(
      adUnitId: 'ca-app-pub-1550645510514235/3290017948',
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
    about_banner.load();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Colors.red,
                  backgroundImage: AssetImage('images/eds.png')),
              Text(
                'Education Sword ™',
                style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 35,
                    // color: Colors.deepOrange[600],
                    color: Colors.deepOrange[600],
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Developer',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 21,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 180.0,
                child: Divider(
                  color: Colors.deepOrange,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL(
                      'mailto:mstoff77@gmail.com?subject=About%20Suryanamaskar%20App');
                },
                child: Card(
                    margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.google, size: 40),
                      title: Text('mstoff77@gmail.com',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 21,
                          )),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL('https://www.instagram.com/ed.sword');
                },
                child: Card(
                    margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 30.0),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.instagram, size: 40),
                      title: Text('ed.sword',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 21,
                          )),
                    )),
              ),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              (is_ad_loaded)?Container(
                alignment: Alignment.center,
                child: AdWidget(ad: about_banner),
                width: about_banner.size.width.toDouble(),
                height: about_banner.size.height.toDouble(),
              ):Container()
            ]),
          ],
        ),
      ),
    );
  }
}
