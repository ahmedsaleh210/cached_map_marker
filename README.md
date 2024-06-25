# Cached Custom Marker

A Flutter package designed to efficiently manage and cache custom markers for maps. This package allows you to download and cache images from the network, converting them into `BitmapDescriptor` objects for use as map markers. It also provides functionality to clear the cached images, ensuring that your application can manage storage effectively.

## Features

- **Download and Cache**: Automatically downloads and caches images for use as map markers, reducing network requests and improving performance.
- **Custom Marker Size**: Allows specifying the size of the marker images, enabling customization according to your application's needs.
- **Cache Management**: Provides a method to clear the cache, helping manage the device's storage and ensuring the latest images are used.

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

### Creating a Custom Marker from a Network Image
```dart
BitmapDescriptor marker = await CachedCustomMarker.fromNetwork(
  url: 'https://example.com/image.png',
  width: 100,
  height: 100,
);
```

### Contributing
Contributions are welcome! Please feel free to submit a pull request.

### License
This package is licensed under the MIT License. See the LICENSE file for details.
