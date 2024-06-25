library cached_custom_marker;

import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CachedCustomMarker {
  late final BaseCacheManager _instance;

  CachedCustomMarker({BaseCacheManager? cacheManager})
      : _instance = cacheManager ?? DefaultCacheManager();

  /// Retrieves a file from cache or downloads it if not available.
  ///
  /// This function first attempts to retrieve the file from memory cache,
  /// then from disk cache, and as a last resort, downloads it from the network.
  /// Downloaded files are processed and stored in cache for future use.
  ///
  /// [url] The URL of the file to retrieve.
  ///
  /// Returns a [Future<File>] that completes with the file once it's available.
  ///
  Future<File> _getFileFromCache(
      {required String url, required int width, required int height}) async {
    try {
      final cacheKey = _extractCacheKey(url, width, height);
      File? file = await _getFileFromMemoryCache(cacheKey);
      file ??= await _getFileFromDiskCache(cacheKey);
      file ??= await _downloadAndCacheFile(
          url: url, cacheKey: cacheKey, width: width, height: height);
      return file;
    } catch (e) {
      rethrow;
    }
  }

  /// Extracts the cache key from the URL by removing query parameters with adding width and height.
  String _extractCacheKey(String url, int width, int height) =>
      '${url.split('?').first}-$width-$height';

  /// Attempts to retrieve the file from memory cache.
  Future<File?> _getFileFromMemoryCache(String cacheKey) async {
    final file = (await _instance.getFileFromMemory(cacheKey))?.file;
    if (file != null) {
      log('Cached Marker Logger: File retrieved from memory cache.');
    }
    return file;
  }

  /// Attempts to retrieve the file from disk cache.
  Future<File?> _getFileFromDiskCache(String cacheKey) async {
    final file = (await _instance.getFileFromCache(cacheKey))?.file;
    if (file != null) {
      log('Cached Marker Logger: File retrieved from disk cache.');
    }
    return file;
  }

  /// Downloads the file from the network, processes it, and caches it.
  Future<File> _downloadAndCacheFile(
      {required String url,
      required String cacheKey,
      required int width,
      required int height}) async {
    final rawBytes = await _downloadFileBytes(url);
    final processedBytes = await _preProcessImage(rawBytes, width, height);
    log('Cached Marker Logger: File downloaded and processed.');
    return await _instance.putFile(cacheKey, processedBytes);
  }

  /// Downloads the file from the network and returns its bytes.
  Future<Uint8List> _downloadFileBytes(String url) async {
    final response = await NetworkAssetBundle(Uri.parse(url)).load(url);
    return response.buffer.asUint8List();
  }

  Future<Uint8List> _preProcessImage(
      Uint8List bytes, int width, int height) async {
    ui.Codec codec = await ui.instantiateImageCodec(bytes,
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> fromNetwork(
      {required String url,
      Map<String, String>? headers,
      int width = 150,
      int height = 150}) async {
    final file =
        await _getFileFromCache(url: url, height: height, width: width);
    final bytes = await file.readAsBytes();
    final descriptor = BitmapDescriptor.bytes(bytes);
    await Future.delayed(const Duration(milliseconds: 30), () {});
    return descriptor;
  }

  Future<void> clearCache() async {
    await _instance.emptyCache();
    log('Cached Marker Logger: Cache cleared.');
  }
}
