import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myjournalapp/providers/auth_provider.dart';
import 'package:myjournalapp/data/journal_entry_model.dart';
import 'package:myjournalapp/service/journal_entry_service.dart';

// Service provider
final journalServiceProvider = Provider<JournalEntryService>((ref) {
  return JournalEntryService();
});

// Entries stream provider
final journalEntryProvider = StreamProvider.autoDispose<List<JournalEntry>>((
  ref,
) {
  final authState = ref.watch(authStateProvider);
  final currentUser = authState.value;

  if (currentUser == null) {
    return const Stream<List<JournalEntry>>.empty();
  }

  final service = ref.read(journalServiceProvider);
  return service.getEntries();
});
