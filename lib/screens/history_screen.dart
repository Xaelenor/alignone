import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final actions = appProvider.allActions;

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.builder(
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          final area = appProvider.lifeAreas.firstWhere(
            (a) => a.id == action.lifeAreaId,
            orElse: () => throw Exception(
              'Area not found',
            ), // In a real app we handle missing nicely
          );

          return ListTile(
            leading: Icon(
              action.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: action.completed ? Colors.green : Colors.grey,
            ),
            title: Text(action.actionText),
            subtitle: Text('${area.name} - ${action.dateLocal}'),
            onTap: () {
              if (action.notes != null && action.notes!.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Reflection'),
                    content: Text(action.notes!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
