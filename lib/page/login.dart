import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/auth/loginmodel.dart';
import 'package:perisai_nusantara_app/page/components/roundedpasswordfield.dart';
import 'package:perisai_nusantara_app/page/home.dart';
import 'package:perisai_nusantara_app/page/settag.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/roundedinputfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

const _forgotPasswordUrl = 'https://172.15.1.21/login/forgotpassword';

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
      backgroundColor: const Color(0xFFE0E5EC),
      body: SafeArea(
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
                    color: const Color(0xFFE0E5EC),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.9),
                        offset: const Offset(-6, -6),
                        blurRadius: 16,
                      ),
                      BoxShadow(
                        color: const Color(0xFFA3B1C6).withOpacity(0.6),
                        offset: const Offset(6, 6),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.security,
                        color: Color(0xFF0D47A1),
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "PERISAI NUSANTARA",
                        style: TextStyle(
                          color: Color(0xFF37474F),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "GuardApp Login",
                        style: TextStyle(
                          color: Color(0xFF37474F).withOpacity(0.8),
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
                    color: const Color(0xFFE0E5EC),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.9),
                        offset: const Offset(-6, -6),
                        blurRadius: 16,
                      ),
                      BoxShadow(
                        color: const Color(0xFFA3B1C6).withOpacity(0.6),
                        offset: const Offset(6, 6),
                        blurRadius: 16,
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
                            // Dummy login logic
                            if (email.trim() == "admin@perisai.com" && password == "password123") {
                              // Create dummy UserAuth
                              userAuth = UserAuth(
                                nip: "12345",
                                name: "Admin User",
                                idSite: "1",
                                site: "Main Site",
                                idPosition: "1",
                                email: email,
                                password: password,
                                status: "active",
                              );
                              saveData();
                              Get.offAll(const Home());
                            } else {
                              Get.snackbar('Gagal', 'Email dan Password tidak sesuai');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
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
                          "Lupa Password?",
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
    );
  }
}
