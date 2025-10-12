class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final int credits;
  final double totalDonated;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.credits = 0,
    this.totalDonated = 0.0,
    required this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'credits': credits,
      'totalDonated': totalDonated,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      credits: map['credits'] ?? 0,
      totalDonated: (map['totalDonated'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Copy with method for updating
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    int? credits,
    double? totalDonated,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      credits: credits ?? this.credits,
      totalDonated: totalDonated ?? this.totalDonated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
