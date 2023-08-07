import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/back_button.dart';
import 'package:hapis/reusable_widgets/liquid_galaxy/connection_indicator.dart';
import 'package:provider/provider.dart';

import '../../helpers/lg_connection_shared_preferences.dart';
import '../../providers/liquid_galaxy/connection_provider.dart';
import '../../providers/liquid_galaxy/ssh_provider.dart';
import '../../reusable_widgets/app_bar.dart';
import '../../reusable_widgets/sub_text.dart';
import '../../reusable_widgets/text_form_field.dart';
import '../../services/liquid_galaxy/LG_functionalities.dart';
import '../../utils/drawer.dart';
import '../../utils/show_connection_error.dart';

///This is we configure the connection between the LG and the tablet app
///We need a username, password, master IP address and port number as well as number of screens for valid connection
///We update the data in the [Connectionprovider] Class and if data is valid we establish a connection from the [SSHprovider]
///The Configruation widget use the custom [HAPISAppBar] and calls [buildDrawer] for the [Drawer]
///It uses [Consumer] to save the data in the [Connectionprovider]

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  /// `form key` for our configuration form
  final _formKey = GlobalKey<FormState>();

  /// `is loading` to Track the loading state
  bool _isLoading = false;

  final TextEditingController _ipController =
      TextEditingController(text: LgConnectionSharedPref.getIP());
  final TextEditingController _portController =
      TextEditingController(text: LgConnectionSharedPref.getPort());
  final TextEditingController _userNameController =
      TextEditingController(text: LgConnectionSharedPref.getUserName());
  final TextEditingController _passwordController =
      TextEditingController(text: LgConnectionSharedPref.getPassword());
  final TextEditingController _screenAmountController = TextEditingController(
      text: LgConnectionSharedPref.getScreenAmount().toString());
