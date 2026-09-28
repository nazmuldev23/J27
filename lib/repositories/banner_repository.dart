import '../models/banner_model.dart';

class BannerRepository {
  final List<BannerModel> _banners = [
    const BannerModel(
      id: 'b1',
      title: 'Summer Tech Sale - Up to 40% OFF',
      imageUrl: '',
      targetCategoryOrProduct: 'cat_electronics',
      isActive: true,
    ),
    const BannerModel(
      id: 'b2',
      title: 'Exclusive Fashion Collection',
      imageUrl: '',
      targetCategoryOrProduct: 'cat_fashion',
      isActive: true,
    ),
  ];

  Future<List<BannerModel>> getAllBanners() async {
    return List.from(_banners);
  }

  Future<List<BannerModel>> getActiveBanners() async {
    return _banners.where((b) => b.isActive).toList();
  }

  Future<void> addBanner(BannerModel banner) async {
    _banners.add(banner);
  }

  Future<void> updateBanner(BannerModel banner) async {
    final index = _banners.indexWhere((b) => b.id == banner.id);
    if (index != -1) {
      _banners[index] = banner;
    }
  }

  Future<void> deleteBanner(String id) async {
    _banners.removeWhere((b) => b.id == id);
  }
}
