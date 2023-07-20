import 'package:flutter/material.dart';

import '../reusable_widgets/requests_component.dart';

class Donations extends StatelessWidget {
  const Donations({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Donations In progress',
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
                isMatching: false,
                isDonation: true,
              ));
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
