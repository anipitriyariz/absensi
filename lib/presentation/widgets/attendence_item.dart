import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Contoh data attendances
    final List<Map<String, dynamic>> attendances = [
      {
        'title': 'Project Meeting',
        'description': 'Belajar Flutter',
        'suasana': 'Sedih',
        'imageUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
        'isLaptop': true,
        'isKomputer': false,
        'isHp': false,
        'isLainya': false,
      },
      {
        'title': 'Code Review',
        'description': 'Reviewed code with the team',
        'suasana': 'Netral',
        'imageUrl': 'https://randomuser.me/api/portraits/women/2.jpg',
        'isLaptop': false,
        'isKomputer': true,
        'isHp': false,
        'isLainya': false,
      },
      {
        'title': 'Design Discussion',
        'description': 'Talked about the new UI/UX design',
        'suasana': 'Kecewa',
        'imageUrl': 'https://randomuser.me/api/portraits/men/3.jpg',
        'isLaptop': true,
        'isKomputer': true,
        'isHp': false,
        'isLainya': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendence List'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          final attendance = attendances[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AttendenceItem(
              attendance: attendance,
              title: attendance['title'],
              description: attendance['description'],
              suasana: attendance['suasana'],
              imageUrl: attendance['imageUrl'],
              isLaptop: attendance['isLaptop'],
              isKomputer: attendance['isKomputer'],
              isHp: attendance['isHp'],
              isLainya: attendance['isLainya'],
              mood: attendance['suasana'],
              onTap: () {
                // Logika saat item ditekan
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Tapped on ${attendance['title']}'),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}

class AttendenceItem extends StatelessWidget {
  final Function()? onTap;
  final Map<String, dynamic> attendance;
  final String? title;
  final String? description;
  final String? suasana;
  final String? imageUrl;

  final bool? isLaptop;
  final bool? isKomputer;
  final bool? isHp;
  final bool? isLainya;
  final String? mood;

  const AttendenceItem({
    super.key,
    this.onTap,
    required this.title,
    required this.description,
    required this.suasana,
    required this.imageUrl,
    required this.attendance,
    required this.isLaptop,
    required this.isKomputer,
    required this.isHp,
    required this.isLainya,
    required this.mood,
  });

  Color getMoodColor(String suasana) {
    switch (suasana) {
      case "Senang":
        return Colors.green;
      case "Netral":
        return Colors.orange;
      case "Sedih":
        return Colors.red;
      case "Kecewa":
        return Colors.deepOrange;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 2,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Menampilkan gambar wajah orang dari internet
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Gambar berhasil dimuat
                  } else {
                    // Tampilkan loader saat gambar sedang dimuat
                    return const CircularProgressIndicator();
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  // Tampilkan gambar default atau widget lain jika gagal memuat
                  return const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.red,
                  );
                },
              ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description ?? "-",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title ?? "-",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    suasana ?? "-",
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    if (isLaptop == true)
                      const Icon(
                        Icons.laptop_mac_rounded,
                        color: Colors.blue,
                        size: 16,
                      ),
                    if (isKomputer == true)
                      const Icon(
                        Icons.window_rounded,
                        color: Colors.red,
                        size: 16,
                      ),
                    if (isHp == true)
                      const Icon(
                        Icons.phone_android_rounded,
                        color: Colors.purple,
                        size: 16,
                      ),
                    if (isLainya == true)
                      const Icon(
                        Icons.roundabout_left,
                        color: Colors.green,
                        size: 16,
                      ),
                  ])
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: getMoodColor(suasana ?? "").withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    suasana ?? "-",
                    style: TextStyle(
                      color: getMoodColor(suasana ?? ""),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton.filled(
                  onPressed: onTap,
                  icon: const Icon(Icons.edit_rounded),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
