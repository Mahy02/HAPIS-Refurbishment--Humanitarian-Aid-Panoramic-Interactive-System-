import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dartssh2/dartssh2.dart';

import '../models/ssh_model.dart';
import 'connection_provider.dart';

///This is a [Provider] class of [SSHprovider] that extends [ChangeNotifier]

///They all have setters and getters
///We have [saveData] method to save data into the form using [SSHModel]
/// [init] is the function that sets the client with its data when connected
/// [execute] is used to execute a specefic command when connecting with the client
/// [uploadKml] is used to upload a file as kml
///  [disconnect] is used for disconnecting the client

class SSHprovider extends ChangeNotifier {
  String? _host;

  /// Property that defines the SSH port. Default is 22
  int? _port;

  /// Property that defines the SSH machine username.
  String? _username;

  /// Property that defines the SSH machine password or RSA private key.
  String? _passwordOrKey;

  int? _numberOfScreens;

  SSHClient? _client;

  /// Sets a client with the given [ssh] info.
  /// /// Sets a client with the given [ssh] info.
  // void setClient(SSHModel ssh) {
  //   _client = SSHClient(
  //     host: ssh.host,
  //     port: ssh.port,
  //     username: ssh.username,
  //     passwordOrKey: ssh.passwordOrKey,
  //   );
  //   print("checking set client");
  //   print(_client!.username);
  // }

  Future<String?> setClient(SSHModel ssh) async {
    String result = "";

    try {
      final socket = await SSHSocket.connect(ssh.host, ssh.port);
      String? password;
      bool isAuthenticated = false;
      //final authenticationCompleter = Completer<void>();
      _client = SSHClient(
        socket,
        onPasswordRequest: () {
          password = ssh.passwordOrKey;
          print('Password requested: ${password}');
          return password;
        },
        username: ssh.username,
        onAuthenticated: () {
          // authenticationCompleter
          //     .complete(); // Notify that authentication is complete
          isAuthenticated = true;
          print('SSH client authenticated');
        },
        keepAliveInterval: const Duration(seconds: 360000),
      );
      print("outside");
      print(isAuthenticated);

      // Wait for authentication to complete
      //await authenticationCompleter.future;

      // Add a delay before checking isAuthenticated
      await Future.delayed(Duration(seconds: 10));
      print("after delay");
      print(isAuthenticated);

      if (isAuthenticated) {
        print('Connected to the SSH server.');
      } else {
        // Perform additional checks if necessary
        // For example, check if the client is connected to the server,
        // check for supported SSH versions, etc.
        print("inside not auth");
        // If the client is not authenticated, indicate a failed connection
        throw Exception('SSH authentication failed');
      }

      // Perform other operations on the connected socket
    } catch (e) {
      print('Failed to connect to the SSH server: $e');
      result = "Failed to connect to the SSH server: $e";
    }

    // print("checking set client");
    // print(_client!.username);
    print("after set client the result is:");
    print(result);
    return result;
  }

  set host(String? value) {
    _host = value;
    notifyListeners();
  }

  set port(int? value) {
    _port = value;
    notifyListeners();
  }

  set numberOfScreens(int? value) {
    _numberOfScreens = value;
    notifyListeners();
  }

  set username(String? value) {
    _username = value;
    notifyListeners();
  }

  set passwordOrKey(String? value) {
    _passwordOrKey = value;
    notifyListeners();
  }

  String? get passwordOrKey => _passwordOrKey;
  String? get username => _username;
  String? get host => _host;
  int? get port => _port;
  int? get numberOfScreens => _numberOfScreens;

  /// Property that gets the SSH client instance.
  SSHClient? get client => _client;

  final SSHModel _sshData = SSHModel();
  SSHModel get sshData => _sshData;

  void saveData(String host, String username, String passwordOrKey, int port,
      int screenAmount) {
    _sshData.host = host;
    _sshData.passwordOrKey = passwordOrKey;
    _sshData.username = username;
    _sshData.port = port;
    _sshData.screenAmount = screenAmount;

    notifyListeners();
  }

  Future<String?> init(BuildContext context) async {
    final settings = Provider.of<Connectionprovider>(context, listen: false);
    print("inside init in ssh services");
    print("getting data from provider");
    print(settings.connectionFormData.username);
    print(settings.connectionFormData.ip);
    print(settings.connectionFormData.password);
    print(settings.connectionFormData.port);
    String? result = await setClient(SSHModel(
      username: settings.connectionFormData.username,
      host: settings.connectionFormData.ip,
      passwordOrKey: settings.connectionFormData.password,
      port: settings.connectionFormData.port,
    ));
    _username = settings.connectionFormData.username;
    _host = settings.connectionFormData.ip;
    _passwordOrKey = settings.connectionFormData.password;
    _port = settings.connectionFormData.port;
    _numberOfScreens = settings.connectionFormData.screenAmount;

    notifyListeners();
    return result;
  }

  /// Connects to the current client, executes a command into it and then disconnects.
  Future<SSHSession> execute(String command) async {
    //String? result = await connect();

    //String? execResult;
    SSHSession execResult;

    //if (result == 'session_connected') {
    // await _client!.execute(command);
    //}
    //try {
    execResult = await _client!.execute(command);
    //} catch (e) {
    //  print(e);
    // }

    //await disconnect();
    notifyListeners();
    return execResult;
  }

  /// Connects to a machine using the current client.
  // Future<String?> connect() async {
  //   return _client!.connect();
  // }

  /// Disconnects from the a machine using the current client.
  Future<SSHClient> disconnect() async {
    _client!.close();
    return _client!;
  }

  /// Connects to the current client through SFTP, uploads a file into it and then disconnects.
  /// uploading kml file
  // Future<void> uploadKml(String filePath) async {
  //   // await connect();
  //   String? result = await _client!.connectSFTP();

  //   if (result == 'sftp_connected') {
  //     await _client!.sftpUpload(
  //         path: filePath,
  //         toPath: '/var/www/html',
  //         callback: (progress) {
  //           print('Sent $progress');
  //         });
  //   }
  //   notifyListeners();
  // }

  uploadKml(File inputFile, String filename) async {
    final sftp = await _client?.sftp();
    double anyKindofProgressBar;
    final file = await sftp?.open('/var/www/html/$filename',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write);
    var fileSize = await inputFile.length();
    await file?.write(inputFile.openRead().cast(), onProgress: (progress) {
      anyKindofProgressBar = progress / fileSize;
      print(anyKindofProgressBar);
    });
    print("finish upload");
  }
}
