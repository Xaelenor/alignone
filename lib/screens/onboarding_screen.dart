import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _addLifeArea() async {
    if (_nameController.text.isNotEmpty) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      await appProvider.createLifeArea(
        _nameController.text,
        _descriptionController.text,
      );
      _nameController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Setup Life Areas')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Add 3-5 Life Areas that matter to you (e.g., Health, Career, Relationships).',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Life Area Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addLifeArea,
              child: const Text('Add Area'),
            ),
            const Divider(height: 48),
            Expanded(
              child: ListView.builder(
                itemCount: appProvider.lifeAreas.length,
                itemBuilder: (context, index) {
                  final area = appProvider.lifeAreas[index];
                  return ListTile(
                    title: Text(area.name),
                    subtitle: area.description != null
                        ? Text(area.description!)
                        : null,
                  );
                },
              ),
            ),
            if (appProvider.lifeAreas.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  // Re-fetch to trigger onboarding completion
                  appProvider.fetchData();
                },
                child: const Text('Complete Setup'),
              ),
          ],
        ),
      ),
    );
  }
}
