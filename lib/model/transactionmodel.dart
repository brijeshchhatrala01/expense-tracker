// models/transaction_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final double amount;
  final String category;
  final String note;
  final String type;
  final String paymentMethod;
  final DateTime date;
  final Timestamp timestamp;

  TransactionModel({
    required this.amount,
    required this.category,
    required this.note,
    required this.type,
    required this.paymentMethod,
    required this.date,
    required this.timestamp,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionModel(
      amount: (data['amount'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      note: data['note'] ?? '',
      type: data['type'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'note': note,
      'type': type,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String(),
      'timestamp': timestamp,
    };
  }
}
