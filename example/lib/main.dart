import 'package:flutter/material.dart';
import 'package:flutter_image_hash/flutter_image_hash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_image_hash Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1015),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const DemoFeedPage(),
    );
  }
}

class DemoFeedPage extends StatefulWidget {
  const DemoFeedPage({super.key});

  @override
  State<DemoFeedPage> createState() => _DemoFeedPageState();
}

class _DemoFeedPageState extends State<DemoFeedPage> {
  Key _feedKey = UniqueKey();

  void _reloadImages() {
    setState(() {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      _feedKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    const String hdImageUrl =
        "https://thumbs.dreamstime.com/b/sample-jpeg-single-delectable-pink-glazed-donut-adorned-vibrant-rainbow-sprinkles-358283561.jpg?w=992";
    const String blurHash = r"UYReRC$%?]NHx]WVV?s:%yR+Myt6jDs.b0NH";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ImageHash UX Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Clear cache & reload',
            onPressed: _reloadImages,
          ),
        ],
      ),
      body: ListView(
        key: _feedKey,
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Progressive Blurry Image Loading",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Clear cache using the refresh button to see the smooth blurry transition (3-second duration).",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Card 1: Automatic Blurry Placeholder
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageHash(
                  imageUrl: hdImageUrl,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  blurSigma: 12.0,
                  fadeDuration: const Duration(seconds: 3),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Automatic Placeholder URL Generation",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Only the main imageUrl is passed. The package parses query parameters to fetch a 20px thumbnail dynamically, applies a blur effect, and crossfades to the HD image.",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Card 2: BlurHash Decoded On-Device
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageHash(
                  hash: blurHash,
                  imageUrl: hdImageUrl,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  fadeDuration: const Duration(seconds: 3),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "On-Device BlurHash Decoding",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Uses a compact BlurHash string decoded on-device for an instant, zero-network placeholder before fading in the network image.",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
