import 'package:flutter/material.dart';

///This [NoComponentWidget] is a [StatelessWidget] which takes as inputs [displayText] and [icon]
///It is displayed if no component is available while fetching data from the API or Database
///
class NoComponentWidget extends StatelessWidget {
  final String displayText;
  final IconData icon;

  const NoComponentWidget({
    Key? key,
    required this.displayText,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2.0,
                color: Colors.grey,
              ),
            ),
            child: Icon(
              icon,
              size: 50.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: Text(
              displayText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(236, 77, 77, 77),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
