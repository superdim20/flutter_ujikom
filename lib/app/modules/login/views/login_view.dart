import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:ujikom_flutter/app/modules/register/views/register_view.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance controller
    LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: HexColor('#feeee8'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Animasi Lottie
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Lottie.network(
                'https://gist.githubusercontent.com/olipiskandar/2095343e6b34255dcfb042166c4a3283/raw/d76e1121a2124640481edcf6e7712130304d6236/praujikom_kucing.json',
                fit: BoxFit.cover,
              ),
            ),
            
            // Input Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Masukkan Email',
                ),
              ),
            ),
            
            // Input Password
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 15,
                bottom: 0,
              ),
              child: TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Masukkan Password',
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // Tombol Login
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  // Pastikan loginNow() bisa dipanggil saat tombol di klik
                  if (controller.emailController.text.isNotEmpty && controller.passwordController.text.isNotEmpty) {
                    controller.loginNow();
                  } else {
                    // Jika ada input kosong
                    Get.snackbar(
                      'Error',
                      'Email dan Password tidak boleh kosong!',
                      icon: const Icon(Icons.error),
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // Tombol Register
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  // Navigasi ke halaman register
                  Get.to(() => RegisterView());
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
