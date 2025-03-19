import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pockit/model/add_transaction_entities.dart';
import 'package:pockit/model/pocket_entities.dart';
import 'package:pockit/model/tag_entities.dart';
import 'package:pockit/presentation/components/custom_button.dart';
import 'package:pockit/presentation/components/custom_text_field.dart';
import 'package:pockit/service/app_service.dart';

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
  String? _kategoriId; // Variabel untuk menyimpan pilihan kategori

  // Daftar pilihan kategori, tag, dan pocket
  final Map<String, String> _kategoriMap = {'Expense': '1', 'Income': '2'};

  // Tag management
  String? _selectedTagName;
  List<TagEntities> _tagList = [];
  
  // Pocket management - updated to use PocketEntity
  int? _selectedPocketId;
  String? _selectedPocketName;
  List<PocketEntity> _pocketList = [];
  
  final TransactionService _transactionService = TransactionService();
  bool _isLoading = false;
  String _dateValue = '';

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  Future<void> _fetchTags() async {
    try {
      List<TagEntities> tags = await _transactionService.getTags();
      List<PocketEntity> pockets = await _transactionService.getPockets();
      setState(() {
        _tagList = tags;
        _pocketList = pockets;
        
        // Print the fetched data to check
        print('Fetched ${_tagList.length} tags');
        print('Fetched ${_pocketList.length} pockets');
        
        for (var tag in _tagList) {
          print('Tag: ${tag.name}');
        }
        
        for (var pocket in _pocketList) {
          print('Pocket: ${pocket.id} - ${pocket.name} - ${pocket.accountNumber} - ${pocket.balance}');
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
      _showErrorDialog('Error saat mengambil data: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Transaksi berhasil ditambahkan!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTransaction() async {
    // Validasi input
    if (_kategoriId == null || _kategoriId!.isEmpty) {
      _showErrorDialog('Kategori tidak boleh kosong');
      return;
    }
    if (_tanggalController.text.isEmpty) {
      _showErrorDialog('Tanggal tidak boleh kosong');
      return;
    }
    if (_jumlahController.text.isEmpty) {
      _showErrorDialog('Jumlah tidak boleh kosong');
      return;
    }
    if (_selectedTagName == null) {
      _showErrorDialog('Tag tidak boleh kosong');
      return;
    }
    if (_selectedPocketId == null) {
      _showErrorDialog('Pocket tidak boleh kosong');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Format tanggal untuk dikirim (yyyy-MM-dd)
      DateTime parsedDate = DateFormat('d MMMM yyyy').parse(_tanggalController.text);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      // Buat objek AddTransactionEntities
      AddTransactionEntities transaction = AddTransactionEntities(
        userId: 1, // Ganti dengan ID user yang sesuai
        date: formattedDate,
        transactionType: int.parse(_kategoriId!),
        amount: double.parse(_jumlahController.text),
        tag: _selectedTagName!,
        pocketId: _selectedPocketId!,
        description: _beritaController.text,
      );

      print('Sending transaction: ${transaction.toString()}');

      // Kirim data ke API
      await _transactionService.addTransaction(transaction);
      
      setState(() {
        _isLoading = false;
      });

      // Tampilkan pesan sukses
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error adding transaction: $e');
      _showErrorDialog('Error saat menambahkan transaksi: $e');
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      items: _kategoriMap.keys.map((kategori) {
                        return DropdownMenuItem<String>(
                          value: kategori,
                          child: Text(kategori),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _kategori = value;
                          _kategoriId = _kategoriMap[value].toString();
                          _kategoriController.text = _kategoriId ?? '';
                          print('Selected kategori: $_kategori with id: $_kategoriId');
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
                          // Simpan nilai tanggal untuk pengiriman
                          _dateValue = valueToSend;
                          print("Tanggal yang dikirim: $valueToSend");
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
                      value: _selectedTagName,
                      decoration: InputDecoration(
                        hintText: "Pilih tag",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _tagList.isEmpty
                          ? [DropdownMenuItem<String>(value: null, child: Text("Loading..."))]
                          : _tagList.map((tag) {
                              return DropdownMenuItem<String>(
                                value: tag.name,
                                child: Text(tag.name),
                              );
                            }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTagName = value;
                          _tagController.text = value ?? '';
                          print('Selected tag: $_selectedTagName');
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Pocket Dropdown - Updated to show more pocket information
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pocket",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _selectedPocketId,
                      decoration: InputDecoration(
                        hintText: "Pilih pocket",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _pocketList.isEmpty
                          ? [DropdownMenuItem<int>(value: null, child: Text("Loading..."))]
                          : _pocketList.map((pocket) {
                              // Enhanced dropdown item to show more pocket details
                              return DropdownMenuItem<int>(
                                value: pocket.id,
                                child: Text("${pocket.name} - ${NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp',
                                  decimalDigits: 0,
                                ).format(pocket.balance)}"),
                              );
                            }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPocketId = value;
                          _selectedPocketName = _pocketList
                              .firstWhere((pocket) => pocket.id == value)
                              .name;
                          _pocketController.text = value.toString();
                          print('Selected pocket: $_selectedPocketName with id: $_selectedPocketId');
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

                    CustomButton(text: "Tambah", onPressed: _addTransaction),
                  ],
                ),
              ),
            ),
      resizeToAvoidBottomInset: true,
    );
  }
}