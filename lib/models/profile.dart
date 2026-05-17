class Profile {
  final String id;
  final String? username;
  final String? fullName;
  final String? avatarUrl;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
