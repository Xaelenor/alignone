class DailyAction {
  final String id;
  final String userId;
  final String? lifeAreaId;
  final String actionText;
  final String? notes;
  final bool completed;
  final DateTime createdAt;
  final String dateLocal; // YYYY-MM-DD
  final DateTime? completedAt;

  DailyAction({
    required this.id,
    required this.userId,
    this.lifeAreaId,
    required this.actionText,
    this.notes,
    required this.completed,
    required this.createdAt,
    required this.dateLocal,
    this.completedAt,
  });

  factory DailyAction.fromJson(Map<String, dynamic> json) {
    return DailyAction(
      id: json['id'],
      userId: json['user_id'],
      lifeAreaId: json['life_area_id'],
      actionText: json['action_text'],
      notes: json['notes'],
      completed: json['completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      dateLocal: json['date_local'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'life_area_id': lifeAreaId,
      'action_text': actionText,
      'notes': notes,
      'completed': completed,
      'created_at': createdAt.toIso8601String(),
      'date_local': dateLocal,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
