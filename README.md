# Cached Custom Marker

A flutter ackage provides a Flutter library designed to simplify the process of caching custom markers for Google Maps in Flutter applications. It leverages the flutter_cache_manager package to cache images and widgets, allowing for efficient retrieval and use of custom markers on the map. This package addresses common challenges in managing marker resources by offering functionalities to:

1. **Cache Network Images:** Download and cache images from the network, resizing them as needed for use as map markers.
2. **Cache Widgets as Images:**  Render Flutter widgets to images, cache these images, and use them as custom markers. This is particularly useful for dynamic content that needs to be displayed on the map.
3. **Efficient Resource Management:** Provides methods to clear the cache, ensuring that the application manages resources efficiently and avoids unnecessary storage usage.

[![pub package](https://img.shields.io/pub/v/cached_custom_marker.svg)](https://pub.dev/packages/cached_custom_marker)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Download and Cache**: Automatically downloads and caches images for use as map markers, reducing network requests and improving performance.
- **Custom Marker Size**: Allows specifying the size of the marker images, enabling customization according to your application's needs.
- **Cache Management**: Provides a method to clear the cache, helping manage the device's storage and ensuring the latest images are used.
- **Easy integration**: with Google Maps Flutter through BitmapDescriptor objects

## Getting Started

To use the Cached Custom Marker package in your Flutter project, follow these steps:

### Installation
1. Add the following to your `pubspec.yaml` file:
```yaml
dependencies:
  cached_custom_marker: <lastest>
```

Import the package
```dart
import 'package:cached_custom_marker/cached_custom_marker.dart';
```

### Creating a Custom Marker from Widget & Network Image, then caching it
```dart
final _cachedCustomMarker = CachedCustomMarker();
final markers = await Future.wait([
      // Create a custom marker from a network image and cache it
      _cachedCustomMarker.fromNetwork(
          url: 'https://cdn-icons-png.flaticon.com/512/5193/5193688.png',
          size: const Size(60, 60)),
      // Create a custom marker from a widget and cache it
  _cachedCustomMarker.fromWidget(
        widget: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 50,
        ),
      ),
    cacheKey: 'widget_marker',
    logicalSize: const Size(250, 250),
    imageSize: const Size(100, 100),
    )
]);
```

### Contributing
Contributions are welcome! Please feel free to submit a pull request.

### License
This package is licensed under the MIT License. See the LICENSE file for details.
