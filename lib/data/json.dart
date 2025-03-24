import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Agency {
  Map<String, dynamic> _data = {
    "code": "888888888888888888",
    "password": "",
    "reg_time": 0,
    "log_time": 0
  };
  bool _isLogin = false;
  Agency() {
    readJsonFile("agency.json").then((value) {
      _data = value;
      if (_data.isNotEmpty &&
          _data["code"] != "888888888888888888" &&
          _data["password"] != "") {
        _isLogin = true;
      }
    });
  }
  bool getLogin() {
    return _isLogin;
  }

  void login() {
    _isLogin = true;
  }

  logout() {
    _isLogin = false;
  }

  Future<bool> validate() async {
    Map<String, dynamic> data = await readJsonFile("agency.json");
    if (kDebugMode) {
      print("data: $data");
      print("_data: $_data");
    }
    if (data["code"] == _data["code"] &&
        data["password"] == _data["password"]) {
      return true;
    }
    return false;
  }

  Future<bool> update() async {
    if (_data["code"].length != 18 || _data["password"].length != 8) {
      return false;
    }
    await writeJsonFile("agency.json", _data);
    return true;
  }

  setData(Map<String, dynamic> data) {
    _data["code"] = data["code"];
    _data["password"] = data["password"];
  }

  Map<String, dynamic> getData() {
    return _data;
  }

  setCode(String code) {
    _data["code"] = code;
  }

  String getCode() {
    return _data["code"];
  }

  setPassword(String password) {
    _data["password"] = password;
  }

  String getPassword() {
    return _data["password"];
  }

  setRegTime(int time) {
    _data["reg_time"] = time;
  }

  int getRegTime() {
    return _data["reg_time"];
  }

  setLogTime(int time) {
    _data["log_time"] = time;
  }

  int getLogTime() {
    return _data["log_time"];
  }
}

class User {
  Map<String, dynamic> _data = {
    "name": "",
    "nickname": "",
    "sex": 0,
    "phone_number": "",
    "address": "",
    "code": "888888888888888888"
  };
  bool _isRegister = false;
  User() {
    readJsonFile("user.json").then((value) {
      _data = value;
      if (_data.isNotEmpty &&
          _data["name"] != "" &&
          _data["nickname"] != "" &&
          _data["phone_number"] != "" &&
          _data["address"] != "" &&
          _data["code"] != "888888888888888888") {
        _isRegister = true;
      }
    });
  }

  bool getRegister() {
    return _isRegister;
  }

  register() {
    _isRegister = true;
  }

  createCode() {
    String generateRandomNumber(int n) {
      if (n <= 0) {
        throw ArgumentError('n must be a positive integer');
      }
      var random = Random();
      var min = pow(10, n - 1).toInt();
      var max = (pow(10, n) - 1).toInt();
      return (min + random.nextInt(max - min + 1)).toString();
    }

    var timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    var randomNumber = generateRandomNumber(18 - timeStamp.length);
    var code = timeStamp + randomNumber;
    _data["code"] = code;
  }

  Future<bool> validate() async {
    Map<String, dynamic> data = await readJsonFile("user.json");
    if (kDebugMode) {
      print("data: $data");
      print("_data: $_data");
    }
    if (data["name"] == _data["name"] &&
        data["nickname"] == _data["nickname"] &&
        data["phone_number"] == _data["phone_number"] &&
        data["address"] == _data["address"]) {
      return true;
    }
    return false;
  }

  Future<bool> update() async {
    if (_data["name"].length < 2 ||
        _data["nickname"].length < 2 ||
        _data["phone_number"].length != 11 ||
        _data["address"].length < 2 ||
        _data["code"] == "888888888888888888") {
      return false;
    }
    await writeJsonFile("user.json", _data);
    return true;
  }

  setData(Map<String, dynamic> data) {
    _data["name"] = data["name"];
    _data["nickname"] = data["nickname"];
    _data["sex"] = data["sex"];
    _data["phone_number"] = data["phone_number"];
    _data["address"] = data["address"];
    _data["code"] = data["code"];
  }

  Map<String, dynamic> getData() {
    return _data;
  }

  setName(String name) {
    _data["name"] = name;
  }

  String getName() {
    return _data["name"];
  }

  setNickname(String nickname) {
    _data["nickname"] = nickname;
  }

  String getNickname() {
    return _data["nickname"];
  }

  setSex(int sex) {
    _data["sex"] = sex;
  }

  int getSex() {
    return _data["sex"];
  }

  int get sex {
    return _data["sex"];
  }

  set sex(int value) {
    _data["sex"] = value;
  }

  setPhoneNumber(String phoneNumber) {
    _data["phone_number"] = phoneNumber;
  }

  String getPhoneNumber() {
    return _data["phone_number"];
  }

  setAddress(String address) {
    _data["address"] = address;
  }

  String getAddress() {
    return _data["address"];
  }

  setCode(String code) {
    _data["code"] = code;
  }

  String getCode() {
    return _data["code"];
  }
}

Future<Map<String, dynamic>> loadJsonAssets(String filePath) async {
  try {
    final contents = await rootBundle.loadString(filePath);
    return json.decode(contents);
  } catch (e) {
    if (kDebugMode) {
      print('读取JSON文件时出错: $e');
    }
    return {};
  }
}

Future<Map<String, dynamic>> readJsonFile(String fileName) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    if (!await file.exists()) {
      final jsonString = await rootBundle.loadString("assets/json/$fileName");
      await file.writeAsString(jsonString);
      return json.decode(jsonString);
    } else {
      final contents = await file.readAsString();
      return json.decode(contents);
    }
  } catch (e) {
    if (kDebugMode) {
      print('读取JSON文件时出错: $e');
    }
    return {};
  }
}

Future<void> writeJsonFile(String fileName, Map<String, dynamic> data) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    final jsonString = json.encode(data);
    await file.writeAsString(jsonString);
  } catch (e) {
    if (kDebugMode) {
      print('写入JSON文件时出错: $e');
    }
  }
}
