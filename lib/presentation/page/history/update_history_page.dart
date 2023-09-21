import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentation/controller/c_update_history.dart';
import 'package:money_record/presentation/controller/users_controller.dart';
import 'package:money_record/presentation/widget/drawer_title_widget.dart';

class UpdateHistoryPage extends StatefulWidget {
  const UpdateHistoryPage({
    Key? key,
    required this.date,
    required this.idHistory,
  }) : super(key: key);

  final String date;
  final String idHistory;

  @override
  State<UpdateHistoryPage> createState() => _UpdateHistoryPageState();
}

class _UpdateHistoryPageState extends State<UpdateHistoryPage> {
  final cUpdateHistory = Get.put(CUpdateHistory());

  final cUser = Get.put(UsersController());

  final controllerPrice = TextEditingController();

  final controllerSumber = TextEditingController();

  updateHistory() async {
    bool success = await SourceHistory.update(
      widget.idHistory,
      cUser.data.idUser!,
      cUpdateHistory.date,
      cUpdateHistory.type,
      jsonEncode(cUpdateHistory.items),
      cUpdateHistory.total.toString(),
    );
    if (success) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        Get.back(result: true);
      });
    }
  }

  @override
  void initState() {
    cUpdateHistory.init(cUser.data.idUser, widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appPrimary,
        title: const Text(
          "Update",
        ),
        titleSpacing: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Tanggal"),
          Row(
            children: [
              Obx(() {
                return Text(cUpdateHistory.date);
              }),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  DateTime? result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022, 01, 01),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (result != null) {
                    cUpdateHistory
                        .setDate(DateFormat('yyyy-MM-dd').format(result));
                  }
                },
                icon: const Icon(Icons.event),
                label: const Text("Pilih"),
              )
            ],
          ),
          const SizedBox(height: 16),
          const DrawerTitleWidget(title: "Tipe"),
          const SizedBox(height: 8),
          Obx(() {
            return DropdownButtonFormField(
              value: cUpdateHistory.type,
              items: ['Pemasukan', 'Pengeluaran']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                cUpdateHistory.setType(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            );
          }),
          const SizedBox(height: 16),
          const DrawerTitleWidget(title: "Sumber/Objek Pengeluaran"),
          const SizedBox(height: 8),
          TextFormField(
            controller: controllerSumber,
            textInputAction: TextInputAction.next,
            validator: (value) => value == '' ? "Data harus diisi" : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          const DrawerTitleWidget(title: "Harga"),
          const SizedBox(height: 8),
          TextFormField(
            controller: controllerPrice,
            textInputAction: TextInputAction.next,
            validator: (value) => value == '' ? "Data harus diisi" : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              cUpdateHistory.addItem({
                'name': controllerSumber.text,
                'price': controllerPrice.text,
              });
              controllerSumber.clear();
              controllerPrice.clear();
            },
            child: const Text("Tambah Item"),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                color: AppColor.appBackground,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const DrawerTitleWidget(title: "Items"),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(),
            ),
            child: GetBuilder<CUpdateHistory>(builder: (_) {
              return Wrap(
                runSpacing: 0,
                spacing: 8,
                children: List.generate(_.items.length, (index) {
                  return Chip(
                    label: Text(_.items[index]['name']),
                    deleteIcon: const Icon(Icons.clear),
                    onDeleted: () => _.deleteItem(index),
                  );
                }),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Total:"),
              const SizedBox(width: 10),
              Obx(() {
                return Text(
                  AppFormat.currency("${cUpdateHistory.total}"),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColor.appPrimary,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                );
              }),
            ],
          ),
          const SizedBox(height: 20),
          Material(
            color: AppColor.appPrimary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                updateHistory();
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    "Submit",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColor.appWhite,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
