import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/providers/connection_provider.dart';
import 'package:hapis/services/SSH_services.dart';
import 'package:provider/provider.dart';
import '../reusable_widgets/app_bar.dart';
import '../reusable_widgets/hapis_elevated_button.dart';
import '../reusable_widgets/sub_text.dart';
import '../reusable_widgets/text_form_field.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(
        appBarText: '',
      ),
      drawer: const Drawer(
          // Drawer content goes here
          ),
      body: Consumer<Connectionprovider>(
        builder: (BuildContext context, model, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 50,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SubText(subTextContent: 'LG Configuration Settings'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'User Name',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Expanded(
                                child: TextFormFieldWidget(
                                  key: const ValueKey("username"),
                                  textController: model.userNameController,
                                  isSuffixRequired: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'LG password',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                              Expanded(
                                child: TextFormFieldWidget(
                                  key: const ValueKey("lgpass"),
                                  textController: model.passwordOrKeyController,
                                  isSuffixRequired: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Master IP address',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormFieldWidget(
                                  key: const ValueKey("ip"),
                                  textController: model.hostController,
                                  isSuffixRequired: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Port Number',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                              Expanded(
                                child: TextFormFieldWidget(
                                  key: const ValueKey("port"),
                                  textController: model.portController,
                                  isSuffixRequired: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 100,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<Connectionprovider>(context, listen: false)
                            .saveData(
                                model.hostController,
                                model.passwordOrKeyController,
                                model.portController,
                                model.userNameController);
                      }
                     
                      final sshService = SSHService();
                      // Call the init function to set up the SSH client with the connection data
                      sshService.init(context);

                      // Connect to the Liquid Galaxy
                      sshService.connect();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: HapisColors.lgColor4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      //  minimumSize: ,
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 35,
                          color: Colors.white),
                    ),
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
