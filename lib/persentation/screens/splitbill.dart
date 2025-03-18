import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Splitbill extends StatefulWidget {
  const Splitbill({super.key});

  @override
  State<Splitbill> createState() => _SplitbillState();
}

class _SplitbillState extends State<Splitbill> {
   bool _isActiveTab = true;
  
  // Sample bills list - can be empty for testing empty state
  final List<Map<String, dynamic>> bills = [
    {
      "nama bill": "Alhamdulillah BUKBER",
      "date": "14 April 2025",
      "time": "14:33",
      "total": "387500",
      "item count": "4 item",
      "status": "selesai",
      "partisipan": ["fina", "Ghani", "rahmat", "tio", "aul", "nisa", "Eca"],
    },
    {
      "nama bill": "Makan Siang Kantor",
      "date": "12 April 2025",
      "time": "13:15",
      "total": "245000",
      "item count": "3 item",
      "status": "selesai",
      "partisipan": ["fina", "Ghani", "rahmat", "tio"],
    },
    {
      "nama bill": "Dinner Weekend",
      "date": "10 April 2025",
      "time": "19:45",
      "total": "520000",
      "item count": "6 item",
      "status": "selesai",
      "partisipan": ["fina", "aul", "nisa", "Eca"],
    },
    {
      "nama bill": "Belanja Bulanan",
      "date": "5 April 2025",
      "time": "10:22",
      "total": "782500",
      "item count": "12 item",
      "status": "selesai",
      "partisipan": ["fina", "Ghani", "tio"],
    },
  ];

  // For testing empty state, uncomment this line:
  // final List<Map<String, dynamic>> bills = [];

  // Format currency
  String formatCurrency(String amount) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(int.parse(amount));
  }

  @override
  Widget build(BuildContext context) {
    // Filter bills based on active tab
    final filteredBills = bills.isEmpty 
        ? [] 
        : bills.where((bill) => bill["status"] == (_isActiveTab ? "aktif" : "selesai")).toList();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4169E1),
        title: const Text(
          'Pockit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.orange[100],
              child: const Icon(
                Icons.person,
                color: Colors.orange,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab switcher
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isActiveTab = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isActiveTab ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Aktif',
                          style: TextStyle(
                            color: _isActiveTab ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isActiveTab = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isActiveTab ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          'Selesai',
                          style: TextStyle(
                            color: !_isActiveTab ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bills list or empty state
          Expanded(
            child: bills.isEmpty
                ? _buildEmptyState() // Show empty state if bills list is empty
                : filteredBills.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada bill ${_isActiveTab ? "aktif" : "selesai"}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredBills.length,
                        itemBuilder: (context, index) {
                          final bill = filteredBills[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildBillCard(bill),
                          );
                        },
                      ),
          ),
          
          // Add Split Bill Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4169E1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tambah Split Bill',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/placeholder.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Tagihan rame-rame? Yuk, buat Split Bill pertama kamu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bill["nama bill"],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${bill["date"]} | ${bill["time"]}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatCurrency(bill["total"]),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${bill["item count"]} ${bill["partisipan"].length} orang',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                _buildAvatarStack(bill["partisipan"]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(List<dynamic> participants) {
    return SizedBox(
      height: 24,
      width: 120,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          for (int i = 0; i < participants.length; i++)
            Positioned(
              right: i * 16.0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.primaries[i % Colors.primaries.length],
                child: Text(
                  participants[i][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}