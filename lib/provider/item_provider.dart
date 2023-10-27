import 'package:flutter/material.dart';
import 'package:inventory_app/models/response_barang.dart';
import 'package:inventory_app/services/item_services.dart';

class ItemProvider extends ChangeNotifier {
  final ItemService _itemService = ItemService();

  var isFetching = false;
  List<Barang> listBarang = [];
  late ResponseBarang responseBarang;
  List<Barang> listSearchBarang = [];

  void search(String keywords) {
    List<Barang> listSearch = [];
    if (keywords.isEmpty) {
      listSearch.clear();
      listSearchBarang = listSearch;
    } else {
      for (var itemBarang in listBarang) {
        if (itemBarang.barangNama.toLowerCase().contains(keywords)) {
          listSearch.add(itemBarang);
        }
      }
      listSearchBarang = listSearch;
    }
    notifyListeners();
  }

  Future getListBarang() async {
    isFetching = true;
    notifyListeners();
    listBarang = await _itemService.getListBarang();
    isFetching = false;
    notifyListeners();
  }

  Future insertBarang(String name, String amount, String image) async {
    final response = await _itemService.insertBarang(name, amount, image);
    responseBarang = response;
    Barang itemBarang = Barang(
        barangId: response.lastId.toString(),
        barangNama: name,
        barangJumlah: amount,
        barangGambar: image);
    listBarang.add(itemBarang);
    notifyListeners();
  }

  Future deleteBarang(String id) async {
    final response = await _itemService.deleteBarang(id);
    responseBarang = response;
    listBarang.removeWhere((element) => element.barangId == id);
    notifyListeners();
  }

  Future updateBarang(
      String id, String name, String amount, String image) async {
    final response = await _itemService.updateBarang(id, name, amount, image);
    responseBarang = response;
    final index = listBarang.indexWhere((element) => element.barangId == id);
    Barang updateBarang = Barang(
        barangId: response.lastId.toString(),
        barangNama: name,
        barangJumlah: amount,
        barangGambar: image);
    listBarang[index] = updateBarang;
    notifyListeners();
  }

  ItemProvider() {
    getListBarang();
  }
}
