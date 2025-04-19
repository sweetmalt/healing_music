import 'package:get/get.dart';
import 'package:healing_music/data/data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DepotController extends GetxController {
  final User user = User();
  @override
  void onInit() async {
    super.onInit();
    await user.init();
  }
}

class User {
  final RxInt id = 0.obs;
  final RxString agencyName = "".obs;
  final RxInt tokens = 0.obs;
  final RxString registTimestamp = "".obs;
  final RxString lastLoginTimestamp = "".obs;
  final RxString adminNickname = "".obs;
  final RxString adminPhonenumber = "".obs;
  final RxString adminPassword = "".obs;
  final RxString adminAddress = "".obs;
  final RxInt vip = 0.obs;//0普通用户，1vip用户(生成报告需扣分)，2vip(生成报告不扣分)

  final RxInt loginState = 0.obs; //0未登录，1登录中，2登录成功

  User();

  Future<void> init() async {
    final Map<String, dynamic> user = await Data.read("user.json");
    id.value = user["id"];
    agencyName.value = user["agency_name"];
    tokens.value = user["tokens"];
    registTimestamp.value = user["regist_timestamp"];
    lastLoginTimestamp.value = user["last_login_timestamp"];
    adminNickname.value = user["admin_nickname"];
    adminPhonenumber.value = user["admin_phonenumber"];
    adminPassword.value = user["admin_password"];
    adminAddress.value = user["admin_address"];
    vip.value = user["vip"];
    if (id.value != 0) {
      loginState.value = 2;
    }
  }

  Future<void> cache() async {
    final Map<String, dynamic> user = {
      "id": id.value,
      "agency_name": agencyName.value,
      "tokens": tokens.value,
      "regist_timestamp": registTimestamp.value,
      "last_login_timestamp": lastLoginTimestamp.value,
      "admin_nickname": adminNickname.value,
      "admin_phonenumber": adminPhonenumber.value,
      "admin_password": adminPassword.value,
      "admin_address": adminAddress.value,
      "vip": vip.value,
    };
    await Data.write(user, "user.json");
  }

  Future<void> login() async {
    loginState.value = 1;
    var response = await http.post(
      Uri.parse('https://ur.healingai.top/api/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'admin_phonenumber': adminPhonenumber.value,
        'admin_password': adminPassword.value,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> user = responseData['user'];
      id.value = user["id"];
      agencyName.value = user["agency_name"];
      tokens.value = user["tokens"];
      registTimestamp.value = user["regist_timestamp"];
      lastLoginTimestamp.value = user["last_login_timestamp"];
      adminNickname.value = user["admin_nickname"];
      //adminPhonenumber.value = user["admin_phonenumber"];
      //adminPassword.value = user["admin_password"];
      adminAddress.value = user["admin_address"];
      vip.value = user["vip"];
      await cache();
      loginState.value = 2;
    } else {
      loginState.value = 0;
    }
  }

  Future<void> logout() async {}

  Future<void> regist(
    String agencyName_,
    String adminNickname_,
    String adminPhonenumber_,
    String adminPassword_,
    String adminAddress_,
  ) async {
    loginState.value = 1;
    var response = await http.post(
      Uri.parse('https://ur.healingai.top/api/register/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'agency_name': agencyName_,
        'admin_nickname': adminNickname_,
        'admin_phonenumber': adminPhonenumber_,
        'admin_password': adminPassword_,
        'admin_address': adminAddress_,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> user = responseData['user'];
      id.value = user['id'];
      agencyName.value = agencyName_;
      tokens.value = user['tokens'];
      registTimestamp.value = user["regist_timestamp"];
      lastLoginTimestamp.value = user["last_login_timestamp"];
      adminNickname.value = adminNickname_;
      adminPhonenumber.value = adminPhonenumber_;
      adminPassword.value = adminPassword_;
      adminAddress.value = adminAddress_;
      vip.value = user["vip"];
      await cache();
      loginState.value = 2;
    } else {
      loginState.value = 0;
    }
  }

  Future<void> updateAgencyName() async {}

  Future<void> updateAdminInfo() async {}

  Future<void> updateAdminPassword() async {}
}
