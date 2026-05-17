import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/life_area.dart';
import '../models/daily_action.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Life Areas
  Future<List<LifeArea>> getLifeAreas() async {
    final response = await _supabase
        .from('life_areas')
        .select()
        .order('created_at', ascending: true);
    return (response as List).map((e) => LifeArea.fromJson(e)).toList();
  }

  Future<void> createLifeArea(String name, String? description) async {
    final userId = _supabase.auth.currentUser!.id;
    await _supabase.from('life_areas').insert({
      'user_id': userId,
      'name': name,
      'description': description,
    });
  }

  Future<void> deleteLifeArea(String id) async {
    await _supabase.from('life_areas').delete().eq('id', id);
  }

  // Daily Actions
  Future<DailyAction?> getTodayAction(String dateLocal) async {
    final response = await _supabase
        .from('daily_actions')
        .select()
        .eq('date_local', dateLocal)
        .limit(1)
        .maybeSingle();

    if (response != null) {
      return DailyAction.fromJson(response);
    }
    return null;
  }

  Future<List<DailyAction>> getAllActions() async {
    final response = await _supabase
        .from('daily_actions')
        .select()
        .order('date_local', ascending: false);
    return (response as List).map((e) => DailyAction.fromJson(e)).toList();
  }

  Future<void> createDailyAction(
    String actionText,
    String? lifeAreaId,
    String dateLocal,
  ) async {
    final userId = _supabase.auth.currentUser!.id;
    await _supabase.from('daily_actions').insert({
      'user_id': userId,
      'life_area_id': lifeAreaId,
      'action_text': actionText,
      'date_local': dateLocal,
      'completed': false,
    });
  }

  Future<void> completeAction(String id, String? notes) async {
    await _supabase
        .from('daily_actions')
        .update({
          'completed': true,
          'completed_at': DateTime.now().toIso8601String(),
          'notes': notes,
        })
        .eq('id', id);
  }
}
