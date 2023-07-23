import 'package:flutter/material.dart';

import '../reusable_widgets/requests_component.dart';

class Matchings extends StatelessWidget {
  final double fontSize;
  final double subHeadFontSize;
  final double buttonFontSize;
  //  final double buttonHeight;
  // final double finishButtonHeight;
  // final double pendingButtonHeight;
  //   final double buttonWidth;
  // final double finishButtonWidth;
  // final double pendingButtonWidth;
  const Matchings(
      {super.key, required this.fontSize, required this.subHeadFontSize, required this.buttonFontSize,
      // required this.buttonHeight, required this.finishButtonHeight, required this.pendingButtonHeight, required this.buttonWidth, required this.finishButtonWidth, required this.pendingButtonWidth
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Matchings For You',
              style: TextStyle(
                  fontSize: subHeadFontSize, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ListView.builder(
            itemCount: 20,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              //check for the no component if none available
              return ListTile(
                  title: RequestComponent(
                isSent: false,
                isMatching: true,
                isDonation: false,
                fontSize: fontSize,
                buttonFontSize: buttonFontSize,
                  // buttonHeight: buttonHeight,
                  // finishButtonHeight:finishButtonHeight ,
                  // pendingButtonHeight: pendingButtonHeight,
                  // buttonWidth:buttonWidth ,
                  // pendingButtonWidth:pendingButtonWidth ,
                  // finishButtonWidth: finishButtonWidth,
              ));
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
