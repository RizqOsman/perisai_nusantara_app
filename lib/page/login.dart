import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/auth/loginmodel.dart';
import 'package:perisai_nusantara_app/page/components/roundedpasswordfield.dart';
import 'package:perisai_nusantara_app/page/home.dart';
import 'package:perisai_nusantara_app/page/settag.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:perisai_nusantara_app/controller/utilities/theme/color.dart';

import 'components/roundedinputfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

const _forgotPasswordUrl = 'https://hris.tpm-facility.com/login/forgotpassword';

class _LoginState extends State<Login> {
  late UserAuth userAuth;
  late String email, password;
  bool invisiblePw = true;
  final getStorage = GetStorage();

  void saveData() async {
    getStorage.write("nip", userAuth.nip);
    getStorage.write("idsite", userAuth.idSite);
    getStorage.write("site", userAuth.site);
    getStorage.write("idposition", userAuth.idPosition);
    getStorage.write("email", userAuth.email);
    getStorage.write("name", userAuth.name);
    getStorage.write("status", userAuth.status);
  }

  void _launchURL() async => await canLaunch(_forgotPasswordUrl)
      ? await launch(_forgotPasswordUrl)
      : throw 'Could not launch $_forgotPasswordUrl';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/App Name
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.security,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "PERISAI NUSANTARA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "GuardApp Login",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.06),
                  // Login Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        RoundedInputField(
                          icon: Icons.person,
                          hintText: "Email Kamu",
                          onChanged: (evalue) {
                            email = evalue;
                          },
                        ),
                        const SizedBox(height: 16),
                        RoundedPasswordField(
                          onEyeTap: () {
                            setState(() {
                              invisiblePw = !invisiblePw;
                            });
                          },
                          invisible: invisiblePw,
                          onChanged: (pvalue) {
                            password = pvalue;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              AuthService.fetchData(email.trim(), password).then((value) {
                                if (value != null) {
                                  userAuth = value;
                                  saveData();
                                  Get.offAll(const Home());
                                } else {
                                  print("Tidak Terdaftar");
                                  Get.snackbar('Gagal', 'Email dan Password tidak sesuai');
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "MASUK",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            _launchURL();
                          },
                          onLongPress: () {
                            Get.to(() => SetTag());
                          },
                          child: Text(
                            "",
                            style: TextStyle(color: Colors.red.shade500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
