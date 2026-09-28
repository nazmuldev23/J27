class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role; // 'customer' or 'admin'
  final String address;
  final String accountStatus; // 'active' or 'disabled'

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'customer',
    this.address = '',
    this.accountStatus = 'active',
  });

  bool get isAdmin => role == 'admin';
  bool get isActive => accountStatus == 'active';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'accountStatus': accountStatus,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String? ?? 'customer',
      address: map['address'] as String? ?? '',
      accountStatus: map['accountStatus'] as String? ?? 'active',
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? address,
    String? accountStatus,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      address: address ?? this.address,
      accountStatus: accountStatus ?? this.accountStatus,
    );
  }
}
