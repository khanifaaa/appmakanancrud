import 'package:app_makanan_crud/beranda_makanan.dart';
import 'package:app_makanan_crud/tambah_makanan.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://oeeukjqatzhlkzlchkwq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9lZXVranFhdHpobGt6bGNoa3dxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg5MzI5OTksImV4cCI6MjA3NDUwODk5OX0.4u5XtnFrwxzFamLF9gMQulUHldwHqpsc02kDVqBh3gM',
  );
  runApp(DataMakanan());
}

class DataMakanan extends StatelessWidget {
  const DataMakanan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Beranda());
  }
}

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _indeks = 0;
  final List<Widget> _halaman = [BerandaMakanan(), TambahMakanan()];
  void _onTapClick(int index) {
    setState(() {
      _indeks = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman[_indeks],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: _onTapClick,
        currentIndex: _indeks,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Tambah',
          ),
        ],
      ),
    );
  }
}
