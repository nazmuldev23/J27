import '../models/category_model.dart';

class CategoryRepository {
  final List<CategoryModel> _categories = [
    const CategoryModel(
      id: 'cat_jersey',
      name: 'Jersey',
      imageUrl: '',
      description: 'customize jersey',
    ),
    const CategoryModel(
      id: 'cat_Football_Accessories',
      name: 'Football Accessories',
      imageUrl: '',
      description: 'Football, football boots, shin guards, goalkeeper Gloves, training Cones, football Pump',
    ),
    const CategoryModel(
      id: 'cat_Sports_Clothing',
      name: 'Sports Clothing',
      imageUrl: '',
      description: 'Football shorts, training T-Shirt, goalkeeper pants',
    ),
    // const CategoryModel(
    //   id: 'cat_sports',
    //   name: 'Sports & Outdoors',
    //   imageUrl: '',
    //   description: 'Fitness gear, outdoor clothing, travel, and athletic equipment.',
    // ),
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
