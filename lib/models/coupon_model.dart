class CouponModel {
  final String id;
  final String code;
  final double discountPercent;
  final DateTime expiryDate;
  final bool isEnabled;

  const CouponModel({
    required this.id,
    required this.code,
    required this.discountPercent,
    required this.expiryDate,
    this.isEnabled = true,
  });

  bool get isValid => isEnabled && DateTime.now().isBefore(expiryDate);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'discountPercent': discountPercent,
      'expiryDate': expiryDate.toIso8601String(),
      'isEnabled': isEnabled,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map, String id) {
    return CouponModel(
      id: id,
      code: map['code'] as String? ?? '',
      discountPercent: (map['discountPercent'] as num?)?.toDouble() ?? 0.0,
      expiryDate: DateTime.tryParse(map['expiryDate'] as String? ?? '') ?? DateTime.now(),
      isEnabled: map['isEnabled'] as bool? ?? true,
    );
  }

  CouponModel copyWith({
    String? id,
    String? code,
    double? discountPercent,
    DateTime? expiryDate,
    bool? isEnabled,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      discountPercent: discountPercent ?? this.discountPercent,
      expiryDate: expiryDate ?? this.expiryDate,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
