/// Model that represents the `ssh`, with all of its properties and methods.
class SSHModel {
  /// Property that defines the SSH host address.
  ///
  /// Example
  /// ```
  /// '192.168.0.1'
  /// ```
  String host;

  /// Property that defines the SSH port. Default is 22
  int port;

  /// Property that defines the SSH machine username.
  String username;

  /// Property that defines the SSH machine password or RSA private key.
  String passwordOrKey;

  SSHModel(
      {this.host = '',
      this.port = 22,
      this.username = '',
      this.passwordOrKey = ''});
}