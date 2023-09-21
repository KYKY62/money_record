import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_assets.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/presentation/controller/home_controller.dart';
import 'package:money_record/presentation/controller/users_controller.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';
import 'package:money_record/presentation/page/history/add_history_page.dart';
import 'package:money_record/presentation/page/history/detail_history_page.dart';
import 'package:money_record/presentation/page/history/history_page.dart';
import 'package:money_record/presentation/page/history/income_outcome_page.dart';
import 'package:money_record/presentation/widget/listile_widget.dart';
import 'package:money_record/presentation/widget/home_title_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userController = Get.put(UsersController());
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    homeController.getAnalysis(userController.data.idUser!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppAsset.profile),
                        Expanded(
                          child: Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userController.data.name ?? '',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  userController.data.email ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                    Material(
                      color: AppColor.appPrimary,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          Session.clearUser();
                          Get.off(() => const LoginPage());
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: AppColor.appWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColor.appGrey,
              ),
              ListtileWidget(
                title: "Tambah Baru",
                ontap: () {
                  Get.to(() => AddHistoryPage())?.then((value) {
                    if (value ?? false) {
                      homeController.getAnalysis(userController.data.idUser!);
                    }
                  });
                },
                icon: const Icon(Icons.add),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColor.appGrey,
              ),
              ListtileWidget(
                title: "Pemasukan",
                ontap: () {
                  Get.to(() => const IncomeOutcomePage(
                        type: "Pemasukan",
                      ));
                },
                icon: const Icon(Icons.south_west),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColor.appGrey,
              ),
              ListtileWidget(
                title: "Pengeluaran",
                ontap: () {
                  Get.to(() => const IncomeOutcomePage(
                        type: "Pengeluaran",
                      ));
                },
                icon: const Icon(Icons.north_west),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColor.appGrey,
              ),
              ListtileWidget(
                title: "Riwayat",
                ontap: () {
                  Get.to(() => const HistoryPage(type: "Riwayat"));
                },
                icon: const Icon(Icons.history),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColor.appGrey,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
              child: Row(
                children: [
                  Image.asset(AppAsset.profile),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hi,",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Obx(
                          () => Text(
                            userController.data.name ?? '',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    return Material(
                      color: AppColor.appChart,
                      borderRadius: BorderRadius.circular(4),
                      child: InkWell(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.menu,
                            color: AppColor.appPrimary,
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  homeController.getAnalysis(userController.data.idUser!);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  children: [
                    const HomeTitleWidget(title: "Pengeluaran Hari ini"),
                    const SizedBox(height: 16),
                    Material(
                      color: AppColor.appPrimary,
                      borderRadius: BorderRadius.circular(16),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                            child: Obx(() {
                              return Text(
                                AppFormat.currency(
                                  homeController.today.toString(),
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.appSecondary),
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                            child: Obx(() {
                              return Text(
                                homeController.todayPercent,
                                style: const TextStyle(
                                  color: AppColor.appBackground,
                                  fontSize: 16,
                                ),
                              );
                            }),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => DetailHistory(
                                  idUser: userController.data.idUser!,
                                  date: DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  type: "Pengeluaran",
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                              decoration: const BoxDecoration(
                                color: AppColor.appWhite,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Selengkapnya",
                                    style: TextStyle(
                                      color: AppColor.appPrimary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.navigate_next,
                                    color: AppColor.appPrimary,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: 80,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColor.appBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const HomeTitleWidget(title: "Pengeluaran Minggu Ini"),
                    const SizedBox(height: 16),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Obx(() {
                        return DChartBar(
                          data: [
                            {
                              'id': 'Bar',
                              'data': List.generate(
                                7,
                                (index) {
                                  return {
                                    'domain': homeController.weekText()[index],
                                    'measure': homeController.week[index],
                                  };
                                },
                              ),
                            },
                          ],
                          domainLabelPaddingToAxisLine: 8,
                          axisLineTick: 2,
                          axisLineColor: AppColor.appPrimary,
                          measureLabelPaddingToAxisLine: 16,
                          barColor: (barData, index, id) => AppColor.appPrimary,
                          showBarValue: true,
                        );
                      }),
                    ),
                    const SizedBox(height: 25),
                    const HomeTitleWidget(title: "Perbandingan Bulan Ini"),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.5,
                          child: Stack(
                            children: [
                              Obx(() {
                                return DChartPie(
                                  data: [
                                    {
                                      'domain': 'income',
                                      'measure': homeController.monthIncome,
                                    },
                                    {
                                      'domain': 'outcome',
                                      'measure': homeController.monthOutcome
                                    },
                                    if (homeController.monthIncome == 0 &&
                                        homeController.monthOutcome == 0)
                                      {'domain': 'nol', 'measure': 1}
                                  ],
                                  fillColor: (pieData, index) {
                                    switch (pieData['domain']) {
                                      case 'income':
                                        return AppColor.appPrimary;
                                      case 'outcome':
                                        return AppColor.appChart;
                                      default:
                                        return AppColor.appBackground
                                            .withOpacity(0.5);
                                    }
                                  },
                                  donutWidth: 20,
                                  labelColor: Colors.white,
                                  showLabelLine: false,
                                );
                              }),
                              Center(
                                child: Obx(() {
                                  return Text(
                                    "${homeController.percentIncome}%",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          color: AppColor.appPrimary,
                                        ),
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: AppColor.appPrimary,
                                ),
                                const SizedBox(width: 8),
                                const Text("Pemasukan"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: AppColor.appChart,
                                ),
                                const SizedBox(width: 8),
                                const Text("Pengeluaran"),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Obx(() {
                              return Wrap(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(homeController.monthPercent),
                                  )
                                ],
                              );
                            }),
                            const SizedBox(height: 10),
                            const Text("Atau setara"),
                            Obx(() {
                              return Text(
                                AppFormat.currency(
                                    homeController.differentMonth.toString()),
                                style: const TextStyle(
                                  color: AppColor.appPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            })
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
