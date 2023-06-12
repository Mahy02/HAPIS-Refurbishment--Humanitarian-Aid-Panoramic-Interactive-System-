/// Model that represents the `Connection with the LG`, with all of its properties and methods.
class ConnectionModel {
  /// Property that defines the Liquid Galaxy master username.
  /// Default is 'lg'.
  String username;

  /// Property that defines the Liquid Galaxy master password.
  String password;

  /// Property that defines the Liquid Galaxy master IP.
  String ip;

  /// Property that defines the Liquid Galaxy master SSH port.
  /// Defaults is 22.
  int port;

  ConnectionModel({
    this.username = 'lg',
    this.password = '',
    this.ip = '',
    this.port = 22,
  });

  /// Turns a `Map` into a `ConnectionModel`.
  factory ConnectionModel.fromMap(Map<String, dynamic> map) {
    return ConnectionModel(
        username: map['username'],
        password: map['password'],
        ip: map['ip'],
        port: map['port']);
  }

  /// Return a `Map` from the current `ConnectionModel`.
  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
        'ip': ip,
        'port': port,
      };
}
