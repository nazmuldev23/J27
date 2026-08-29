import '../models/category_model.dart';

class CategoryRepository {
  final List<CategoryModel> _categories = [
    const CategoryModel(
      id: 'cat_electronics',
      name: 'Electronics',
      imageUrl: '',
      description: 'Gadgets, audio devices, smart wearables & peripherals.',
    ),
    const CategoryModel(
      id: 'cat_fashion',
      name: 'Fashion & Apparel',
      imageUrl: '',
      description: 'Clothing, footwear, bags, and lifestyle accessories.',
    ),
    const CategoryModel(
      id: 'cat_home',
      name: 'Home & Kitchen',
      imageUrl: '',
      description: 'Kitchenware, home decor, appliances, and living space essentials.',
    ),
    const CategoryModel(
      id: 'cat_sports',
      name: 'Sports & Outdoors',
      imageUrl: '',
      description: 'Fitness gear, outdoor clothing, travel, and athletic equipment.',
    ),
  ];

  Future<List<CategoryModel>> getAllCategories() async {
    return List.from(_categories);
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    _categories.add(category);
  }

  Future<void> updateCategory(CategoryModel category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }
  }

  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
  }
}
