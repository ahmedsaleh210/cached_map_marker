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

  
  /// Factory constructor for creating a [_CacheMethod] instance specifically for caching widgets.
  ///
  /// This method facilitates the caching of a widget by rendering it to an image and then storing it using a cache manager. It is particularly useful for dynamic widgets that need to be converted into a static image for caching and later retrieval.
  ///
  /// Parameters:
  /// - [widget]: The [Widget] to be rendered and cached. This is the primary content that will be converted into an image.
  /// - [cacheKey]: A unique string identifier used to store and retrieve the cached image from the cache manager. It ensures that the cached content can be uniquely identified.
  /// - [cacheManager]: An instance of [BaseCacheManager] that handles the storage and retrieval of cached images. It abstracts the underlying caching mechanism.
  /// - [logicalSize] (optional): The size of the widget in logical pixels. This parameter allows specifying the dimensions of the widget before it is rendered. If not provided, the widget's intrinsic size is used.
  /// - [imageSize] (optional): The size of the image to be cached. This can be different from the logical size of the widget. It specifies the dimensions of the resulting image. If not provided, the widget's rendered size is used.
  /// - [waitToRender] (optional): A [Duration] to wait before rendering the widget. This can be useful if the widget requires some time to initialize or if there's a need to delay the rendering process for any reason.
  ///
  /// Returns:
  /// An instance of [_WidgetCacheMethod] configured with the provided parameters. This instance is responsible for the actual process of rendering the widget, converting it to an image, and caching it using the provided cache manager.
  ///
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
