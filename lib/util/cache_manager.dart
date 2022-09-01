/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:30 
 * @Last Modified by:   xusun000 
 * @Last Modified time: 2022-08-03 10:38:30 
 */
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
