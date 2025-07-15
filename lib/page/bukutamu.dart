import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:perisai_nusantara_app/page/components/roundedinputdate.dart';
import 'package:perisai_nusantara_app/page/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/components/roundedbutton.dart';
import 'package:perisai_nusantara_app/page/components/roundedinputfield.dart';
import 'package:image_picker/image_picker.dart';

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
    var url = Uri.parse('http://192.168.1.12:5000/daftar-tamu');

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
      var url = Uri.parse('http://192.168.1.12:5000/daftar-tamu');
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
      appBar: AppBar(
        title: const Text('Buku Tamu'),
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'No.Visitor',
                        onChanged: (novisitor) {
                          _noVisitor = novisitor;
                        },
                        icon: FontAwesomeIcons.calendar,
                      ),
                      RoundedInputDate(
                        hintText: 'Tanggal', 
                        dateFormat: DateFormat('yyyy-MM-dd'), 
                        initialDate: DateTime.now(), 
                        firstDate: DateTime(2015, 8), 
                        lastDate: DateTime(2101), 
                        width: size.width * 0.9, 
                        onDateChanged: (tanggalvalue) { 
                          _tanggal = tanggalvalue as DateTime;
                         },),
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Nama Tamu',
                        onChanged: (namaTamu) {
                          _namaTamu = namaTamu;
                        },
                        icon: FontAwesomeIcons.person,
                      ),
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Alamat/Rumah Tujuan',
                        onChanged: (alamat) {
                          _alamat = alamat;
                        },
                        icon: FontAwesomeIcons.locationDot,
                      ),
                      RoundedInputField(
                          width: size.width * 0.9,
                          icon: FontAwesomeIcons.noteSticky,
                          hintText: 'Keperluan',
                          onChanged: (keperluan) {
                            _keperluan = keperluan;
                          }),
                      RoundedInputField(
                        width: size.width * 0.9,
                        icon: FontAwesomeIcons.phone,
                        onChanged: (telepon) {
                          _telepon = telepon;
                        },
                        hintText: 'Telepon',
                      ),
                      _foto == null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Upload Identitas ?',
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            getImage(ImageSource.camera);
                                          },
                                          icon: const FaIcon(
                                            FontAwesomeIcons.camera,
                                            color: Colors.red,
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "|",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                          },
                                          icon: const FaIcon(
                                            FontAwesomeIcons.image,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  _foto = null;
                                });
                              },
                              child: Image.file(
                                _foto!,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                errorBuilder: (context, error, stactTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    width: 100,
                                    height: 100,
                                    child: const Center(
                                      child: Text('Error load image',
                                          textAlign: TextAlign.center),
                                    ),
                                  );
                                },
                              ),
                            ),
                      RoundedButton(
                          text: 'Kirim',
                          color: Colors.red.shade800,
                          press: () async {
                            var response = await upload();
                            print(response);
                            if (!isLoading && isSuccess) {
                              print(_noVisitor);
                              print(_namaTamu);
                              print(_telepon);
                              print(_alamat);
                              print(_keperluan);
                              print(_foto);
                              Get.snackbar('Berhasil!', 'Tamu Check-In.',
                                  backgroundColor: Colors.white);
                              //return Get.back();
                            } else {
                              //Get.back();
                              Get.snackbar(
                                  'Gagal', 'Tambahkan foto terlebih dahulu!',
                                  backgroundColor: Colors.white);
                            }
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: () {
                Get.back();
              },
              child: FaIcon(FontAwesomeIcons.arrowLeft),
            ),
          )
        ],
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
