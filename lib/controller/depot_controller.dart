import 'package:get/get.dart';
import 'package:healing_music/data/data.dart';

class DepotController extends GetxController {
  final User user = User();
  @override
  void onInit() async {
    super.onInit();
    user.init();
  }
}

class User {
  final RxInt id = 0.obs;
  final RxString agencyName = "".obs;
  final RxDouble tokens = 0.0.obs;
  final RxInt registTimestamp = 0.obs;
  final RxInt lastLoginTimestamp = 0.obs;
  final RxString adminNickname = "".obs;
  final RxString adminPhonenumber = "".obs;
  final RxString adminPassword = "".obs;
  final RxString adminAddress = "".obs;

  final RxBool isLogin = false.obs;

  User();

  Future<bool> init() async {
    Map<String, dynamic> user = await Data.read("assets/json/user.json");
    id.value = user["id"];
    agencyName.value = user["agency_name"];
    tokens.value = user["tokens"];
    registTimestamp.value = user["regist_timestamp"];
    lastLoginTimestamp.value = user["last_login_timestamp"];
    adminNickname.value = user["admin_nickname"];
    adminPhonenumber.value = user["admin_phonenumber"];
    adminPassword.value = user["admin_password"];
    adminAddress.value = user["admin_address"];
    if (id.value != 0) {
      isLogin.value = true;
    }
    return true;
  }

  bool login() {
    return true;
  }

  bool logout() {
    return true;
  }

  bool regist() {
    return true;
  }

  bool updateAgencyName() {
    return true;
  }
  bool updateAdminInfo() {
    return true;
  }
}
