import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/notify_models.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/services/db_services/notifications_services.dart';
import 'package:hapis/services/notification_services.dart';

import '../helpers/google_signin_api.dart';
import '../helpers/login_session_shared_preferences.dart';
import '../responsive/responsive_layout.dart';
import '../reusable_widgets/back_button.dart';
import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/notify_component.dart';
import '../utils/drawer.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late String id;
  late Future<List<NotifyModel>>? _future;
  @override
  void initState() {
    super.initState();
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getUserID()!;
    }
    _future = NotificationsServices().getNotificationsByUserId(id);
  }

  Future<void> _refreshData() async {
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getUserID()!;
    }

    setState(() {
      _future = NotificationsServices().getNotificationsByUserId(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HAPISAppBar(
        isLg: false,
        appBarText: '',
      ),
      drawer: ResponsiveLayout(
          mobileBody: buildDrawer(context, false, 18, 16),
          tabletBody: buildDrawer(context, false, 24, 20)),
      body: FutureBuilder<List<NotifyModel>>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching notifications'));
            }
            final notifyList = snapshot.data ?? [];
            final noNotify = notifyList.isEmpty;

            return noNotify!
                ? Column(
                    children: [
                      BackButtonWidget(isTablet: false),
                      Expanded(
                        child: const NoComponentWidget(
                            displayText:
                                'You don\'t have any current notifications',
                            icon: Icons.notifications),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        BackButtonWidget(
                          isTablet: false,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        ListView.builder(
                          //itemCount: 20,
                          itemCount: notifyList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final NotifyModel notfiy = notifyList[index];
                            final message = notfiy.message;
                            final id = notfiy.notifyID;

                            return ListTile(
                                title: NotificationComponent(
                              title: 'Notification $index',
                              message: message,
                              id: id,
                              onPressed: () {
                                _refreshData();
                                setState(() {});
                              },
                            ));
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                      ],
                    ),
                  );
          }),
    );
  }
}
