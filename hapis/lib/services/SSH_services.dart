import 'package:flutter/material.dart';
import 'package:hapis/models/ssh_model.dart';
import 'package:hapis/providers/connection_provider.dart';
import 'package:ssh2/ssh2.dart';
import 'package:provider/provider.dart';

///This class is mainly for the SSH services such as getting the settings entered by the user from the provider
///And then by these setting data, we would set the client so that the client is now connected with the LG

class SSHService {
 

  /// Property that defines the SSH client instance.
  late SSHClient _client;

  /// Property that gets the SSH client instance.
  SSHClient get client => _client;

  /// Sets a client with the given [ssh] info.
  void setClient(SSHModel ssh) {
    _client = SSHClient(
      host: ssh.host,
      port: ssh.port,
      username: ssh.username,
      passwordOrKey: ssh.passwordOrKey,
    );
  }

  Future<void> init(BuildContext context) async {
   final settings =  Provider.of<Connectionprovider>(context);
    setClient(SSHModel(
      username: settings.connectionFormData.username,
      host: settings.connectionFormData.ip,
      passwordOrKey: settings.connectionFormData.password,
      port: settings.connectionFormData.port,
    ));
  }

  /// Connects to the current client, executes a command into it and then disconnects.
  Future<String?> execute(String command) async {
    String? result = await connect();

    String? execResult;

    if (result == 'session_connected') {
      execResult = await _client.execute(command);
    }

    await disconnect();
    return execResult;
  }

  /// Connects to a machine using the current client.
  Future<String?> connect() async {
    return _client.connect();
  }

  /// Disconnects from the a machine using the current client.
  Future<SSHClient> disconnect() async {
    await _client.disconnect();
    return _client;
  }

  /// Connects to the current client through SFTP, uploads a file into it and then disconnects.
  /// uploading kml file
  Future<void> uploadKml(String filePath) async {
    await connect();
    String? result = await _client.connectSFTP();

    if (result == 'sftp_connected') {
      await _client.sftpUpload(
          path: filePath,
          toPath: '/var/www/html',
          callback: (progress) {
            print('Sent $progress');
          });
    }
  }
}
