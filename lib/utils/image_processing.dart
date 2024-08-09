part of '../cached_map_marker.dart';

class _ImageProcessing {
  /// Processes the given image bytes to fit specified dimensions.
  ///
  /// This method resizes the image represented by the given bytes to the specified
  /// width and height, and converts it to PNG format.
  ///
  /// Parameters:
  ///   [bytes] The original image bytes.
  ///   [width] The target width for the image.
  ///   [height] The target height for the image.
  ///
  /// Returns:
  ///   A [Future<Uint8List>] that completes with the bytes of the processed image.
  ///
  /// Throws:
  ///   Throws an exception if there is an error in processing the image.
  static Future<Uint8List> preProcessImage(
      Uint8List bytes, int width, int height) async {
    ui.Codec codec = await ui.instantiateImageCodec(bytes,
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
