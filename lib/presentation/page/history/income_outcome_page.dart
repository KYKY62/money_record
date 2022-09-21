// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentation/controller/c_history.dart';
import 'package:money_record/presentation/controller/c_income_outcome.dart';
import 'package:money_record/presentation/controller/users_controller.dart';
import 'package:money_record/presentation/page/history/detail_history_page.dart';
import 'package:money_record/presentation/page/history/update_history_page.dart';

class IncomeOutcomePage extends StatefulWidget {
  const IncomeOutcomePage({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  State<IncomeOutcomePage> createState() => _IncomeOutcomePageState();
}

class _IncomeOutcomePageState extends State<IncomeOutcomePage> {
  final cIncomeOutcome = Get.put(CIncomeOutcome());
  final cHistory = Get.put(CHistory());
  final cUser = Get.put(UsersController());
  TextEditingController controllerSearch = TextEditingController();

  refresh() {
    cIncomeOutcome.getList(cUser.data.idUser, widget.type);
  }

  showMenuOption(String value, History history) async {
    if (value == "update") {
      Get.to(() => UpdateHistoryPage(
            date: history.date!,
            idHistory: history.idHistory!,
          ))?.then((value) {
        if (value ?? false) {
          refresh();
        }
      });
    } else if (value == "delete") {
      bool? yes = await DInfo.dialogConfirmation(
        context,
        'Hapus',
        'Yakin untuk menghapus history ini?',
        textNo: 'Batal',
        textYes: 'Ya',
      );
      if (yes!) {
        bool success = await SourceHistory.delete(history.idHistory!);
        if (success) refresh();
      }
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: AppColor.appPrimary,
        title: Row(
          children: [
            Text(widget.type),
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(16),
                child: TextField(
                  controller: controllerSearch,
                  onTap: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (result != null) {
                      controllerSearch.text =
                          DateFormat("yyyy-MM-dd").format(result);
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      hintText: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      hintStyle: const TextStyle(color: Colors.white),
                      fillColor: AppColor.appChart.withOpacity(0.5),
                      suffixIcon: IconButton(
                        onPressed: () {
                          cIncomeOutcome.search(
                            cUser.data.idUser,
                            widget.type,
                            controllerSearch.text,
                          );
                        },
                        icon: const Icon(Icons.search),
                        color: Colors.white,
                      )),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<CIncomeOutcome>(builder: (ctx) {
        if (ctx.loading) return DView.loadingCircle();
        if (ctx.list.isEmpty) {
          return const SizedBox(child: Center(child: Text("Data Kosong")));
        }

        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
            itemCount: ctx.list.length,
            itemBuilder: (context, index) {
              History history = ctx.list[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.fromLTRB(
                  16,
                  index == 0 ? 16 : 8,
                  16,
                  index == ctx.list.length ? 16 : 8,
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => DetailHistory(
                        idUser: cUser.data.idUser!,
                        date: history.date!,
                        type: history.type!,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          AppFormat.date(history.date!),
                          style: const TextStyle(
                              color: AppColor.appPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Expanded(
                          child: Text(
                            AppFormat.currency(history.total!),
                            style: const TextStyle(
                              color: AppColor.appPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) => showMenuOption(value, history),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "update",
                              child: Text("Update"),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
