import 'package:cached_custom_marker/cached_custom_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached Custom Marker Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const GoogleMapView(),
              ),
            );
          },
          child: const Text('Go to Google Map View'),
        ),
      ),
    );
  }
}

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  Set<Marker> markers = {};
  late CachedCustomMarker _cachedCustomMarker;

  @override
  void initState() {
    _cachedCustomMarker = CachedCustomMarker();
    _initMarkers();
    super.initState();
  }

  void _initMarkers() async {
    late Marker networkMarker;
    late Marker bytesMarker;
    final futures = await Future.wait([
      _cachedCustomMarker.fromNetwork(
          url: 'https://cdn-icons-png.flaticon.com/512/5193/5193688.png',
          size: const Size(60, 60)),
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
        cacheKey: 'bytes_marker',
        logicalSize: const Size(250, 250),
        imageSize: const Size(100, 100),
      )
    ]);
    networkMarker = Marker(
        markerId: const MarkerId('network_marker_id'),
        position: const LatLng(37.77483, -122.41942),
        icon: futures[0]);

    bytesMarker = Marker(
        markerId: const MarkerId('bytes_marker_id'),
        position: const LatLng(37.734921595128405, -122.43419039994477),
        icon: futures[1]);
    setState(() {
      markers.addAll([networkMarker, bytesMarker]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached Custom Marker Demo'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.77483, -122.41942),
          zoom: 12,
        ),
        markers: markers,
      ),
    );
  }
}
