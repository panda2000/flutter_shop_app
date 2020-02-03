
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future <void> _authenticate(String email, String password, String urlSegment) async {
    final url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyDV-72CIbq7z7iPpH68bHQw-4crF4mp6r0";
    final response = await http.post(url, body: json.encode({
      'email':email,
      'password':password,
      'returnSecureToken': true
    }));
    print(json.decode(response.body));
  }

  Future <void> singup (String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future <void> login (String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }
}