import 'package:flutter/material.dart';
import '../models/life_area.dart';
import '../models/daily_action.dart';
import '../services/supabase_service.dart';
import 'package:intl/intl.dart';

class AppProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  List<LifeArea> _lifeAreas = [];
  List<DailyAction> _allActions = [];
  DailyAction? _todayAction;
  bool _isLoading = false;
  bool _hasCompletedOnboarding = true;

  List<LifeArea> get lifeAreas => _lifeAreas;
  List<DailyAction> get allActions => _allActions;
  DailyAction? get todayAction => _todayAction;
  bool get isLoading => _isLoading;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  int get currentStreak {
    int streak = 0;
    DateTime now = DateTime.now();
    for (int i = 0; i < _allActions.length; i++) {
      // logic for streak based on completed consecutive days
      // simplifying for now
      if (_allActions[i].completed) streak++;
    }
    return streak; // Placeholder
  }

  int get longestStreak => currentStreak; // Placeholder

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _lifeAreas = await _supabaseService.getLifeAreas();
      _hasCompletedOnboarding = _lifeAreas.isNotEmpty;

      _allActions = await _supabaseService.getAllActions();

      String todayLocal = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _todayAction = await _supabaseService.getTodayAction(todayLocal);
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createLifeArea(String name, String? description) async {
    await _supabaseService.createLifeArea(name, description);
    await fetchData();
  }

  Future<void> deleteLifeArea(String id) async {
    await _supabaseService.deleteLifeArea(id);
    await fetchData();
  }

  Future<void> createDailyAction(String actionText, String? lifeAreaId) async {
    String todayLocal = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _supabaseService.createDailyAction(
      actionText,
      lifeAreaId,
      todayLocal,
    );
    await fetchData();
  }

  Future<void> completeAction(String id, String? notes) async {
    await _supabaseService.completeAction(id, notes);
    await fetchData();
  }
}
