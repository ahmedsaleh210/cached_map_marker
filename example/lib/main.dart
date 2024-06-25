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

  @override
  void initState() {
    _initMarkers();
    super.initState();
  }

  void _initMarkers() async {
    final marker = Marker(
        markerId: const MarkerId('marker_id'),
        position: const LatLng(37.77483, -122.41942),
        icon: await CachedCustomMarker().fromNetwork(
            url: 'https://cdn-icons-png.flaticon.com/512/5193/5193688.png',
            width: 60,
            height: 60));
    setState(() {
      markers.add(marker);
    });
    // CachedCustomMarker().clearCache();
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
