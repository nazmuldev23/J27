class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }
}
