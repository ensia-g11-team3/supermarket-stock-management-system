class User {
  int? id;
  String username;
  String fullName;
  String email;
  String phone;
  String role;
  bool isActive;
  String createdAt;
  String password;

  User({
    this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
        username: json['username'] ?? '',
        fullName: json['full_name'] ?? json['fullName'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        role: json['role'] ?? '',
        isActive: json['is_active'] == true || json['is_active'] == 1,
        createdAt: json['created_at'] ?? json['createdAt'] ?? '',
        password: json['password'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'username': username,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'role': role,
        'is_active': isActive,
        'created_at': createdAt,
        'password': password,
      };
}
