import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_flutter/app/data/kategori_response.dart';
import 'package:ujikom_flutter/app/modules/dashboard/views/index_view.dart';
import 'package:ujikom_flutter/app/modules/dashboard/views/kategori_view.dart';
import 'package:ujikom_flutter/app/modules/dashboard/views/profile_view.dart';
import 'package:ujikom_flutter/app/utils/api.dart';


class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  final _getConnect = GetConnect();

  final token = GetStorage().read('access_token');

  var kategoriList;

Future<KategoriResponse> getEvent() async {
  final response = await _getConnect.get(
    BaseUrl.kategori,
    headers: {'Authorization': "Bearer $token"},
    contentType: "application/json",
  );
  return KategoriResponse.fromJson(response.body);
}
var Kategori = <KategoriResponse>[].obs;

Future<void> getKategori() async {
  final response = await _getConnect.get(
    BaseUrl.kategori,
    headers: {'Authorization': "Bearer $token"},
    contentType: "application/json",
  );
  final kategoriResponse = KategoriResponse.fromJson(response.body);
  Kategori.value = kategoriResponse.data ??[];
}

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    KategoriView(),
    ProfileView(),
  ];

  
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
    super.onClose();
  }
}
