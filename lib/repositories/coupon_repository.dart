import '../models/coupon_model.dart';

class CouponRepository {
  final List<CouponModel> _coupons = [
    CouponModel(
      id: 'cp_10',
      code: 'WELCOME10',
      discountPercent: 10.0,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      isEnabled: true,
    ),
    CouponModel(
      id: 'cp_20',
      code: 'SAVE20',
      discountPercent: 20.0,
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      isEnabled: true,
    ),
  ];

  Future<List<CouponModel>> getAllCoupons() async {
    return List.from(_coupons);
  }

  Future<CouponModel?> getCouponByCode(String code) async {
    try {
      return _coupons.firstWhere((c) => c.code.toLowerCase() == code.trim().toLowerCase());
    } catch (_) {
      return null;
    }
  }

  Future<void> addCoupon(CouponModel coupon) async {
    _coupons.add(coupon);
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    final index = _coupons.indexWhere((c) => c.id == coupon.id);
    if (index != -1) {
      _coupons[index] = coupon;
    }
  }

  Future<void> toggleCouponStatus(String id, bool isEnabled) async {
    final index = _coupons.indexWhere((c) => c.id == id);
    if (index != -1) {
      _coupons[index] = _coupons[index].copyWith(isEnabled: isEnabled);
    }
  }

  Future<void> deleteCoupon(String id) async {
    _coupons.removeWhere((c) => c.id == id);
  }
}
