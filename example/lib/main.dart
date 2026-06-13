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
      title: 'InstaBlur Progressive Feed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0E12),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF4B8D),
          secondary: Color(0xFFFF814A),
          surface: Color(0xFF16181F),
          background: Color(0xFF0D0E12),
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF16181F),
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ),
      home: const FeedPage(),
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Key _feedKey = UniqueKey();

  void _refreshFeed() {
    setState(() {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      _feedKey = UniqueKey();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image cache cleared! Reloading feed...'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        key: _feedKey,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFF0D0E12).withOpacity(0.9),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'InstaBlur Feed',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D0E12), Color(0xFF16181F)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: _refreshFeed,
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "Progressive Blurry Loading Demo",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Card 1: WordPress Style Post (Using low-res blurred thumbnail)
              const WordPressPostCard(),
              // Card 2: Instagram Style Post (Using BlurHash)
              const InstagramPostCard(),
              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF4B8D), Color(0xFFFF814A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4B8D).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _refreshFeed,
          label: const Text(
            'Reload Images',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.bolt_rounded),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}

class WordPressPostCard extends StatelessWidget {
  const WordPressPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    const String hdImageUrl =
        "https://thumbs.dreamstime.com/b/sample-jpeg-single-delectable-pink-glazed-donut-adorned-vibrant-rainbow-sprinkles-358283561.jpg?w=992";

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const PostHeader(
            authorName: "WordPress Traveler",
            authorAvatar: "WT",
            location: "WordPress Blog Network",
            avatarColor: Colors.blueAccent,
          ),
          // Image loading
          const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: ImageHash(
                imageUrl: hdImageUrl,
                blurSigma: 12.0,
                fit: BoxFit.cover,
                fadeDuration: Duration(seconds: 3),
              ),
            ),
          ),
          // Actions and Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Method: Automatic Blurry Placeholder (Auto-extracted w=20)",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "A Sweet Glazed Donut Journey 🍩",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Look at this delectable pink glazed donut covered in rainbow sprinkles! Loaded progressively by automatically parsing the imageUrl, generating a 20px thumbnail, blurring it, and fading to the HD image. Zero manual hashes or placeholders passed by the developer!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "June 13, 2026",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined, size: 16),
                      label: const Text("4 comments"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InstagramPostCard extends StatefulWidget {
  const InstagramPostCard({super.key});

  @override
  State<InstagramPostCard> createState() => _InstagramPostCardState();
}

class _InstagramPostCardState extends State<InstagramPostCard> with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  late AnimationController _likeController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(_likeController);
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    _likeController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    const String hdImageUrl =
        "https://thumbs.dreamstime.com/b/sample-jpeg-single-delectable-pink-glazed-donut-adorned-vibrant-rainbow-sprinkles-358283561.jpg?w=992";
    const String blurHash = r"UYReRC$%?]NHx]WVV?s:%yR+Myt6jDs.b0NH";

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const PostHeader(
            authorName: "donut_lover_99",
            authorAvatar: "DL",
            location: "Glazed & Confused",
            avatarColor: Colors.pinkAccent,
          ),
          // Image Loading
          GestureDetector(
            onDoubleTap: _toggleLike,
            child: const SizedBox(
              height: 350,
              width: double.infinity,
              child: ImageHash(
                hash: blurHash,
                imageUrl: hdImageUrl,
                fit: BoxFit.cover,
                fadeDuration: Duration(seconds: 3),
              ),
            ),
          ),
          // Interaction Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _isLiked ? Colors.red : Colors.white,
                    ),
                    onPressed: _toggleLike,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_border_rounded),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Details and Description
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Method: BlurHash Decoded On-Device",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _isLiked ? "1,249 likes" : "1,248 likes",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.3),
                    children: const [
                      TextSpan(
                        text: "donut_lover_99 ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "Can we appreciate how perfect this glazed donut is? ✨ Loaded progressively using the raw BlurHash string decoded on-device. Instant, lightweight, and zero network calls for the placeholder!",
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

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }
}

class PostHeader extends StatelessWidget {
  final String authorName;
  final String authorAvatar;
  final String location;
  final Color avatarColor;

  const PostHeader({
    super.key,
    required this.authorName,
    required this.authorAvatar,
    required this.location,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            child: Text(
              authorAvatar,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
