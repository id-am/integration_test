class ProfileModel {
  final String userId;
  final String email;
  final String name;

  ProfileModel({required this.userId, required this.email, required this.name});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'email': email, 'name': name};
  }
}
