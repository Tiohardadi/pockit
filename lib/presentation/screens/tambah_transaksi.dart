import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pockit/presentation/components/custom_button.dart';
import 'package:pockit/presentation/components/custom_text_field.dart';

class TambahTransaksi extends StatefulWidget {
  const TambahTransaksi({super.key});

  @override
  State<TambahTransaksi> createState() => _TambahTransaksiState();
}

class _TambahTransaksiState extends State<TambahTransaksi> {
  final _kategoriController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tagController = TextEditingController();
  final _pocketController = TextEditingController();
  final _beritaController = TextEditingController();

  String? _kategori; // Variabel untuk menyimpan pilihan kategori
  String? _tag; // Variabel untuk menyimpan pilihan tag
  String? _pocket; // Variabel untuk menyimpan pilihan pocket

  // Daftar pilihan kategori, tag, dan pocket
  final List<String> _kategoriList = ['Expense', 'Income'];
  final List<String> _tagList = ['Belanja', 'Hiburan', 'Pemasukan'];
  final List<String> _pocketList = ['Cash', 'Gopay', 'BCA'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              Image.asset(
                'assets/images/LogoPutih.png',
                width: 100,
                height: 25,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundImage: const AssetImage('assets/profile.png'),
                  onBackgroundImageError: (exception, stackTrace) {
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person),
                    );
                  },
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF5383FF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Kategori - Teks Rata Kiri
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kategori",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: InputDecoration(
                  hintText: "Pilih kategori",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _kategoriList.map((kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _kategori = value;
                    _kategoriController.text = value ?? ''; // Menyimpan pilihan kategori
                  });
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _tanggalController,
                labelText: "Tanggal",
                hintText: "tanggal",
                readOnly: true, // Agar tidak bisa diketik langsung
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    // Format untuk tampil di TextField
                    String formattedDate = DateFormat(
                      'd MMMM yyyy',
                    ).format(pickedDate);
                    _tanggalController.text = formattedDate;

                    // Format untuk value yang dikirim (yyyy-MM-dd)
                    String valueToSend = DateFormat(
                      'yyyy-MM-dd',
                    ).format(pickedDate);
                    // Lakukan apa yang perlu dengan valueToSend
                    print(
                      "Tanggal yang dikirim: $valueToSend",
                    ); // Contoh nilai yang dikirim
                  }
                },
                suffixIcon: Icon(
                  Icons.calendar_today,
                ), // Menambahkan ikon kalender
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _jumlahController,
                labelText: "Jumlah",
                hintText: "jumlah",
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              // Tag Dropdown
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tag",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _tag,
                decoration: InputDecoration(
                  hintText: "Pilih tag",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _tagList.map((tag) {
                  return DropdownMenuItem<String>(
                    value: tag,
                    child: Text(tag),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tag = value;
                    _tagController.text = value ?? ''; // Menyimpan pilihan tag
                  });
                },
              ),
              SizedBox(height: 16),
              // Pocket Dropdown
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pocket",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _pocket,
                decoration: InputDecoration(
                  hintText: "Pilih pocket",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _pocketList.map((pocket) {
                  return DropdownMenuItem<String>(
                    value: pocket,
                    child: Text(pocket),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _pocket = value;
                    _pocketController.text = value ?? ''; // Menyimpan pilihan pocket
                  });
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _beritaController,
                labelText: "Berita",
                hintText: "berita",
              ),
              SizedBox(height: 100),
              
              CustomButton(text: "Tambah", onPressed: () {})
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
