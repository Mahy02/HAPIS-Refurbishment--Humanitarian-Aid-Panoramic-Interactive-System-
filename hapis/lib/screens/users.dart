import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/services/db_services/users_services.dart';
import 'package:provider/provider.dart';

import '../components/tabs/donors_tab.dart';
import '../components/tabs/seekers_tab.dart';
import '../models/db_models/user_model.dart';
import '../providers/user_provider.dart';

class UsersPage extends StatefulWidget {
  final double fontSize;
  const UsersPage({Key? key, required this.fontSize}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserModel> seekers = [];
  List<UserModel> donors = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(indicatorColor: HapisColors.lgColor3, tabs: [
            Tab(
              child: Text(
                'Donors',
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: Color.fromARGB(236, 77, 77, 77),

                ),
              ),
            ),
            Tab(
              child: Text(
                'Seekers',
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: Color.fromARGB(236, 77, 77, 77),

                  /// set the text color here
                ),
              ),
            
            ),
           
          ]),

          ///we need a tab bar view for the content of our 3 tabs:
          const Expanded(
            child: TabBarView(children: [
              //1st tab:
              DonorsTab(),

              //2nd tab:
              SeekersTab(),
            ]),
          )
        ],
      ),
    );
  }

 
}