import 'package:flutter/material.dart';
import 'package:pockit/model/transaction_entities.dart';
import 'package:pockit/service/app_service.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final TransactionService _transactionService = TransactionService();
  late Future<TransactionResponse> _transactionFuture;

  @override
  void initState() {
    super.initState();
    _transactionFuture = _transactionService.getTransactions(
      1,
      '2025-03-19',
      0,
      10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Harian')),
      body: FutureBuilder<TransactionResponse>(
        future: _transactionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final transactions = snapshot.data!.transactions;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text(transaction.description),
                  subtitle: Text('Rp ${transaction.amount}'),
                  trailing: Text(transaction.tag),
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      ),
    );
  }
}