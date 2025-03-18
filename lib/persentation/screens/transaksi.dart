import 'package:flutter/material.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({super.key});

  @override
  State<Transaksi> createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  final List<Map<String, dynamic>> transactions = [
    {
      "Berita": "Makan Malam",
      "amount": 24000,
      "type": "expense",
      "tag": "Belanja",
      "date": "Senin, 1 April 2025",
      "pocket": "cash",
    },
    {
      "Berita": "Nisa Bayar Utang",
      "amount": 24000,
      "type": "income",
      "tag": "Pemasukan",
      "date": "Senin, 1 April 2025",
      "pocket": "cash",
    },
    {
      "Berita": "Makan Siang",
      "amount": 15000,
      "type": "expense",
      "tag": "Travelling",
      "date": "Selasa, 2 April 2025",
      "pocket": "cash",
    },
  ];

  Map<String, bool> expandedState = {};

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
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFFFF4C2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'April 2025',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem('Rp40,000', 'Incomes'),
                      _buildSummaryItem('Rp313,000', 'Expenses'),
                      _buildSummaryItem(
                        '-Rp273,000',
                        'Balance',
                        isNegative: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _groupTransactions().length,
                itemBuilder: (context, index) {
                  String date = _groupTransactions().keys.elementAt(index);
                  List<Map<String, dynamic>> dayTransactions =
                      _groupTransactions()[date]!;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedState[date] =
                                !(expandedState[date] ?? false);
                          });
                        },
                        child: _buildDayHeader(date, dayTransactions),
                      ),
                      if (expandedState[date] ?? false)
                        ...dayTransactions
                            .map(
                              (transaction) =>
                                  _buildTransactionItem(transaction),
                            )
                            .toList(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String amount,
    String label, {
    bool isNegative = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isNegative ? Colors.red : Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDayHeader(String date, List<Map<String, dynamic>> transactions) {
    int totalAmount = transactions.fold(
      0,
      (sum, item) =>
          (sum + (item['type'] == 'expense' ? -item['amount'] : item['amount']))
              .toInt(),
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                expandedState[date] ?? false
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Text(
            'Total: Rp$totalAmount',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    bool isExpense = transaction['type'] == 'expense';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isExpense ? Colors.red[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isExpense ? Icons.arrow_upward : Icons.arrow_downward,
              color: isExpense ? Colors.red : Colors.green,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['Berita'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  transaction['tag'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isExpense ? '-' : '+'}Rp${transaction['amount']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isExpense ? Colors.red : Colors.green,
                ),
              ),
              Text(
                transaction['pocket'], // Menampilkan data pocket
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupTransactions() {
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in transactions) {
      String date = transaction['date'] ?? 'Unknown Date';
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }
    return groupedTransactions;
  }
}
