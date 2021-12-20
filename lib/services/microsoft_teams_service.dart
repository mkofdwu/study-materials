import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MicrosoftTeamsService extends GetxService {
  static final config = Config(
    tenant: "common",
    clientId: "002f468b-27ef-481b-a965-b677e595e24f",
    scope: "User.Read Team.ReadBasic.All",
    redirectUri: "com.example.studymaterials://auth",
  );

  final AadOAuth oauth = AadOAuth(config);

  String? _accessToken;
  bool get isConnected => _accessToken != null;

  Future<void> connect() async {
    await oauth.login();
    _accessToken = await oauth.getAccessToken();
    if (_accessToken == null) {}
  }

  Future<void> disconnect() async {
    await oauth.logout();
  }

  listTeams() async {
    if (!isConnected) return;

    final response = await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me/joinedTeams'),
      headers: {
        'Authorization': 'Bearer ' + _accessToken!,
      },
    );
    response.body;
  }
}
