import 'package:flutter/material.dart';

import '../reusable_widgets/requests_component.dart';

class Requests extends StatelessWidget {
  const Requests({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Requests Recieved',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.5, 
            child: ListView.builder(
              itemCount: 20, 
              itemBuilder: (context, index) {
              //check for the no component if none available
                return ListTile(
                    title: RequestComponent(
                  isSent: false,
                  isMatching: false,
                  isDonation: false,
                ));
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Requests Sent',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return ListTile(
                    title: RequestComponent(
                  isSent: true,
                  isMatching: false,
                  isDonation: false,
                ));
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }
}
