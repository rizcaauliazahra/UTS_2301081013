import 'package:flutter/material.dart';

void main() {
  runApp(PdamApp());
}

class PdamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDAM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController meterBulanIniController = TextEditingController();
  final TextEditingController meterBulanLaluController = TextEditingController();
  String? jenisPelanggan = 'UMUM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masukan Data Pemakaian PDAM Anda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: kodeController,
                decoration: InputDecoration(labelText: 'Kode Pembayaran'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Kode Pembayaran';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Pelanggan';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: jenisPelanggan,
                items: ['GOLD', 'SILVER', 'UMUM'].map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    jenisPelanggan = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'Jenis Pelanggan'),
              ),
              TextFormField(
                controller: meterBulanIniController,
                decoration: InputDecoration(labelText: 'Meter Bulan Ini'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Meter Bulan Ini';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: meterBulanLaluController,
                decoration: InputDecoration(labelText: 'Meter Bulan Lalu'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Meter Bulan Lalu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OutputPage(
                          kode: kodeController.text,
                          nama: namaController.text,
                          jenisPelanggan: jenisPelanggan!,
                          meterBulanIni: int.parse(meterBulanIniController.text),
                          meterBulanLalu: int.parse(meterBulanLaluController.text),
                        ),
                      ),
                    );
                  }
                },
                child: Text('Hitung'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutputPage extends StatelessWidget {
  final String kode;
  final String nama;
  final String jenisPelanggan;
  final int meterBulanIni;
  final int meterBulanLalu;

  OutputPage({
    required this.kode,
    required this.nama,
    required this.jenisPelanggan,
    required this.meterBulanIni,
    required this.meterBulanLalu,
  });

  @override
  Widget build(BuildContext context) {
    int meterPakai = meterBulanIni - meterBulanLalu;
    int totalBayar = hitungBiaya(jenisPelanggan, meterPakai);

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Tagihan PDAM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode Pembayaran: $kode'),
            Text('Nama Pelanggan: $nama'),
            Text('Jenis Pelanggan: $jenisPelanggan'),
            Text('Meter Pakai: $meterPakai'),
            Text('Total Bayar: Rp $totalBayar'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  int hitungBiaya(String jenis, int meterPakai) {
    int biayaPerMeter;
    if (jenis == 'GOLD') {
      if (meterPakai <= 10) {
        biayaPerMeter = 5000;
      } else if (meterPakai <= 20) {
        biayaPerMeter = 10000;
      } else {
        biayaPerMeter = 20000;
      }
    } else if (jenis == 'SILVER') {
      if (meterPakai <= 10) {
        biayaPerMeter = 4000;
      } else if (meterPakai <= 20) {
        biayaPerMeter = 8000;
      } else {
        biayaPerMeter = 10000;
      }
    } else {
      if (meterPakai <= 10) {
        biayaPerMeter = 2000;
      } else if (meterPakai <= 20) {
        biayaPerMeter = 3000;
      } else {
        biayaPerMeter = 5000;
      }
    }
    return meterPakai * biayaPerMeter;
  }
}
