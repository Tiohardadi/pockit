import 'package:flutter/material.dart';
import 'package:pockit/presentation/components/custom_text_field.dart';
import 'package:pockit/presentation/utils/app_colors.dart';

class TambahSplitbill extends StatefulWidget {
  const TambahSplitbill({super.key});

  @override
  State<TambahSplitbill> createState() => _TambahSplitbillState();
}

class _TambahSplitbillState extends State<TambahSplitbill> {
 final TextEditingController _nameController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pocketPengeluaranController = TextEditingController();
  final TextEditingController _pocketPembayaranController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _itemNameController.dispose();
    _amountController.dispose();
    _pocketPengeluaranController.dispose();
    _pocketPembayaranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4285F4),
        elevation: 0,
        title: const Text('Tambah Split Bill', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: 'Nama Bill',
              hintText: 'Masukkan nama bill',
            ),
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _pocketPengeluaranController,
              labelText: 'Pocket Pengeluaran',
              hintText: 'Pilih pocket pengeluaran',
              readOnly: true,
              onTap: () {
                // Handle pocket pengeluaran selection
              },
              suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const SizedBox(height: 16),
            
            CustomTextField(
              controller: _pocketPembayaranController,
              labelText: 'Pocket Pembayaran',
              hintText: 'Pilih pocket pembayaran',
              readOnly: true,
              onTap: () {
                // Handle pocket pembayaran selection
              },
              suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Split dengan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPersonCircle(
                  color: Colors.orange[300]!,
                  icon: Icons.person,
                  label: "Kamu",
                ),
                const SizedBox(width: 16),
                _buildAddPersonCircle(),
              ],
            ),
            const Divider(height: 32),
            
            _buildItemSection(),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF4285F4),
                elevation: 0,
                side: BorderSide.none,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text('Tambah Item Baru'),
            ),
            const SizedBox(height: 24),
            
            _buildSummarySection(),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4285F4),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Selanjutnya', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPersonCircle({required Color color, required IconData icon, required String label}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 24,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
  
  Widget _buildAddPersonCircle() {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          child: const Icon(Icons.add, color: Color(0xFF4285F4)),
        ),
        const SizedBox(height: 4),
        const Text('Tambah', style: TextStyle(fontSize: 12, color: Color(0xFF4285F4))),
      ],
    );
  }
  
  Widget _buildItemSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item 1',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _itemNameController,
          labelText: '',
          hintText: 'Nama item',
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  filled: false,
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('IDR'),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerRight,
                child: const Text('0'),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildSummaryRow('Sub Total', 'Rp0'),
        const SizedBox(height: 8),
        _buildSummaryRow('Pajak', 'Rp0'),
        const SizedBox(height: 8),
        _buildSummaryRow('Discount', 'Rp0'),
        const SizedBox(height: 8),
        _buildSummaryRow('Biaya Lainnya', 'Rp0'),
      ],
    );
  }
  
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}