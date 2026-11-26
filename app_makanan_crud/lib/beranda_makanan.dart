import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BerandaMakanan extends StatefulWidget {
  const BerandaMakanan({super.key});

  @override
  State<BerandaMakanan> createState() => _BerandaKaryawanState();
}

class _BerandaKaryawanState extends State<BerandaMakanan> {
  //koneksi supabase
  final SupabaseClient koneksi = Supabase.instance.client;
  List<dynamic> _dataMakanan = [];
  List<dynamic> _dataMakananFilter = [];
  TextEditingController _cariMakanan = TextEditingController();

  //fungsi GET data
  Future<void> tampilData() async {
    try {
      final respon = await koneksi.from('makanan').select();
      setState(() {
        _dataMakanan = respon;
        _dataMakananFilter = respon;
      });
    } catch (e) {
      print('Gagal Memuat Data: $e');
    }
  }

  //fungsi FILTER data
  void _filterData() {
    String query = _cariMakanan.text.toLowerCase();
    setState(() {
      _dataMakananFilter = _dataMakanan.where((item) {
        String jenisNama = item['nama_makanan'].toLowerCase();
        return jenisNama.contains(query);
      }).toList();
    });
  }

  //fungsi DELETE data
  Future<void> hapusData(int id) async {
    try {
      final respon = await koneksi.from('makanan').delete().eq('id', id);
    } catch (e) {
      print('Gagal Menghapus Data: $e');
    }
  }

  //fungsi EDIT data
  Future<void> ubahData(String nama, String asal, int harga, int id) async {
    TextEditingController namaUbah = TextEditingController(text: nama);
    TextEditingController asalUbah = TextEditingController(text: asal);
    TextEditingController hargaUbah = TextEditingController(
      text: harga.toString(),
    );
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('EDIT DATA'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nama_Makanan'),
                controller: namaUbah,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Asal_Makanan'),
                controller: asalUbah,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Harga_Makanan'),
                controller: hargaUbah,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await koneksi
                      .from('makanan')
                      .update({
                        'nama_makanan': namaUbah.text,
                        'asal_makanan': asalUbah.text,
                        'harga_makanan': int.parse(hargaUbah.text),
                      })
                      .eq('id', id);
                  Navigator.pop(context);
                  tampilData();
                } catch (e) {
                  print('Gagal mengubah data $e');
                }
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    tampilData();
    _cariMakanan.addListener(_filterData);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cariMakanan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Makanan')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _cariMakanan,
              decoration: InputDecoration(
                labelText: 'Cari Makanan...',
                border: OutlineInputBorder(),
                prefix: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dataMakananFilter.length,
              itemBuilder: (context, index) {
                final item = _dataMakananFilter[index];
                return ListTile(
                  title: Text(item['nama_makanan']),
                  subtitle: Text(
                    '${item['nama_makanan']} berasal dari ${item['asal_makanan']} dengan harga ${item['harga_makanan']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          ubahData(
                            item['nama_makanan'],
                            item['asal_makanan'],
                            item['harga_makanan'],
                            item['id'],
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('HAPUS DATA'),
                                content: Text(
                                  'Apakah Anda yakin menghapus data?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      hapusData(item['id']);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ya'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Batal'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
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
