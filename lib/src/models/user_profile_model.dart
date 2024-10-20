class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String? googleSignInInfo;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.googleSignInInfo,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });



  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'googleSignInInfo': googleSignInInfo,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  factory UserProfile.fromMap(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      googleSignInInfo: json['googleSignInInfo'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
