import '../models/user_model.dart';

class CustomerRepository {
  final List<UserModel> _customers = [
    const UserModel(
      id: 'cust_1',
      name: 'Customer User',
      email: 'customer@example.com',
      phone: '+1234567890',
      role: 'customer',
      address: '123 Main Street',
      accountStatus: 'active',
    ),
    const UserModel(
      id: 'cust_2',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1987654321',
      role: 'customer',
      address: '456 Oak Avenue',
      accountStatus: 'active',
    ),
    const UserModel(
      id: 'cust_3',
      name: 'Alice Smith',
      email: 'alice@example.com',
      phone: '+1122334455',
      role: 'customer',
      address: '789 Pine Road',
      accountStatus: 'disabled',
    ),
  ];

  Future<List<UserModel>> getAllCustomers() async {
    return List.from(_customers);
  }

  Future<UserModel?> getCustomerById(String id) async {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateCustomerStatus(String id, String status) async {
    final index = _customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      _customers[index] = _customers[index].copyWith(accountStatus: status);
    }
  }
}
