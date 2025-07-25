import 'package:cached_network_image/cached_network_image.dart' as lib;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:offer_show/global_key/app.dart';
import 'package:offer_show/util/mid_request.dart';

getHeadersWithVpn(Map<String, String>? inputHeaders) {
  var httpHeaders = inputHeaders;
  if (vpnEnabled && vpnCookie.isNotEmpty) {
    final cookieHeader = '${vpn_cookie_name}=${vpnCookie}';
    if (httpHeaders == null) {
      httpHeaders = {'Cookie': cookieHeader};
    } else {
      httpHeaders = {...inputHeaders!};
      if (httpHeaders.containsKey("Cookie") && httpHeaders["Cookie"]?.isNotEmpty == true) {
        httpHeaders['Cookie'] = (httpHeaders['Cookie'] ?? '') + '; ${cookieHeader}';
      } else {
        httpHeaders['Cookie'] = cookieHeader;
      }
    }
  }
  return httpHeaders;
}

class CachedNetworkImage extends StatelessWidget {
  static Future<bool> evictFromCache(
    String url, {
    String? cacheKey,
    BaseCacheManager? cacheManager,
    double scale = 1,
  }) {
    return lib.CachedNetworkImage.evictFromCache(url, cacheKey: cacheKey, cacheManager: cacheManager, scale: scale);
  }

  final String imageUrl;
  final BaseCacheManager? cacheManager;
  final String? cacheKey;
  final lib.ImageWidgetBuilder? imageBuilder;
  final lib.PlaceholderWidgetBuilder? placeholder;
  final lib.ProgressIndicatorBuilder? progressIndicatorBuilder;
  final lib.LoadingErrorWidgetBuilder? errorWidget;
  final Duration? placeholderFadeInDuration;
  final Duration? fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final Map<String, String>? httpHeaders;
  final bool useOldImageOnUrlChange;
  final Color? color;
  final BlendMode? colorBlendMode;
  final FilterQuality filterQuality;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final ValueChanged<Object>? errorListener;

  CachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.cacheManager,
    this.httpHeaders,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.errorListener});

  @override
  Widget build(BuildContext context) {
    return lib.CachedNetworkImage(imageUrl: rebaseUrlSync(imageUrl),
      httpHeaders: getHeadersWithVpn(this.httpHeaders),
      imageBuilder: this.imageBuilder,
      placeholder: this.placeholder,
      progressIndicatorBuilder: this.progressIndicatorBuilder,
      errorWidget: this.errorWidget,
      fadeOutDuration: this.fadeOutDuration,
      fadeOutCurve: this.fadeOutCurve,
      fadeInDuration: this.fadeInDuration,
      fadeInCurve: this.fadeInCurve,
      width: this.width,
      height: this.height,
      fit: this.fit,
      alignment: this.alignment,
      repeat: this.repeat,
      matchTextDirection: this.matchTextDirection,
      useOldImageOnUrlChange: this.useOldImageOnUrlChange,
      color: this.color,
      filterQuality: this.filterQuality,
      colorBlendMode: this.colorBlendMode,
      placeholderFadeInDuration: this.placeholderFadeInDuration,
      memCacheWidth: this.memCacheWidth,
      memCacheHeight: this.memCacheHeight,
      cacheKey: this.cacheKey,
      maxWidthDiskCache: this.maxWidthDiskCache,
      maxHeightDiskCache: this.maxHeightDiskCache,
      errorListener: this.errorListener);
  }
}

@immutable
class CachedNetworkImageProvider
    extends lib.CachedNetworkImageProvider {
  CachedNetworkImageProvider(
    String url, {
    super.maxHeight,
    super.maxWidth,
    super.scale = 1.0,
    super.errorListener,
    Map<String, String>? headers,
    super.cacheManager,
    super.cacheKey,
  }) : super(rebaseUrlSync(url), headers: getHeadersWithVpn(headers));
    }