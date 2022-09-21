import 'package:get/get.dart';
import 'package:money_record/data/model/users.dart';

class UsersController extends GetxController {
  final _data = User().obs;
  User get data => _data.value;
  setData(totalData) => _data.value = totalData;
}
