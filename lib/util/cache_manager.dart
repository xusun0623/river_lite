import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class RiverListCacheManager {
  static CacheManager instance = CacheManager(
    Config(
      'riverListCacheKey',
      stalePeriod: Duration(days: 5), //缓存5天
      maxNrOfCacheObjects: 100,
    ),
  );
}
