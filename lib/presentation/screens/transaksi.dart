import 'package:flutter/material.dart';
import 'package:pockit/presentation/screens/edit_transaksi.dart';
import 'package:pockit/presentation/constant/utils.dart';
import 'package:intl/intl.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({super.key});

  @override
  State<Transaksi> createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  final List<Map<String, dynamic>> transactions = [
    {
      "id": 1,
      "Berita": "Makan Malam",
      "amount": 24000,
      "type": "expense",
      "tag": "Belanja",
      "date": "Senin, 1 April 2025",
      "pocket": "cash",
    },
    {
      "id": 2,
      "Berita": "Nisa Bayar Utang",
      "amount": 24000,
      "type": "income",
      "tag": "Pemasukan",
      "date": "Senin, 1 April 2025",
      "pocket": "cash",
    },
    {
      "id": 3,
      "Berita": "Makan Siang",
      "amount": 15000,
      "type": "expense",
      "tag": "Travelling",
      "date": "Selasa, 2 April 2025",
      "pocket": "cash",
    },
  ];

  Map<String, bool> expandedState = {};
  DateTime selectedDate = DateTime(2025, 4); // Default to April 2025

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year, // Start with year selection
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF5383FF), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Calendar text color
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _getFormattedMonth() {
    return DateFormat('MMMM yyyy').format(selectedDate);
  }

  // Filter transactions based on selected month and year
  List<Map<String, dynamic>> _getFilteredTransactions() {
    final selectedMonth = selectedDate.month;
    final selectedYear = selectedDate.year;
    
    return transactions.where((transaction) {
      try {
        // Assuming date format is "Day, DD Month YYYY"
        final parts = transaction['date'].split(', ');
        final dateParts = parts[1].split(' ');
        
        // Indonesian month names
        final monthNames = {
          'Januari': 1, 'Februari': 2, 'Maret': 3, 'April': 4,
          'Mei': 5, 'Juni': 6, 'Juli': 7, 'Agustus': 8,
          'September': 9, 'Oktober': 10, 'November': 11, 'Desember': 12
        };
        
        final day = int.parse(dateParts[0]);
        final month = monthNames[dateParts[1]] ?? 1;
        final year = int.parse(dateParts[2]);
        
        return month == selectedMonth && year == selectedYear;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print(Utils);
    final filteredTransactions = _getFilteredTransactions();
    
    // Calculate summary for the selected month
    int totalIncome = 0;
    int totalExpense = 0;
    
    for (var transaction in filteredTransactions) {
      if (transaction['type'] == 'income') {
        totalIncome += transaction['amount'] as int;
      } else {
        totalExpense += transaction['amount'] as int;
      }
    }
    
    int balance = totalIncome - totalExpense;
    
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
            // Summary Card with Date Picker
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFFFF4C2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        Text(
                          _getFormattedMonth(),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.calendar_month, size: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem('Rp${totalIncome.toString()}', 'Incomes'),
                      _buildSummaryItem('Rp${totalExpense.toString()}', 'Expenses'),
                      _buildSummaryItem(
                        '${balance >= 0 ? '' : '-'}Rp${balance.abs().toString()}',
                        'Balance',
                        isNegative: balance < 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredTransactions.isEmpty 
                ? Center(
                    child: Text(
                      'Tidak ada transaksi untuk bulan ini',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _groupTransactions(filteredTransactions).length,
                    itemBuilder: (context, index) {
                      String date = _groupTransactions(filteredTransactions).keys.elementAt(index);
                      List<Map<String, dynamic>> dayTransactions =
                          _groupTransactions(filteredTransactions)[date]!;

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
    return GestureDetector(
      onTap: () {
        Utils.pushWithFade(context, EditTransaksi(transactionId: transaction['id']));
      },
      child: Container(
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
                  transaction['pocket'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupTransactions([List<Map<String, dynamic>>? transactionList]) {
    final List<Map<String, dynamic>> transactionsToGroup = transactionList ?? transactions;
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in transactionsToGroup) {
      String date = transaction['date'] ?? 'Unknown Date';
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }
    return groupedTransactions;
  }
}