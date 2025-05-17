import 'package:flutter/material.dart';

class McqCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const McqCard({
    super.key,
    required this.question,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(question['options']);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...options.map((option) {
              final isSelected = option == selectedOption;
              return ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    if (value != null) onOptionSelected(value);
                  },
                ),
                tileColor: isSelected ? Colors.blue.shade50 : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}
