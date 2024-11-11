import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendece extends StatefulWidget {
  final Map<String, dynamic>? attendance;
  final String? id;

  const Attendece({super.key, this.attendance, this.id});

  @override
  State<Attendece> createState() => _AttendeceState();
}

class _AttendeceState extends State<Attendece> {
  final MapController mapController = MapController();
  final TextEditingController _deskripsiPekerjaanController =
      TextEditingController();

  final List<String> _pekerjaan = [
    "mengajar",
    "penelitian",
    "pengabdian",
  ];
  int _selectedPekerjaan = 2;
  bool _isLaptop = false;
  bool _isKomputer = false;
  bool _isHP = false;

  String _suasanaHati = "senang";
  File? image;

  double? _latitude;
  double? _longitude;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _deskripsiPekerjaanController.text =
          prefs.getString('work_description') ?? '';
      _selectedPekerjaan = prefs.getInt('work') ?? 0;
      _isLaptop = prefs.getBool('is_laptop') ?? false;
      _isKomputer = prefs.getBool('is_komputer') ?? false;
      _isHP = prefs.getBool('is_hp') ?? false;
      _suasanaHati = prefs.getString('mood') ?? 'senang';
      _latitude = prefs.getDouble('lat');
      _longitude = prefs.getDouble('long');
    });
  }

  bool _isFormValid() {
    final isDeskripsiPekerjaanValid =
        _deskripsiPekerjaanController.text.isNotEmpty;
    final isAlatKerjaSelected = _isLaptop || _isKomputer || _isHP;
    final isImageSelected = image != null;
    final isLocationValid = _latitude != null && _longitude != null;
    return isDeskripsiPekerjaanValid &&
        isAlatKerjaSelected &&
        isImageSelected &&
        isLocationValid;
  }

  void _submitForm() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'work_description', _deskripsiPekerjaanController.text);
      await prefs.setInt('work', _selectedPekerjaan);
      await prefs.setBool('is_laptop', _isLaptop);
      await prefs.setBool('is_komputer', _isKomputer);
      await prefs.setBool('is_hp', _isHP);
      await prefs.setString('mood', _suasanaHati);
      await prefs.setDouble('lat', _latitude!);
      await prefs.setDouble('long', _longitude!);

      Navigator.of(context).pop();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _deskripsiPekerjaanController,
              decoration:
                  const InputDecoration(labelText: 'deskripsi pekerjaan'),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'pekerjaan'),
              value: _selectedPekerjaan,
              items: [
                for (final (i, pekerjaan) in _pekerjaan.indexed)
                  DropdownMenuItem(
                    value: i,
                    child: Text(pekerjaan),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPekerjaan = value as int;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text("Alat kerja"),
            const SizedBox(height: 8),
            Column(
              children: [
                CheckboxListTile(
                  title: const Text("laptop"),
                  value: _isLaptop,
                  onChanged: (value) {
                    setState(() {
                      _isLaptop = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("HP"),
                  value: _isHP,
                  onChanged: (value) {
                    setState(() {
                      _isHP = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Komputer"),
                  value: _isKomputer,
                  onChanged: (value) {
                    setState(() {
                      _isKomputer = value ?? false;
                    });
                  },
                )
              ],
            ),
            const Text("Suasana hati"),
            const SizedBox(height: 5),
            Column(
              children: [
                RadioListTile(
                  title: const Text("senang"),
                  value: "senang",
                  groupValue: _suasanaHati,
                  onChanged: (val) {
                    setState(() {
                      _suasanaHati = val!;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("sedih"),
                  value: "sedih",
                  groupValue: _suasanaHati,
                  onChanged: (val) {
                    setState(() {
                      _suasanaHati = val!;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("bahagia"),
                  value: "bahagia",
                  groupValue: _suasanaHati,
                  onChanged: (val) {
                    setState(() {
                      _suasanaHati = val!;
                    });
                  },
                )
              ],
            ),
            FilledButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final result = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (result != null) {
                  setState(() {
                    image = File(result.path);
                  });
                } else {
                  print("No image selected");
                }
              },
              style: FilledButton.styleFrom(minimumSize: Size.fromHeight(56)),
              child: const Text('ambil selfie'),
            ),
            const SizedBox(height: 24),
            if (image != null)
              if (kIsWeb) Image.network(image!.path) else Image.file(image!),
            const SizedBox(height: 24),
            if (_latitude != null && _longitude != null)
              Text(
                  "lokasi: ${_latitude!.toString()}, ${_longitude!.toString()}"),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                final Position position = await _determinePosition();

                setState(() {
                  _latitude = position.latitude;
                  _longitude = position.longitude;
                  _isLoading = false;
                });

                mapController.move(
                  LatLng(position.latitude, position.longitude),
                  16,
                );
              },
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56)),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("update lokasi"),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: FlutterMap(
                mapController: mapController,
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.example.app',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isFormValid() ? _submitForm : null,
              style: FilledButton.styleFrom(minimumSize: Size.fromHeight(56)),
              child: const Text("kirim"),
            ),
          ],
        ),
      ),
    );
  }
}
