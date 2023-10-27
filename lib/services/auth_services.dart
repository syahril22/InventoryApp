import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventory_app/models/response_login.dart';

const host = "192.168.70.229";

class AuthServices {
  Future<ResponseLogin> login(String email, String password) async {
    final uri = Uri.http(host, "server_inventory/index.php/api/login");
    final response = await http.post(
      uri,
      body: {"email": email, "password": password},
    );
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      ResponseLogin responseLogin = ResponseLogin.fromJson(decode);
      return responseLogin;
    } else {
      return ResponseLogin(pesan: "Gagal login", sukses: false);
    }
  }
}
