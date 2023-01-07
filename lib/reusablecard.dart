import 'package:flutter/cupertino.dart';

class ReusableCard extends StatelessWidget {
  final Widget cardChild;
  ReusableCard(this.cardChild); //to make it necessary to input
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: cardChild,
      margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 15.0),
      decoration: BoxDecoration(
          color: Color(0xffFFE194), borderRadius: BorderRadius.circular(10.0)),
    );
  }
}
