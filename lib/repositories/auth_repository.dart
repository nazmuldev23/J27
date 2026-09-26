import '../models/user_model.dart';

class AuthRepository {
  UserModel? _currentUser = const UserModel(
    id: 'cust_1',
    name: 'Customer User',
    email: 'customer@example.com',
    phone: '+1234567890',
    role: 'customer',
    address: '123 Main Street, Tech City',
  );

  UserModel? get currentUser => _currentUser;

  Future<UserModel> login(String email, String password) async {
    if (email.contains('admin')) {
      _currentUser = UserModel(
        id: 'admin_1',
        name: 'Admin Manager',
        email: email,
        phone: '+1987654321',
        role: 'admin',
        address: 'HQ Tower, Suite 100',
      );
    } else {
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
        phone: '+1234567890',
        role: 'customer',
        address: '123 Main Street',
      );
    }
    return _currentUser!;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String address = '',
    String role = 'customer',
  }) async {
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      address: address,
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  Future<void> sendForgotPasswordEmail(String email) async {
    // Reset password
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    _currentUser = updatedUser;
  }
}
