import 'package:flutter/material.dart';

import 'package:get/get.dart';

class KategoriView extends GetView {
  const KategoriView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KategoriView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KategoriView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
