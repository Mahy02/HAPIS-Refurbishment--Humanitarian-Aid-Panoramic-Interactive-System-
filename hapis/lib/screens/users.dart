import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';

import '../components/tabs/donors_tab.dart';
import '../components/tabs/seekers_tab.dart';
import '../models/db_models/user_model.dart';


/// The `UsersPage` widget displays a tabbed view of donors and seekers.
///
/// This widget provides a tabbed interface to switch between the list of donors
/// and the list of seekers. Each tab displays a list of user profiles.
/// 
/// **Properties:**
///
/// - `fontSize`: The font size for the text in the tab labels.
///

class UsersPage extends StatefulWidget {
  final double fontSize;
  const UsersPage({Key? key, required this.fontSize}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  
  /// - `seekers`: A list of user models representing seekers.
  List<UserModel> seekers = [];

  /// - `donors`: A list of user models representing donors.
  List<UserModel> donors = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          
          TabBar(
            indicatorColor: HapisColors.lgColor3,
            tabs: [
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
                  ),
                ),
              ),
            ],
          ),
       
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
