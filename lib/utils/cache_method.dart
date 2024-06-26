part of '../cached_custom_marker.dart';

/// Defines an abstract interface for caching mechanisms.
abstract interface class _CacheMethod {
  /// Abstract method to cache data and return a [File].
  Future<File> cache();

  /// Factory constructor to create a [_CacheMethod] instance for network resources.
  ///
  /// Requires [url] of the resource, [cacheKey] for identifying the cached file,
  /// dimensions [width] and [height] for image processing, and a [cacheManager] for caching.
  factory _CacheMethod.network({
    required String url,
    required String cacheKey,
    required int width,
    required int height,
    required BaseCacheManager cacheManager,
  }) {
    return _NetworkCacheMethod(
        url: url,
        cacheKey: cacheKey,
        width: width,
        height: height,
        cacheManager: cacheManager);
  }

  /// Factory constructor to create a [_CacheMethod] instance for widget data.
  ///
  /// Requires [widget] as the data to cache, [cacheKey] for identifying the cached file,
  factory _CacheMethod.widget(
      {required Widget widget,
      required String cacheKey,
      required BaseCacheManager cacheManager,
      Size? logicalSize,
      Size? imageSize,
      Duration? waitToRender}) {
    return _WidgetCacheMethod(
        widget: widget,
        cacheKey: cacheKey,
        cacheManager: cacheManager,
        waitToRender: waitToRender,
        imageSize: imageSize,
        logicalSize: logicalSize);
  }
}

/// Implements [_CacheMethod] for caching network resources.
class _NetworkCacheMethod implements _CacheMethod {
  final String url;
  final String cacheKey;
  final int width;
  final int height;
  final BaseCacheManager cacheManager;

  /// Constructor for [_NetworkCacheMethod] with required parameters for caching.
  _NetworkCacheMethod(
      {required this.url,
      required this.cacheKey,
      required this.width,
      required this.height,
      required this.cacheManager});

  /// Caches the network resource specified by [url] using the provided [cacheManager].
  /// Processes the image to the specified [width] and [height] before caching.
  @override
  Future<File> cache() async {
    final rawBytes = await _downloadFileBytes(url);
    final processedBytes =
        await _ImageProcessing.preProcessImage(rawBytes, width, height);
    log('Cached Marker Logger: File downloaded and processed');
    return await cacheManager.putFile(cacheKey, processedBytes);
  }

  /// Downloads the file bytes from the given [url].
  Future<Uint8List> _downloadFileBytes(String url) async {
    final response = await NetworkAssetBundle(Uri.parse(url)).load(url);
    return response.buffer.asUint8List();
  }
}

/// Implements [_CacheMethod] for caching widget data.
class _WidgetCacheMethod implements _CacheMethod {
  final Widget widget;
  final String cacheKey;
  final BaseCacheManager cacheManager;
  final Duration? waitToRender;
  Size? logicalSize;
  Size? imageSize;

  /// Constructor for [_WidgetCacheMethod] with required parameters for caching.
  _WidgetCacheMethod(
      {required this.widget,
      required this.cacheKey,
      required this.cacheManager,
      this.waitToRender,
      this.logicalSize,
      this.imageSize});

  /// Caches the widget image using the provided [cacheManager].
  @override
  Future<File> cache() async {
    final processedBytes = await _createImageFromWidget(widget,
        waitToRender: waitToRender ?? const Duration(milliseconds: 500),
        logicalSize: logicalSize,
        imageSize: imageSize);
    log('Cached Marker Logger: Bytes processed and cached.');
    return await cacheManager.putFile(cacheKey, processedBytes);
  }
}
