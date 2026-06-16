# flutter_image_hash

[![Pub Version](https://img.shields.io/pub/v/flutter_image_hash?logo=dart)](https://pub.dev/packages/flutter_image_hash)
[![Likes](https://img.shields.io/pub/likes/flutter_image_hash)](https://pub.dev/packages/flutter_image_hash)
[![License](https://img.shields.io/github/license/Bhaumik0248/flutter_image_hash)](https://github.com/Bhaumik0248/flutter_image_hash/blob/master/LICENSE)

A production-grade, highly customizable Flutter package for progressive, blurry image loading. Seamlessly display immediate visual placeholders while high-definition network images load, then crossfade to them.

Ideal for building progressive and elegant image loading animations with minimal footprint.

<p align="center">
  <img src="https://raw.githubusercontent.com/Bhaumik0248/flutter_image_hash/master/assets/flutter_blur_hash.gif" alt="flutter_image_hash Demo" width="100%" />
</p>

## Features

- **Pure Dart Algorithm**: Implements the BlurHash decoding algorithm natively in Dart. No platform channel overhead.
- **Three Placeholder Strategies**:
  - **Automatic Blurry Placeholder (Recommended)**: Simply pass an `imageUrl`. If it is a resizable network URL (e.g. from Dreamstime, Unsplash, Cloudinary), `ImageHash` automatically extracts and loads a blurred 20px thumbnail dynamically.
  - **Blurred Thumbnail URL**: Manually fetch and blur a low-resolution thumbnail URL of your choice.
  - **On-Device BlurHash**: Instant rendering of a compact base83 BlurHash string with zero network overhead.
- **Rich Styling & Decoration**: Directly pass a `decoration` (e.g., rounded corners, custom borders, shadows) in parameters. The image automatically clips to your corners.
- **Customizable Transition**: Control the crossfade duration, transition animation curve, and blur strength.
- **Easy-to-use Widget**: Drop-in `ImageHash` widget to manage progressive loading.

## Getting started

Add `flutter_image_hash` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_image_hash:
    path: /path/to/package/or/version
```

## Usage

Import the package in your Dart code:

```dart
import 'package:flutter_image_hash/flutter_image_hash.dart';
```

### 1. Automatic Blurry Placeholders (No Hash Required - Recommended)
The simplest way to display progressive blurry images. Just pass the resizable `imageUrl`. The widget automatically extracts the width parameter, downloads a tiny 20px placeholder, blurs it, and crossfades:

```dart
ImageHash(
  imageUrl: "https://example.com/image.jpg?w=992",     // HD main image URL
  blurSigma: 10.0,                                    // Blur intensity
  width: double.infinity,
  height: 250,
  fit: BoxFit.cover,
  fadeDuration: const Duration(seconds: 1),           // Crossfade animation duration
)
```

### 2. On-Device BlurHash Placeholder
Use this for instant, network-free placeholders. Pass the pre-computed BlurHash string of the image:

```dart
ImageHash(
  hash: "UYReRC$%?]NHx]WVV?s:%yR+Myt6jDs.b0NH",        // Decoded on-device instantly
  imageUrl: "https://example.com/image.jpg?w=992",     // HD main image URL
  width: double.infinity,
  height: 250,
  fit: BoxFit.cover,
)
```

### 3. Custom Low-Res Thumbnail (Manual Thumbnail URL)
If you have custom URLs for your thumbnails, pass the low-resolution thumbnail URL manually:

```dart
ImageHash(
  thumbnailUrl: "https://example.com/image_small.jpg", // Custom low-res thumbnail URL
  imageUrl: "https://example.com/image_hd.jpg",        // HD main image URL
  blurSigma: 12.0,
  width: double.infinity,
  height: 250,
  fit: BoxFit.cover,
)
```

### 4. Custom Corner Rounding, Borders, and Styling
Pass a `BoxDecoration` directly to shape the container with rounded corners and drop shadows. The progressive images are automatically clipped to the bounds:

```dart
ImageHash(
  imageUrl: "https://example.com/image.jpg?w=992",
  width: 300,
  height: 200,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.blueAccent, width: 2),
    boxShadow: [
      BoxShadow(
        color: Colors.black26, 
        blurRadius: 10, 
        offset: Offset(0, 5),
      ),
    ],
  ),
)
```

---

## Configuration Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `imageUrl` | `String?` | `null` | The URL of the high-definition main image. If provided, `ImageHash` will load and crossfade to it. |
| `hash` | `String?` | `null` | The BlurHash string. Used as placeholder if provided. |
| `thumbnailUrl` | `String?` | `null` | The URL of a custom low-resolution thumbnail placeholder. |
| `blurSigma` | `double` | `10.0` | The blur strength (standard deviation) applied to the thumbnail placeholder. |
| `decoration` | `Decoration?` | `null` | Styling decoration (borders, borders radius, shadows) to style and clip the image widget. |
| `fallbackPlaceholder` | `Widget?` | `null` | A fallback widget to render if no placeholders can be dynamically resolved. |
| `width` | `double?` | `null` | Target width of the image. |
| `height` | `double?` | `null` | Target height of the image. |
| `fit` | `BoxFit` | `BoxFit.cover` | How to fit the image inside the dimensions. |
| `fadeDuration` | `Duration` | `500ms` | Duration of the crossfade transition. |
| `fadeCurve` | `Curve` | `Curves.easeOut` | Animation curve of the crossfade. |

---

## Author

Developed and maintained by **Bhaumik Gandhi** ([GitHub](https://github.com/Bhaumik0248)).
