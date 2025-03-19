import 'package:flutter/material.dart';

class AddPocketScreen extends StatefulWidget {
  const AddPocketScreen({super.key});

  @override
  State<AddPocketScreen> createState() => _AddPocketScreenState();
}

class _AddPocketScreenState extends State<AddPocketScreen> {
  String selectedType = 'Debit';
  final nameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Pocket',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5383FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nama Pocket
            _buildFormLabel('Nama Pocket'),
            _buildFormField(
              controller: nameController,
              hintText: 'Masukkan nama pocket',
            ),
            const SizedBox(height: 20),

            // Pocket Type
            _buildFormLabel('Tipe Pocket'),
            _buildTypeSelector(),
            const SizedBox(height: 20),

            // Nomor Rekening
            _buildFormLabel('Nomor Rekening'),
            _buildFormField(
              controller: accountNumberController,
              hintText: 'Nomor Rekening',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Balance
            _buildFormLabel('Balance'),
            _buildFormField(
              controller: balanceController,
              hintText: 'Rp',
              prefixText: 'Rp',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),

            // Circle Avatar - S
            const SizedBox(height: 40),

            // Tambah Button
            ElevatedButton(
              onPressed: () {
                // Save pocket and navigate back
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5383FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Tambah',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String hintText,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixText: prefixText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildTypeSelector() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Debit'),
                    onTap: () {
                      setState(() {
                        selectedType = 'Debit';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Credit'),
                    onTap: () {
                      setState(() {
                        selectedType = 'Credit';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('E-Wallet'),
                    onTap: () {
                      setState(() {
                        selectedType = 'E-Wallet';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedType),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}