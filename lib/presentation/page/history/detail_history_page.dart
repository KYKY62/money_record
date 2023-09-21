import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/presentation/controller/c_detail_history.dart';

class DetailHistory extends StatefulWidget {
  const DetailHistory({
    Key? key,
    required this.idUser,
    required this.date,
    required this.type,
  }) : super(key: key);
  final String idUser;
  final String date;
  final String type;

  @override
  State<DetailHistory> createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistory> {
  final cDetailHistory = Get.put(CDetailHistory());

  @override
  void initState() {
    cDetailHistory.getData(
      widget.idUser,
      widget.date,
      widget.type,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appPrimary,
        titleSpacing: 0,
        title: Obx(() {
          if (cDetailHistory.data.date == null) {
            return const SizedBox();
          }
          return Row(
            children: [
              Expanded(
                child: Text(
                  AppFormat.date(cDetailHistory.data.date!),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: cDetailHistory.data.type == "Pemasukan"
                    ? Icon(
                        Icons.south_west,
                        color: Colors.green[300],
                      )
                    : const Icon(
                        Icons.north_east,
                        color: Colors.red,
                      ),
              )
            ],
          );
        }),
      ),
      body: GetBuilder<CDetailHistory>(builder: (ctx) {
        if (ctx.data.details == null) {
          String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          if (widget.date == today && widget.type == 'Pengeluaran') {
            return const Center(
              child: Text("Belum Ada Pengeluaran Hari Ini"),
            );
          }
          return const SizedBox();
        }
        List details = jsonDecode(ctx.data.details!);
        return Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total",
                style: TextStyle(
                    color: AppColor.appPrimary.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                AppFormat.currency(ctx.data.total!),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColor.appPrimary,
                    ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColor.appBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    Map items = details[index];
                    return Row(
                      children: [
                        Text('${index + 1}.'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(items['name']),
                        ),
                        Text(
                          AppFormat.currency(items['price']),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
