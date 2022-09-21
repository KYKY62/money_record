import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';

class CUpdateHistory extends GetxController {
  final _date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  String get date => _date.value;
  setDate(n) => _date.value = n;

  final _type = 'Pemasukan'.obs;
  String get type => _type.value;
  setType(n) => _type.value = n;

  final _items = [].obs;
  List get items => _items.value;
  addItem(n) {
    _items.value.add(n);
    count();
  }

  deleteItem(i) {
    _items.value.removeAt(i);
    count();
  }

  final _total = 0.0.obs;
  double get total => _total.value;

  count() {
    _total.value = items.map((e) => e['price']).toList().fold(0.0,
        (previousValue, element) {
      return double.parse(previousValue.toString()) + double.parse(element);
    });
    update();
  }

  init(idUser, date) async {
    History? history = await SourceHistory.whereDate(idUser, date);
    if (history != null) {
      setDate(history.date);
      setType(history.type);
      _items.value = jsonDecode(history.details!);
      count();
    }
  }
}
