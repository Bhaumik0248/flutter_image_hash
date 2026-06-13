# flutter_image_hash Example

A production-grade demonstration of the `flutter_image_hash` package, showcasing progressive blurry image loading in a premium social-media style feed (similar to WordPress and Instagram).

## Features Demonstrated

1. **WordPress-Style Card**: Dynamically extracts width parameters from a resizable image URL, fetches a tiny 20px thumbnail placeholder, blurs it, and crossfades to the HD image after loading.
2. **Instagram-Style Card**: Decodes a pre-computed BlurHash string instantly on-device, then crossfades into the HD image.
3. **Double-Tap Interaction**: Try double-tapping on any image card to trigger a premium animated like-overlay and pulse effect.
4. **Reload Action**: Click the floating action button to clear Flutter's image cache and reload the images to inspect the blurry transitions again.

## Running the Example

Navigate to the `example` directory and run:

```bash
flutter run
```

Or for web:

```bash
flutter run -d chrome
```
