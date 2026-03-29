import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
      "date": Timestamp.fromDate(date),
    };
  }

  factory JournalEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final rawDate = data['date'];
    final rawContent = data['content'] ?? data['cotent'];

    return JournalEntry(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      content: (rawContent ?? '') as String,
      date: _parseDate(rawDate),
    );
  }

  static DateTime _parseDate(dynamic rawDate) {
    if (rawDate is Timestamp) {
      return rawDate.toDate();
    }

    if (rawDate is DateTime) {
      return rawDate;
    }

    if (rawDate is String) {
      return DateTime.tryParse(rawDate) ?? DateTime.now();
    }

    return DateTime.now();
  }
}
