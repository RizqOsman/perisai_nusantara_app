import 'package:flutter/material.dart';
import 'package:perisai_nusantara_app/page/components/dialogaddlaporan.dart';
import 'package:perisai_nusantara_app/page/components/dialoglaporandetail.dart';
import 'package:perisai_nusantara_app/services/laporanservice.dart';
import 'package:intl/intl.dart';
import 'package:perisai_nusantara_app/controller/utilities/theme/color.dart';
import 'package:perisai_nusantara_app/page/components/modern_button.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  _LaporanState createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  String laporanid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor3,
      appBar: AppBar(
        title: const Text(
          'Laporan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          ModernIconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const DialogAddLaporan(),
              );
            },
            icon: Icons.add,
            backgroundColor: Colors.white.withOpacity(0.2),
            iconColor: Colors.white,
            size: 40,
            tooltip: 'Tambah Laporan',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.1),
              bgColor3,
            ],
          ),
        ),
        child: FutureBuilder<List<LaporanModel>>(
          future: LaporanServices.getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('$snapshot.error');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: errorColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan!',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Silakan coba lagi',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return LaporanList(laporan: snapshot.data!);
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.assignment,
                        size: 48,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada laporan',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan laporan hari ini',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ModernButton(
                      text: 'Tambah Laporan',
                      icon: Icons.add,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      textColor: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const DialogAddLaporan(),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class LaporanList extends StatelessWidget {
  const LaporanList({Key? key, required this.laporan}) : super(key: key);
  final List<LaporanModel> laporan;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: laporan.length,
      itemBuilder: (context, index) {
        LaporanModel data = laporan[index];
        return GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (context) => DialogLaporanDetail(
              nama: data.nama,
              laporan: data.laporan,
              foto: '',
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: cardShadow.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: cardShadow.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        secondaryColor.withOpacity(0.1),
                        secondaryColor.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment,
                    color: secondaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.laporan,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: textSecondary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data.nama,
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            color: textSecondary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('HH:mm').format(data.tanggal),
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: textLight,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
