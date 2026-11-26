import 'package:flutter/material.dart';
import 'package:app_makanan_crud/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahMakanan extends StatefulWidget {
  const TambahMakanan({super.key});

  @override
  State<TambahMakanan> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<TambahMakanan> {
  //koneksi supabase
  final SupabaseClient koneksi = Supabase.instance.client;
  final kunciForm = GlobalKey<FormState>();
  String? addNama, addAsal, addHarga;

  //FUNGSI ADD data
  Future<void> tambahData() async {
    if (kunciForm.currentState!.validate()) {
      kunciForm.currentState!.save();
      try {
        final respon = await koneksi.from('makanan').insert({
          'nama_makanan': addNama,
          'asal_makanan': addAsal,
          'harga_makanan': int.parse(addHarga!),
        });
      } catch (e) {
        print('Gagal Menambah Data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Tambah Makanan'))),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: kunciForm,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Isi Nama'),
                  validator: (value) => value!.isEmpty ? 'Masukkan Nama' : null,
                  onSaved: (value) => addNama = value,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Isi Asal Makanan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Masukkan Asal Makanan' : null,
                  onSaved: (value) => addAsal = value,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Isi Harga Makanan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Masukkan Harga Makanan' : null,
                  onSaved: (value) => addHarga = value,
                ),
                SizedBox(height: 10),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tambahData();
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DataMakanan()),
                    );
                  },
                  child: Text('tambah'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
