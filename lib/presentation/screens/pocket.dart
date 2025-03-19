import 'package:flutter/material.dart';
import 'package:pockit/presentation/components/custom_button.dart';
import 'package:pockit/presentation/screens/tambah_pocket.dart';

class Pocket extends StatefulWidget {
  const Pocket({super.key});

  @override
  State<Pocket> createState() => _PocketState();
}

class _PocketState extends State<Pocket> {
  final List<Map<String, dynamic>> pockets = [
    {
      "name": "BJB",
      "accountNumber": "123473826",
      "holderName": "Aulia Siheala",
      "balance": 2540000,
      "type": "Debit",
    },
    {
      "name": "Gopay",
      "accountNumber": "123473826",
      "holderName": "Aulia Siheala",
      "balance": 2540000,
      "type": "E-Wallet",
    },
    {
      "name": "BCA",
      "accountNumber": "123473826",
      "holderName": "Aulia Siheala",
      "balance": 2540000,
      "type": "Debit",
    },
  ];

  int getTotalBalance() {
    int total = 0;
    for (var pocket in pockets) {
      total += pocket['balance'] as int;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo_putih_appbar.png',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Balance
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  'Rp${getTotalBalance()}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5383FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // My Pocket Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Pocket',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: CustomButton(
                    text: "Tambah Pocket",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPocketScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pocket List
            Expanded(
              child: ListView.builder(
                itemCount: pockets.length,
                itemBuilder: (context, index) {
                  return _buildPocketCard(pockets[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPocketCard(Map<String, dynamic> pocket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Row(
                children: [
                  // Blue part (left side)
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFFB9D1FF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Card Logo & Type
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 6,
                                      ),
                                      SizedBox(width: 2),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Bank name
                          Text(
                            pocket['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Account number & holder name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pocket['accountNumber'],
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                pocket['holderName'],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Yellow part (right side)
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFFFFF4C2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Type of account
                          Text(
                            pocket['type'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          // Balance
                          Text(
                            'Rp${pocket['balance']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

