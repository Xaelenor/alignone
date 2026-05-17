import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/life_area.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  LifeArea? _selectedArea;
  final _actionController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    if (appProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('AlignOne'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: appProvider.fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                today,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Streak: ${appProvider.currentStreak} 🔥',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 48),

              if (appProvider.todayAction == null) ...[
                const Text(
                  'What is your One Aligned Thing today?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                DropdownButtonFormField<LifeArea>(
                  decoration: const InputDecoration(labelText: 'Life Area'),
                  items: appProvider.lifeAreas.map((area) {
                    return DropdownMenuItem(
                      value: area,
                      child: Text(area.name),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedArea = val),
                  initialValue: _selectedArea,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _actionController,
                  decoration: const InputDecoration(
                    labelText: 'Specific Action',
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () async {
                    if (_selectedArea != null &&
                        _actionController.text.isNotEmpty) {
                      await appProvider.createDailyAction(
                        _actionController.text,
                        _selectedArea!.id,
                      );
                    }
                  },
                  child: const Text('Commit', style: TextStyle(fontSize: 18)),
                ),
              ] else if (!appProvider.todayAction!.completed) ...[
                const Text(
                  'Today\'s Commitment',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          appProvider.todayAction!.actionText,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            labelText: 'Reflection / Notes (Optional)',
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            await appProvider.completeAction(
                              appProvider.todayAction!.id,
                              _notesController.text,
                            );
                          },
                          child: const Text(
                            'Mark as Done',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'You have completed your action for today!',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
