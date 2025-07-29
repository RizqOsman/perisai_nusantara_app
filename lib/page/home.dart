import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/page/activity.dart';
import 'package:perisai_nusantara_app/page/bukupaket.dart';
import 'package:perisai_nusantara_app/page/bukutamu.dart';
import 'package:perisai_nusantara_app/page/components/customdialog.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:perisai_nusantara_app/page/emergencycontact.dart';
import 'package:perisai_nusantara_app/page/laporan.dart';
import 'package:perisai_nusantara_app/page/selectsession.dart';
import 'package:perisai_nusantara_app/page/components/api_status_dialog.dart';
import 'package:perisai_nusantara_app/page/components/modern_header.dart';
import 'package:perisai_nusantara_app/page/components/modern_menu_card.dart';
import 'package:perisai_nusantara_app/controller/utilities/theme/color.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.sessionMode = false}) : super(key: key);
  final bool sessionMode;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GetStorage session = GetStorage();
  late String tagId;
  late String isIn;
  late bool isDandru, sessionMode;

  void readAbsenNFC(String isCheckIn) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        tagId = tag.data['nfca']['identifier'].join();
        isIn = isCheckIn;
        NfcManager.instance.stopSession();
        postAttendace();
      });
      showDialog(
          context: context,
          builder: (context) => CustomDialogBox(
                title: 'Scanning ...',
                descriptions: 'Tempelkan pada Tag NFC',
                textButton: TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    NfcManager.instance.stopSession();
                    Get.back();
                  },
                ),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => CustomDialogBox(
                title: 'Ooops! ...',
                descriptions: "Pastikan fitur NFC aktif pada perangkat anda",
                textButton: TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ));
    }
  }

  Future postAttendace() async {
    final response = await http.post(Uri.parse('http://172.15.1.21:8000/attendance'),
        body: {'nik': session.read('nik'), 'tagid': tagId, 'checkin': isIn});
    if (response.statusCode == 200) {
      Get.back();
      Get.snackbar('Berhasil!', 'Absensi terunggah',
          backgroundColor: Colors.white);
    } else {
      Get.snackbar('Gagal', 'Silahkan hubungi developer',
          backgroundColor: Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
    isDandru = (session.read('idposition') != '2') ? false : true;
    sessionMode = widget.sessionMode;
    print(session.read('idposition'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor3,
      body: Column(
        children: [
          // Modern Header
          ModernHeader(
            title: "Selamat Datang",
            subtitle: "Perisai Nusantara GuardApp",
            userName: session.read('name') ?? 'User',
            userSite: session.read('site') ?? 'Site',
            onApiStatusTap: () {
              showDialog(
                context: context,
                builder: (context) => const ApiStatusDialog(),
              );
            },
            onSessionTap: sessionMode ? () => Get.to(() => const SelectSession()) : null,
            showSessionButton: sessionMode,
          ),
          // Menu Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Text(
                      "Menu Anggota",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  /* Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text(
                      "Absensi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Absensi(
                        size: size,
                        title: 'Check In',
                        onTap: () {
                          readAbsenNFC("1");
                        },
                      ),
                      Absensi(
                        size: size,
                        title: 'Check Out',
                        onTap: () {
                          readAbsenNFC("0");
                        },
                      ),
                    ],
                  ), */
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Text(
                          "Menu Anggota",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      /* Visibility(
                        visible: isDandru,
                        child: Row(
                          children: [
                            Text('Mode sesi: '),
                            Switch(
                                value: sessionMode,
                                onChanged: (value) {
                                  setState(() {
                                    sessionMode = value;
                                    print(widget.sessionMode);
                                    if (value) {
                                      session.write(
                                          "nip2", session.read('nip'));
                                      session.write(
                                          "name2", session.read('name'));
                                    } else {
                                      session.write(
                                          'nip', session.read('nip2'));
                                      session.write(
                                          'name', session.read('name2'));
                                    }
                                  });
                                }),
                          ],
                        ),
                      ) */
                    ],
                  ),
                  Expanded(
                    child: GridView.count(
                      primary: false,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      children: <Widget>[
                        ModernMenuCard(
                          icon: const FaIcon(FontAwesomeIcons.addressBook),
                          title: "Kontak Darurat",
                          subtitle: "Emergency Contacts",
                          gradient: primaryGradient,
                          onTap: () {
                            Get.to(() => const EmergencyContact());
                          },
                        ),
                        ModernMenuCard(
                          icon: const FaIcon(FontAwesomeIcons.book),
                          title: "Buku Tamu",
                          subtitle: "Guest Book",
                          gradient: secondaryGradient,
                          onTap: () {
                            Get.to(() => const BukuTamu());
                          },
                        ),
                        ModernMenuCard(
                          icon: const FaIcon(FontAwesomeIcons.bookJournalWhills),
                          title: "Buku Paket",
                          subtitle: "Package Book",
                          gradient: accentGradient,
                          onTap: () {
                            Get.to(() => const BukuPaket());
                          },
                        ),
                        ModernMenuCard(
                          icon: const FaIcon(FontAwesomeIcons.userPlus),
                          title: "Jumlah Pengunjung",
                          subtitle: "Visitor Count",
                          iconColor: infoColor,
                          backgroundColor: infoColor.withOpacity(0.1),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return const Activities();
                                });
                          },
                        ),
                        ModernMenuCard(
                          icon: const FaIcon(FontAwesomeIcons.infoCircle),
                          title: "Laporan",
                          subtitle: "Reports",
                          iconColor: warningColor,
                          backgroundColor: warningColor.withOpacity(0.1),
                          onTap: () {
                            Get.to(() => const Laporan());
                          },
                        ),
                        ModernMenuCard(
                          icon: const FaIcon(FontAwesomeIcons.speakerDeck),
                          title: "Atensi",
                          subtitle: "Attention",
                          iconColor: errorColor,
                          backgroundColor: errorColor.withOpacity(0.1),
                          onTap: () {
                            Get.to(() => null);
                          },
                        ),
                      ],
                    ),
                  ),
                  /* const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text(
                      "Menu Danru",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ), */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Absensi extends StatelessWidget {
  const Absensi(
      {Key? key, required this.size, required this.title, required this.onTap})
      : super(key: key);

  final Size size;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black87),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  final FaIcon icon;
  final String title;
  final Color bgColor;
  final void Function() onTap;
  const MainMenu({
    Key? key,
    required this.icon,
    required this.title,
    required this.bgColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
              child: icon,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            )
          ],
        ),
        // color: Colors.red[100],
      ),
    );
  }
}
