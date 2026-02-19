class OrganLoginRequest {
  final String organName;
  final String password;
  final String client;

  OrganLoginRequest({
    required this.organName,
    required this.password,
    this.client = 'USER_VIEW',
  });

  Map<String, dynamic> toJson() {
    return {
      'organName': organName,
      'password': password,
      'client': client,
    };
  }
}
