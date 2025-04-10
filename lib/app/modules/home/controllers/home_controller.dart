import 'dart:async';

import 'package:get/get.dart';
import 'package:ujikom_flutter/app/modules/login/views/login_view.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  late Timer _pindah;

  @override
  void onInit() {
    super.onInit();
    _pindah = Timer.periodic(
  const Duration(seconds: 4),
  (timer) => Get.off(
    () => const LoginView(),
    transition: Transition.leftToRight,
  ),
);

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _pindah.cancel();
  }

}
