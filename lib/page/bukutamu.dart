import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:perisai_nusantara_app/controller/utilities/theme/color.dart';
import 'package:perisai_nusantara_app/page/components/modern_input_field.dart';
import 'package:perisai_nusantara_app/page/components/modern_button.dart';

class BukuTamu extends StatefulWidget {
  const BukuTamu({Key? key}) : super(key: key);

  @override
  _BukuTamuState createState() => _BukuTamuState();
}

class _BukuTamuState extends State<BukuTamu> {
  File? _foto;
  ImagePicker fotoPicker = ImagePicker();
  String idbukuTamu = 'id_bukutamu';
  String _noVisitor = 'no_visitor';
  late DateTime _tanggal;
  late String _namaTamu;
  late String _telepon;
  late String _alamat;
  late String _keperluan;
  late bool isSuccess = false;
  late bool isLoading = false;

  getPermission() async {
    var cameraPermission = await Permission.camera.status;
    if (!cameraPermission.isGranted) {
      await Permission.camera.request();
    }
  }

  Future getImage(ImageSource fotoSource) async {
    var fotoFile = await fotoPicker.pickImage(source: fotoSource);
    try {
      setState(() {
        _foto = File(fotoFile!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future upload() async {
    var url = Uri.parse('http://172.15.1.21:8000/daftar-tamu');

    List<int> imageBytes = _foto!.readAsBytesSync();
    isLoading = true;
    String base64Image = base64Encode(imageBytes);
    var response = await http.post(url, body: {
      'no_visitor': _noVisitor,
      'tanggal':_tanggal,
      'nama': _namaTamu,
      'telepon': _telepon,
      'alamat': _alamat,
      'keperluan': _keperluan,
      'foto': base64Image,
      'filename': _foto!.path,
    });
    if (response.statusCode == 200) {
      isSuccess = true;
    }
    isLoading = false;
    print(response);
  }

/*   Future postUpload() async {
    try {
      var stream = new http.ByteStream(_foto!.openRead());
      stream.cast();
      var length = await _foto!.length();
      //Uri.parse = Mengikuti IP Address dari bawaan device || ipv4 used
      var url = Uri.parse('http://172.15.1.21:8000/daftar-tamu');
      var request = new http.MultipartRequest("POST", url);
      late File imageFile = File(_foto!.path);
      var multipartFile = new http.MultipartFile(
        "file",
        stream,
        length,
        filename: 'x.jpg',
      );

      request.files
          .add(await http.MultipartFile.fromPath('foto', imageFile.path));
      // request.files.add(
      //     new http.MultipartFile.fromBytes('foto', _foto!.readAsBytesSync()));
      request.fields['id_bukutamu'] = idbukuTamu;
      request.fields['no_visitor'] = _noVisitor;
      request.fields['nama'] = _namaTamu;
      request.fields['telepon'] = _telepon;
      request.fields['alamat'] = _alamat;
      request.fields['keperluan'] = _keperluan;
      request.fields['foto'] = _foto.toString();

      var response = await request.send();
      // if (response.statusCode == 200) {
      //   debugPrint('$response SUCCESS');
      // } else {
      //   debugPrint('bangke $response.statusCode');
      //   debugPrint('$response IMAGE FAILED, $str');
      // }
      response.stream.transform(utf8.decoder).listen((event) {
        debugPrint(' ini ni $event');
      });
    } catch (e) {
      debugPrint('babi $e');
    }
  } */

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor3,
      appBar: AppBar(
        title: const Text(
          'Buku Tamu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Daftar Tamu Check-In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Isi data tamu yang akan berkunjung",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Form Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadow.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      // Form Title
                      Text(
                        'Data Tamu',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // No. Visitor
                      ModernInputField(
                        hintText: 'No. Visitor',
                        icon: Icons.confirmation_number,
                        onChanged: (novisitor) {
                          _noVisitor = novisitor;
                        },
                      ),
                      
                      // Date Field
                      ModernDateField(
                        hintText: 'Pilih Tanggal',
                        selectedDate: _tanggal,
                        onDateSelected: (tanggalvalue) {
                          _tanggal = tanggalvalue;
                        },
                        icon: Icons.calendar_today,
                      ),
                      
                      // Nama Tamu
                      ModernInputField(
                        hintText: 'Nama Tamu',
                        icon: Icons.person,
                        onChanged: (namaTamu) {
                          _namaTamu = namaTamu;
                        },
                      ),
                      
                      // Alamat
                      ModernInputField(
                        hintText: 'Alamat/Rumah Tujuan',
                        icon: Icons.location_on,
                        isMultiline: true,
                        maxLines: 3,
                        onChanged: (alamat) {
                          _alamat = alamat;
                        },
                      ),
                      
                      // Keperluan
                      ModernInputField(
                        hintText: 'Keperluan',
                        icon: Icons.note,
                        isMultiline: true,
                        maxLines: 2,
                        onChanged: (keperluan) {
                          _keperluan = keperluan;
                        },
                      ),
                      
                      // Telepon
                      ModernInputField(
                        hintText: 'Nomor Telepon',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        onChanged: (telepon) {
                          _telepon = telepon;
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Image Picker
                      ModernImagePicker(
                        title: 'Foto Identitas',
                        imageFile: _foto,
                        onCameraTap: () {
                          getImage(ImageSource.camera);
                        },
                        onGalleryTap: () {
                          getImage(ImageSource.gallery);
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Submit Button
                      ModernButton(
                        text: 'Kirim Data Tamu',
                        icon: Icons.send,
                        isLoading: isLoading,
                        gradient: primaryGradient,
                        onPressed: () async {
                          if (_foto == null) {
                            Get.snackbar(
                              'Peringatan',
                              'Tambahkan foto identitas terlebih dahulu!',
                              backgroundColor: errorColor.withOpacity(0.1),
                              colorText: errorColor,
                            );
                            return;
                          }
                          
                          var response = await upload();
                          print(response);
                          if (!isLoading && isSuccess) {
                            Get.snackbar(
                              'Berhasil!',
                              'Data tamu berhasil disimpan.',
                              backgroundColor: successColor.withOpacity(0.1),
                              colorText: successColor,
                            );
                            // Reset form
                            setState(() {
                              _foto = null;
                              _noVisitor = '';
                              _namaTamu = '';
                              _telepon = '';
                              _alamat = '';
                              _keperluan = '';
                            });
                          } else {
                            Get.snackbar(
                              'Gagal',
                              'Terjadi kesalahan saat menyimpan data.',
                              backgroundColor: errorColor.withOpacity(0.1),
                              colorText: errorColor,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class BigTextField extends StatelessWidget {
  const BigTextField({Key? key, required this.hint, required this.onChanged})
      : super(key: key);
  final String hint;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
          onChanged: onChanged,
          autocorrect: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration.collapsed(
            hintText: hint,
          )),
    );
  }
}
