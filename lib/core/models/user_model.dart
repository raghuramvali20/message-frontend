class User {
  final String id;
  final String userName;
  final String email;
  final dynamic blockedUsers;
  final String profilePic = " ";

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.blockedUsers,
  });

  // Return a Map for Hive
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'blockedUsers': blockedUsers,
    };
  }

  // Factory accepts Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"] ?? json["id"] ?? "",
      userName: json['userName'],
      email: json['email'],
      blockedUsers: json['blockedUsers'] ?? [],
    );
  }
}
