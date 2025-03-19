import 'package:flutter/material.dart';
import 'package:pockit/presentation/screens/edit_transaksi.dart';
import 'package:pockit/presentation/constant/utils.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pockit/model/transaction_entities.dart';
import 'package:pockit/service/app_service.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({super.key});

  @override
  State<Transaksi> createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  final TransactionService _transactionService = TransactionService();
  late Future<TransactionResponse> _transactionFuture;
  DateTime selectedDate = DateTime(2025, 3);
  Map<String, bool> expandedState = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _refreshTransactions();
  }

  void _refreshTransactions() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    _transactionFuture = _transactionService.getTransactions(
      1, // userId
      formattedDate,
      0, // page
      100, // size
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5383FF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _refreshTransactions();
      });
    }
  }

  String _getFormattedMonth() {
    return DateFormat('MMMM yyyy').format(selectedDate);
  }

  // Format date for display
  String _formatDateForDisplay(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<TransactionResponse>(
          future: _transactionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.transactions.isEmpty) {
              return Column(
                children: [
                  _buildSummaryCard([], selectedDate),
                  const SizedBox(height: 16),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Tidak ada transaksi untuk bulan ini',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              final transactions = snapshot.data!.transactions;
              // Filter transactions for selected month
              final filteredTransactions = _filterTransactionsByMonth(transactions);
              
              return Column(
                children: [
                  _buildSummaryCard(filteredTransactions, selectedDate),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredTransactions.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada transaksi untuk bulan ini',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _groupTransactions(filteredTransactions).length,
                          itemBuilder: (context, index) {
                            String date = _groupTransactions(filteredTransactions).keys.elementAt(index);
                            List<Transaction> dayTransactions = _groupTransactions(filteredTransactions)[date]!;

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      expandedState[date] = !(expandedState[date] ?? false);
                                    });
                                  },
                                  child: _buildDayHeader(
                                    _formatDateForDisplay(date),
                                    dayTransactions,
                                  ),
                                ),
                                if (expandedState[date] ?? false)
                                  ...dayTransactions
                                      .map((transaction) => _buildTransactionItem(transaction))
                                      .toList(),
                              ],
                            );
                          },
                        ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  List<Transaction> _filterTransactionsByMonth(List<Transaction> transactions) {
    final selectedMonth = selectedDate.month;
    final selectedYear = selectedDate.year;

    return transactions.where((transaction) {
      try {
        final transactionDate = DateTime.parse(transaction.transactionDate);
        return transactionDate.month == selectedMonth && 
               transactionDate.year == selectedYear;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  Widget _buildSummaryCard(List<Transaction> transactions, DateTime date) {
    // Calculate summary
    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in transactions) {
      if (transaction.transactionType == 'Income') {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    double balance = totalIncome - totalExpense;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4C2),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_month, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                'Rp${NumberFormat('#,###').format(totalIncome)}',
                'Incomes',
              ),
              _buildSummaryItem(
                'Rp${NumberFormat('#,###').format(totalExpense)}',
                'Expenses',
              ),
              _buildSummaryItem(
                '${balance >= 0 ? '' : '-'}Rp${NumberFormat('#,###').format(balance.abs())}',
                'Balance',
                isNegative: balance < 0,
              ),
            ],
          ),
        ],
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
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDayHeader(
    String displayDate,
    List<Transaction> transactions,
  ) {
    double totalAmount = transactions.fold(
      0,
      (sum, item) => sum + (item.transactionType == 'Expense' ? -item.amount : item.amount),
    );
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
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
                expandedState[transactions.first.transactionDate] ?? false
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                displayDate,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Text(
            'Total: Rp${NumberFormat('#,###').format(totalAmount)}',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    bool isExpense = transaction.transactionType == 'Expense';
    return GestureDetector(
      onTap: () {
        Utils.pushWithFade(
          context,
          EditTransaksi(transactionId: transaction.id),
        );
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
                    transaction.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    transaction.tag,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isExpense ? '-' : '+'}Rp${NumberFormat('#,###').format(transaction.amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isExpense ? Colors.red : Colors.green,
                  ),
                ),
                Text(
                  transaction.pocket,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<Transaction>> _groupTransactions(List<Transaction> transactions) {
    Map<String, List<Transaction>> groupedTransactions = {};
    
    for (var transaction in transactions) {
      // Use just the date part (YYYY-MM-DD) for grouping
      String dateKey = transaction.transactionDate.split('T')[0];
      
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }
    
    // Sort keys by date (most recent first)
    final sortedKeys = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    // Create a new map with sorted keys
    Map<String, List<Transaction>> sortedGroupedTransactions = {};
    for (var key in sortedKeys) {
      sortedGroupedTransactions[key] = groupedTransactions[key]!;
    }
    
    return sortedGroupedTransactions;
  }
}