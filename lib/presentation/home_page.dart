import 'package:absensi/presentation/attendence.dart';
import 'package:absensi/presentation/login_page.dart';
import 'package:absensi/presentation/widgets/attendence_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                children: const [
                  HomePage1(scrollKey: "home_page_1"),
                  HomePage1(scrollKey: "home_page_2"),
                  HomePage1(scrollKey: "home_page_3"),
                ],
              ),
            ),
            BottomNavigation(
              onItemSelected: (index) {
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage1 extends StatefulWidget {
  final String scrollKey;

  const HomePage1({
    super.key,
    required this.scrollKey,
  });

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  // Buat data absensi statis
  final List<Map<String, dynamic>> attendances = [
    {
      'work_description': 'Code Review',
      'work': 'Reviewed code with the team',
      'mood': 'Focused',
      'image': 'https://via.placeholder.com/150', // Gambar statis
      'is_laptop': 1,
      'is_komputer': 1,
      'is_hp': 0,
      'is_lainya': 0,
    },
    {
      'work_description': 'Code Review',
      'work': 'Reviewed code with the team',
      'mood': 'Focused',
      'image': 'https://via.placeholder.com/150', // Gambar statis
      'is_laptop': 1,
      'is_komputer': 1,
      'is_hp': 0,
      'is_lainya': 0,
    },
    // Tambah lebih banyak data statis sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout),
                    ),
                    IconButton.filled(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Attendece()),
                        );
                        setState(() {}); // Menyegarkan halaman setelah kembali
                      },
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                Text(
                  "Absensi User",
                  style: GoogleFonts.openSans(
                    color: const Color.fromARGB(255, 0, 24, 44),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "September 2024",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              key: PageStorageKey(widget.scrollKey),
              padding: const EdgeInsets.all(16),
              itemCount: attendances.length,
              itemBuilder: (context, index) {
                final attendance = attendances[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Dismissible(
                    key: Key(attendance['work_description']),
                    onDismissed: (direction) {
                      // Menghapus data secara statis
                      setState(() {
                        attendances.removeAt(index);
                      });
                    },
                    child: AttendenceItem(
                      attendance: attendance,
                      title: attendance['work_description'],
                      description: attendance['work'],
                      suasana: attendance['mood'],
                      imageUrl: attendance['image'],
                      isLaptop: attendance['is_laptop'] == 1,
                      isKomputer: attendance['is_komputer'] == 1,
                      isHp: attendance['is_hp'] == 1,
                      isLainya: attendance['is_lainya'] == 1,
                      mood: attendance['mood'],
                      // Navigasi dihapus sementara
                      onTap: () async {
                        print(
                            "Attendance item tapped: ${attendance['work_description']}");
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  final Function(int) onItemSelected;

  const BottomNavigation({
    super.key,
    required this.onItemSelected,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
              widget.onItemSelected(0);
            },
            icon: const FaIcon(FontAwesomeIcons.house),
            color: _selectedIndex == 0 ? Colors.purple : null,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
              widget.onItemSelected(1);
            },
            icon: const FaIcon(FontAwesomeIcons.solidUser),
            color: _selectedIndex == 1 ? Colors.purple : null,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
              widget.onItemSelected(2);
            },
            icon: const FaIcon(FontAwesomeIcons.gear),
            color: _selectedIndex == 2 ? Colors.purple : null,
          ),
        ],
      ),
    );
  }
}
