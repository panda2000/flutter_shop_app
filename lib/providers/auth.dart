
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future <void> singup (String email, String password) async {
    const url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDV-72CIbq7z7iPpH68bHQw-4crF4mp6r0";
    final response = await http.post(url, body: json.encode({
      'email':email,
      'password':password,
      'returnSecureToken': true
    }));
    print(json.decode(response.body));
  }
}