//  bool isConnected = LgConnectionSharedPref.getIsConnected()!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HAPISAppBar(
          appBarText: '',
          isLg: true,
        ),
        drawer: ResponsiveLayout(
            mobileBody: buildDrawer(context, true, 18, 16),
            tabletBody: buildDrawer(context, true, 24, 20)),
        body: ResponsiveLayout(
            mobileBody: buildMobileLayout(context),
            tabletBody: buildTabletLayout(context)));
  }

  Widget buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<Connectionprovider>(
        builder: (BuildContext context, model, Widget? child) {
          return
              //child:
              Padding(
            padding: const EdgeInsets.all(50.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    BackButtonWidget(isTablet: false,),
                    ConnectionIndicator(isConnected: model.isConnected),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SubText(
                          subTextContent: 'LG Configuration Settings',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'Connection Status: ',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: HapisColors.lgColor1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      model.isConnected == true ? "Connected" : "Not Connected",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        color: model.isConnected == true
                            ? HapisColors.lgColor4
                            : HapisColors.lgColor2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 2,
                                child: TextFormFieldWidget(
                                  fontSize: 18,
                                  label: 'LG User Name',
                                  key: const ValueKey("username"),
                                  textController: _userNameController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 2,
                                child: TextFormFieldWidget(
                                  fontSize: 18,
                                  label: 'LG Password',
                                  key: const ValueKey("lgpass"),
                                  textController: _passwordController,
                                  isSuffixRequired: true,
                                  isHidden: true,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 2,
                                child: TextFormFieldWidget(
                                  fontSize: 18,
                                  key: const ValueKey("ip"),
                                  label: 'LG Master IP address',
                                  textController: _ipController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 2,
                                child: TextFormFieldWidget(
                                  fontSize: 18,
                                  label: 'LG Port Number',
                                  key: const ValueKey("port"),
                                  textController: _portController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 2,
                                child: TextFormFieldWidget(
                                  fontSize: 18,
                                  label: 'Number of LG screens',
                                  key: const ValueKey("lgscreens"),
                                  textController: _screenAmountController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: ElevatedButton(
                        onPressed: () async {
                          /// checking first if form is valid
                          if (_formKey.currentState!.validate()) {
                            // ///calling `saveData` from the provider to save the data entered by the user
                            // Provider.of<Connectionprovider>(context,
                            //         listen: false)
                            //     .saveData(
                            //   model.userNameController,
                            //   model.hostController,
                            //   model.passwordOrKeyController,
                            //   model.portController,
                            //   model.screenAmountController,
                            //   model.isConnected,
                            // );
                            //saving date in shared pref
                            await LgConnectionSharedPref.setUserName(
                                _userNameController.text);
                            await LgConnectionSharedPref.setIP(
                                _ipController.text);
                            await LgConnectionSharedPref.setPassword(
                                _passwordController.text);
                            await LgConnectionSharedPref.setPort(
                                _portController.text);
                            await LgConnectionSharedPref.setScreenAmount(
                                int.parse(_screenAmountController.text));
                          }

                          final sshData =
                              Provider.of<SSHprovider>(context, listen: false);

                          ///start the loading process by setting `isloading` to true
                          setState(() {
                            _isLoading = true;
                          });

                          /// Call the init function to set up the SSH client with the connection data
                          String? result = await sshData.init(context);

                          Connectionprovider connection =
                              Provider.of<Connectionprovider>(context,
                                  listen: false);

                          ///checking on the connection status:
                          if (result == '') {
                            // setState(() {
                            // isConnected = true;
                            //  });
                            connection.isConnected = true;

                            ///If connected, the logos should appear by calling `setLogos` from the `LGService` calss
                            LgService(sshData).setLogos();
                          } else {
                            ///show an error message
                            showConnectionError(context, result!);
                            connection.isConnected = false;
                          }

                          ///stop the loading process by setting `isloading` to false
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HapisColors.lgColor4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          //  minimumSize: ,
                        ),
                        child: const Text(
                          'CONNECT TO LG',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLoading)

                  /// Show the loading indicator if `_isLoading` is true
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.3,
                    //color: Color.fromARGB(126, 234, 234, 234),
                    child: const CircularProgressIndicator(
                      color: HapisColors.accent,
                      backgroundColor: HapisColors.lgColor3,
                      semanticsLabel: 'Loading',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<Connectionprovider>(
        builder: (BuildContext context, model, Widget? child) {
          return
              //child:
              Padding(
            padding: const EdgeInsets.all(50.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    BackButtonWidget(isTablet: true,),
                    ConnectionIndicator(isConnected: model.isConnected),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 50,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SubText(
                          subTextContent: 'LG Configuration Settings',
                          fontSize: 35,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Connection Status: ',
                          style: TextStyle(
                            fontSize: 38,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: HapisColors.lgColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Text(
                          model.isConnected == true
                              ? "Connected"
                              : "Not Connected",
                          style: TextStyle(
                            fontSize: 35,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: model.isConnected == true
                                ? HapisColors.lgColor4
                                : HapisColors.lgColor2,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  label: 'LG User Name',
                                  key: const ValueKey("username"),
                                  textController: _userNameController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  label: 'LG Password',
                                  key: const ValueKey("lgpass"),
                                  textController: _passwordController,
                                  isSuffixRequired: true,
                                  isHidden: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  key: const ValueKey("ip"),
                                  label: 'LG Master IP address',
                                  textController: _ipController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  label: 'LG Port Number',
                                  key: const ValueKey("port"),
                                  textController: _portController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  label: 'Number of LG screens',
                                  key: const ValueKey("lgscreens"),
                                  textController: _screenAmountController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ElevatedButton(
                        onPressed: () async {
                          /// checking first if form is valid
                          if (_formKey.currentState!.validate()) {
                            ///calling `saveData` from the provider to save the data entered by the user
                            //   Provider.of<Connectionprovider>(context,
                            //           listen: false)
                            //       .saveData(
                            //     model.userNameController,
                            //     model.hostController,
                            //     model.passwordOrKeyController,
                            //     model.portController,
                            //     model.screenAmountController,
                            //     model.isConnected,
                            //   );

                            //saving date in shared pref
                            await LgConnectionSharedPref.setUserName(
                                _userNameController.text);
                            await LgConnectionSharedPref.setIP(
                                _ipController.text);
                            await LgConnectionSharedPref.setPassword(
                                _passwordController.text);
                            await LgConnectionSharedPref.setPort(
                                _portController.text);
                            await LgConnectionSharedPref.setScreenAmount(
                                int.parse(_screenAmountController.text));
                          }

                          final sshData =
                              Provider.of<SSHprovider>(context, listen: false);

                          ///start the loading process by setting `isloading` to true
                          setState(() {
                            _isLoading = true;
                          });

                          /// Call the init function to set up the SSH client with the connection data
                          String? result = await sshData.init(context);

                          Connectionprovider connection =
                              Provider.of<Connectionprovider>(context,
                                  listen: false);

                          ///checking on the connection status:
                          if (result == '') {
                            //setState(() async {
                            // await LgConnectionSharedPref.setIsConnected(true);
                            //});

                            connection.isConnected = true;

                            ///If connected, the logos should appear by calling `setLogos` from the `LGService` calss
                            LgService(sshData).setLogos();
                          } else {
                            connection.isConnected = false;

                            ///show an error message
                            showConnectionError(context, result!);
                          }

                          ///stop the loading process by setting `isloading` to false
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HapisColors.lgColor4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          //  minimumSize: ,
                        ),
                        child: const Text(
                          'CONNECT TO LG',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLoading)

                  /// Show the loading indicator if `_isLoading` is true
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.3,
                    //color: Color.fromARGB(126, 234, 234, 234),
                    child: const CircularProgressIndicator(
                      color: HapisColors.accent,
                      backgroundColor: HapisColors.lgColor3,
                      semanticsLabel: 'Loading',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
