import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SecureStorageService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _organNameKey = 'organ_name';

  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> saveOrganTokens({
    required String accessToken,
    required String refreshToken,
    required String organName,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _organNameKey, value: organName);
  }

  Future<Map<String, String?>> readOrganTokens() async {
    return {
      _accessTokenKey: await _storage.read(key: _accessTokenKey),
      _refreshTokenKey: await _storage.read(key: _refreshTokenKey),
      _organNameKey: await _storage.read(key: _organNameKey),
    };
  }

  Future<void> clearOrganTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _organNameKey);
  }
}

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  const storage = FlutterSecureStorage();
  return SecureStorageService(storage);
});

final loginStateProvider = FutureProvider<bool>((ref) async {
  final storage = ref.watch(secureStorageServiceProvider);
  final token = await storage.readOrganTokens();
  final accessToken = token['access_token'];
  if (accessToken == null || accessToken.isEmpty) {
    return false;
  }
  if (JwtDecoder.isExpired(accessToken)) {
    await storage.clearOrganTokens();
    return false;
  }
  return true;
});
