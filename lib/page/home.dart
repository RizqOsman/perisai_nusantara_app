import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/page/activity.dart';
import 'package:perisai_nusantara_app/page/bukupaket.dart';
import 'package:perisai_nusantara_app/page/bukutamu.dart';
import 'package:perisai_nusantara_app/page/components/customdialog.dart';
import 'package:http/http.dart' as http;
import 'package:perisai_nusantara_app/page/emergencycontact.dart';
import 'package:perisai_nusantara_app/page/laporan.dart';

// NFC package not available in this project — provide a minimal stub to avoid compile errors.
// When you want real NFC support, add `nfc_manager` to pubspec.yaml and restore the original import.
//
// import 'package:nfc_manager/nfc_manager.dart';

class NfcManager {
  NfcManager._();
  static final NfcManager instance = NfcManager._();

  /// Returns `false` by default in this stub (no NFC hardware access).
  Future<bool> isAvailable() async => false;

  /// Stub: does nothing. The real implementation invokes [onDiscovered] when an NFC tag is found.
  void startSession({required Function(NfcTag) onDiscovered, Set<NfcPollingOption>? pollingOptions}) {}

  /// Stub: does nothing.
  void stopSession() {}
}

enum NfcPollingOption { iso14443 }

class NfcTag {
  final Map<String, dynamic> data;
  NfcTag(this.data);
}

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
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var nfcData = tag.data;
          tagId = (nfcData['nfca'] as Map<String, dynamic>)['identifier'].join();
          isIn = isCheckIn;
          NfcManager.instance.stopSession();
          postAttendace();
        },
        pollingOptions: {NfcPollingOption.iso14443},
      );
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
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE0E5EC),
        title: const Text(
          'Perisai Nusantara',
          style: TextStyle(
            color: Color(0xFF37474F),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF37474F)),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            NeumorphicMenuCard(
              icon: Icons.fingerprint,
              title: 'Absensi',
              onTap: () {
                readAbsenNFC("1"); // Assuming check-in for simplicity; adjust as needed
              },
            ),
            NeumorphicMenuCard(
              icon: Icons.tour,
              title: 'Tur Patroli',
              onTap: () {
                // Navigate to Tur Patroli page (placeholder)
                Get.snackbar('Info', 'Fitur Tur Patroli akan segera hadir');
              },
            ),
            NeumorphicMenuCard(
              icon: Icons.people_alt,
              title: 'Buku Tamu',
              onTap: () {
                Get.to(() => const BukuTamu());
              },
            ),
            NeumorphicMenuCard(
              icon: Icons.inventory_2,
              title: 'Buku Paket',
              onTap: () {
                Get.to(() => const BukuPaket());
              },
            ),
            NeumorphicMenuCard(
              icon: Icons.assignment_late,
              title: 'Manajemen Insiden',
              onTap: () {
                Get.to(() => const Laporan()); // Using existing Laporan page as placeholder
              },
            ),
            NeumorphicMenuCard(
              icon: Icons.analytics,
              title: 'Aktivitas',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (builder) => const Activities(),
                );
              },
            ),
            NeumorphicMenuCard(
              icon: Icons.contact_phone,
              title: 'Kontak Darurat',
              onTap: () {
                Get.to(() => const EmergencyContact());
              },
            ),
            NeumorphicMenuCard(
              icon: Icons.book,
              title: 'Logbook Penjaga',
              onTap: () {
                // Navigate to Logbook page (placeholder)
                Get.snackbar('Info', 'Fitur Logbook Penjaga akan segera hadir');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        elevation: 8.0,
        tooltip: 'Tombol Darurat (SOS)',
        child: const Icon(Icons.sos, size: 30),
        onPressed: () {
          // Handle panic button press
          Get.snackbar('Darurat!', 'Tombol darurat diaktifkan', backgroundColor: Colors.red, colorText: Colors.white);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class NeumorphicMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const NeumorphicMenuCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: const Color(0xFF0D47A1),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF37474F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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

