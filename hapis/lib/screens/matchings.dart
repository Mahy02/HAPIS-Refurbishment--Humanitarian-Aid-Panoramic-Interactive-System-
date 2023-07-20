import 'package:flutter/material.dart';

import '../reusable_widgets/requests_component.dart';

class Matchings extends StatelessWidget {
  const Matchings({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Matchings For You',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ListView.builder(
            itemCount: 20,
            shrinkWrap: true, 
            physics:
                NeverScrollableScrollPhysics(), 
            itemBuilder: (context, index) {
              //check for the no component if none available
              return ListTile(
                  title: RequestComponent(
                isSent: false,
                isMatching: true,
                isDonation: false,
              ));
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
