class OrganLoginResponse {
  final String accessToken;
  final String refreshToken;
  final String organName;

  OrganLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.organName,
  });

  factory OrganLoginResponse.fromJson(Map<String, dynamic> json) {
    return OrganLoginResponse(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      organName: json['organName']?.toString() ?? '',
    );
  }
}
