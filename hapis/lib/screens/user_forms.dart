import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/get_matchings_model.dart';
import 'package:hapis/models/db_models/user_model.dart';
import 'package:hapis/reusable_widgets/back_button.dart';
import 'package:hapis/services/db_services/users_services.dart';

import '../helpers/google_signin_api.dart';
import '../helpers/login_session_shared_preferences.dart';
import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/personal_form_component.dart';
import '../reusable_widgets/requests_component.dart';
import '../services/db_services/matchings_db_services.dart';

class UserForms extends StatefulWidget {
  final double fontSize;
  final double subHeadFontSize;

  final double deleteSize;
  final double editSize;

  const UserForms({
    super.key,
    required this.fontSize,
    required this.subHeadFontSize,
    required this.deleteSize,
    required this.editSize,
  });

  @override
  State<UserForms> createState() => _UserFormsState();
}

class _UserFormsState extends State<UserForms> {
  late String id;
  late Future<List<UserModel>>? _future;

  @override
  void initState() {
    super.initState();
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getUserID()!;
    }
    _future = UserServices().getUserForms(id);
  }

  Future<void> _refreshData() async {
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getUserID()!;
    }

    setState(() {
      _future = UserServices().getUserForms(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching forms'));
          }
          final formsList = snapshot.data ?? [];

          final noForms = formsList.isEmpty;

          return noForms!
              ? const NoComponentWidget(
                  displayText: 'You don\'t have any Filled Forms',
                  icon: Icons.assignment_outlined)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 40),
                        child: Text(
                          'Your Forms',
                          style: TextStyle(
                              fontSize: widget.subHeadFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        itemCount: formsList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final UserModel form = formsList[index];
                        

                          return ListTile(
                              title: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: PersonalFormComponent(
                              form: form,
                              fontSize: widget.fontSize,
                              editSize: widget.editSize,
                              deletesize: widget.deleteSize,
                              onPressed: () {
                                _refreshData();
                              },
                            ),
                          ));
                        },
                      ),
                    ],
                  ),
                );
        });
  }
}
