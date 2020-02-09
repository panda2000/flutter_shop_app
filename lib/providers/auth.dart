import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null){
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future <void> _authenticate(String email, String password, String urlSegment) async {
    final url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyDV-72CIbq7z7iPpH68bHQw-4crF4mp6r0";
    try{
      final response = await http.post(url, body: json.encode({
        'email':email,
        'password':password,
        'returnSecureToken': true
      }));
      final responceData = json.decode(response.body);
      if(responceData['error'] != null){
        throw HttpException (responceData['error']['message']);
      }
      _token = responceData['idToken'];
      _userId = responceData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responceData['expiresIn']))) ;

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }


  }

  Future <void> singup (String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future <void> login (String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future <bool> tryAutologin () async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map <String, Object>;
    final exparyDate = DateTime.parse (extractedUserData['expiryDate']);

    if (exparyDate.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = extractedUserData['expiryDate'];
    notifyListeners();
    _autoLogout();
    return true;

  }

  Future <void> logout () async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future <void> _autoLogout () async {
    if (_authTimer != null){
      _authTimer.cancel();
    }
    final _timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _timeToExpiry), logout);
  }
}