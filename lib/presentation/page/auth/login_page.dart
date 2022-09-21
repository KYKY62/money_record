import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record/config/app_assets.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/data/source/source_user.dart';
import 'package:money_record/presentation/page/auth/home_page.dart';
import 'package:money_record/presentation/page/auth/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerEmail = TextEditingController();
    final controllerPassword = TextEditingController();
    final formKey = GlobalKey<FormState>();
    void login() async {
      if (formKey.currentState!.validate()) {
        bool success = await SourceUser.login(
          controllerEmail.text,
          controllerPassword.text,
        );

        if (success) {
          DInfo.dialogSuccess('Berhasil Login');
          DInfo.closeDialog(
            actionAfterClose: () => Get.off(() => const HomePage()),
          );
        } else {
          DInfo.dialogError('Gagal Login');
          DInfo.closeDialog();
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.nothing(),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Image.asset(AppAsset.logo),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: controllerEmail,
                            validator: (value) =>
                                value == '' ? "Data tidak boleh kosong" : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(color: AppColor.appWhite),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle:
                                  const TextStyle(color: AppColor.appWhite),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              isDense: true,
                              fillColor: AppColor.appPrimary.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controllerPassword,
                            validator: (value) =>
                                value == '' ? "Data tidak boleh kosong" : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(color: AppColor.appWhite),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle:
                                  const TextStyle(color: AppColor.appWhite),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              isDense: true,
                              fillColor: AppColor.appPrimary.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material(
                            color: AppColor.appPrimary,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () => login(),
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 16),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Belum Punya Akun? ",
                          style: TextStyle(
                            color: AppColor.appWhite,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => const RegisterPage()),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: AppColor.appPrimary,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
