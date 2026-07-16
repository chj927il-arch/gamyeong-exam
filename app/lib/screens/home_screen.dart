import 'package:flutter/material.dart';
import '../models/exam_subject.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: examSubjects.length,
      itemBuilder: (context, index) {
        final subject = examSubjects[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: subject.categories.isEmpty
                ? null
                : Text(subject.categories.join(' · ')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QuizScreen(subjectId: subject.id, subjectName: subject.name),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
