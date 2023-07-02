import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/providers/connection_provider.dart';
import 'package:hapis/providers/ssh_provider.dart';
import 'package:provider/provider.dart';
import '../reusable_widgets/app_bar.dart';
import '../utils/drawer.dart';
import '../reusable_widgets/sub_text.dart';
import '../reusable_widgets/text_form_field.dart';
import '../services/LG_functionalities.dart';
import '../utils/show_connection_error.dart';

///This is we configure the connection between the LG and the tablet app
///We need a username, password, master IP address and port number for valid connection
///We update the data in the [Connectionprovider] Class and if data is valid we establish a connection from the [SSHprovider]

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Track the loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(
        appBarText: '',
      ),
      drawer: Drawer(
          // Drawer content goes here
          child: buildDrawer(context)),
      body: SingleChildScrollView(
        child: Consumer<Connectionprovider>(
          builder: (BuildContext context, model, Widget? child) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 50,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SubText(
                              subTextContent: 'LG Configuration Settings'),
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
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    label: 'LG User Name',
                                    key: const ValueKey("username"),
                                    textController: model.userNameController,
                                    isSuffixRequired: true,
                                    isHidden: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    label: 'LG Password',
                                    key: const ValueKey("lgpass"),
                                    textController:
                                        model.passwordOrKeyController,
                                    isSuffixRequired: true,
                                    isHidden: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    key: const ValueKey("ip"),
                                    label: 'LG Master IP address',
                                    textController: model.hostController,
                                    isSuffixRequired: true,
                                    isHidden: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    label: 'LG Port Number',
                                    key: const ValueKey("port"),
                                    textController: model.portController,
                                    isSuffixRequired: true,
                                    isHidden: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextFormFieldWidget(
                                    label: 'Number of LG screens',
                                    key: const ValueKey("lgscreens"),
                                    textController:
                                        model.screenAmountController,
                                    isSuffixRequired: true,
                                    isHidden: false,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Provider.of<Connectionprovider>(context,
                                      listen: false)
                                  .saveData(
                                model.userNameController,
                                model.hostController,
                                model.passwordOrKeyController,
                                model.portController,
                                model.screenAmountController,
                                model.isConnected,
                              );
                              print(model.connectionFormData.username);
                              print(model.connectionFormData.ip);
                              print(model.connectionFormData.password);
                              print(model.connectionFormData.port);
                              print(model.isConnected);
                            }

                            final sshData = Provider.of<SSHprovider>(context,
                                listen: false);

                            setState(() {
                              _isLoading = true; // Show the loading indicator
                            });

                            // Call the init function to set up the SSH client with the connection data
                            String? result = await sshData.init(context);

                            

                            // Connect to the Liquid Galaxy
                            //String? result = await sshData.connect();
                            // print("client checking in config screen");
                            //print(sshData.client!.username);
                            print(result);

                            //checking on the connection status:
                            if (result == '') {
                              setState(() {
                                //isConnected = true;
                                model.isConnected = true;
                              });
                              LgService(sshData).setLogos();
                            } else {
                              //we want to show a message
                              //TO DO:
                              showConnectionError(context, result!);
                            }

                            setState(() {
                              _isLoading = false; // Show the loading indicator
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: HapisColors.lgColor4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            //  minimumSize: ,
                          ),
                          child: const Text(
                            'Connect to LG',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 42,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isLoading)
                    // Show the loading indicator if _isLoading is true

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
      ),
    );
  }
}
