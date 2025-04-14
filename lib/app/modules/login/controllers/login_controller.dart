import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_flutter/app/modules/dashboard/views/dashboard_view.dart';
import 'package:ujikom_flutter/app/utils/api.dart';
import 'package:ujikom_flutter/home_screen.dart';

class LoginController extends GetxController {
  final _getConnect = GetConnect();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authToken = GetStorage();

  //TODO: Implement LoginController


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  void loginNow() async { 
    final response = await _getConnect.post(BaseUrl.login, { 
      'email': emailController.text, 
      'password': passwordController.text,
    });

    if (response.statusCode == 200) { //struktur if-else untuk menentukan tindakan yang harus diambil berdasarkan respons yang diterima dari permintaan HTTP. Jika nilai kunci success dalam response.body adalah true, maka aplikasi menulis token akses yang diperoleh dari respons ke penyimpanan lokal menggunakan authToken.write().
      authToken.write('access_token', response.body['access_token']); //menyimpan token akses ke penyimpanan lokal dengan menggunakan authToken.write()
      Get.offAll(() => const DashboardView());
    } else { //Jika tidak, aplikasi menampilkan pesan kesalahan menggunakan Get.snackbar()
      Get.snackbar(
        'Error', //parameter pesan yang ditampilkan dalam snackbar
        response.body['error'].toString(), //mengambil pesan kesalahan dari nilai kunci message dalam response.body
        icon: const Icon(Icons.error), //ikon yang ditampilkan pada snackbar
        backgroundColor: Colors.red, //warna latar belakang snackbar
        colorText: Colors.white, //warna teks pada snackbar
        forwardAnimationCurve: Curves.bounceIn, //kurva animasi pada snackbar
        margin: const EdgeInsets.only( //mengatur margin pada snackbar
          top: 10,
          left: 5,
          right: 5,
        ),
      );
    }
  }


}
