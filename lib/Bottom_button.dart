import 'package:flutter/cupertino.dart';

import 'constant.dart';

class BottomButton extends StatelessWidget {
  final Function onPressed;
  final String name;

  BottomButton(this.name, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed,
      child: Container(
        child: Center(
          child: Text(
            name,
            style: KLargebuttonStyle,
          ),
        ),
        color: kBottomHolderColor,
        padding: EdgeInsets.only(bottom: 10.0),
        margin: EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: kBottomContainerHeight,
      ),
    );
  }
}
