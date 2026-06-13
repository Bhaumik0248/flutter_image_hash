import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'blurhash_core.dart';

/// A widget that displays a placeholder from a BlurHash string or a blurred thumbnail.
/// It can also load a network image and seamlessly crossfade to it once loaded.
class ImageHash extends StatefulWidget {
  /// The BlurHash string. Optional if [thumbnailUrl] or a resizable [imageUrl] is provided.
  final String? hash;

  /// Optional network image URL. If provided, the widget will load this image
  /// and fade from the blurry placeholder (BlurHash or blurred thumbnail) to the loaded image.
  final String? imageUrl;

  /// Optional thumbnail image URL.
  /// If provided, this image will be loaded and blurred (using a blur filter)
  /// to serve as a placeholder while [imageUrl] is loading.
  /// If null, and [imageUrl] is resizable (e.g. has w=... or width=...), a thumbnail URL is auto-generated.
  final String? thumbnailUrl;

  /// The blur sigma value for the [thumbnailUrl] placeholder.
  /// Defaults to 10.0.
  final double blurSigma;

  /// A widget to show as a fallback placeholder if no [hash], [thumbnailUrl],
  /// or auto-generated thumbnail can be loaded.
  /// If null, a subtle dark container is used.
  final Widget? fallbackPlaceholder;

  /// Optional styling decoration (e.g., border, border radius, shadow) to apply to the widget container.
  final Decoration? decoration;

  /// Width of the image.
  final double? width;

  /// Height of the image.
  final double? height;

  /// How to fit the image into the space.
  final BoxFit fit;

  /// Duration of the crossfade animation when [imageUrl] loads.
  final Duration fadeDuration;

  /// The curve of the crossfade animation.
  final Curve fadeCurve;

  /// The internal decoding width for the BlurHash.
  /// Lower values are faster but less detailed. Default is 32.
  final int decodingWidth;

  /// The internal decoding height for the BlurHash.
  /// Lower values are faster but less detailed. Default is 32.
  final int decodingHeight;

  /// A parameter that controls the contrast of the decoded image.
  final double punch;

  const ImageHash({
    super.key,
    this.hash,
    this.imageUrl,
    this.thumbnailUrl,
    this.blurSigma = 10.0,
    this.fallbackPlaceholder,
    this.decoration,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fadeDuration = const Duration(milliseconds: 500),
    this.fadeCurve = Curves.easeOut,
    this.decodingWidth = 32,
    this.decodingHeight = 32,
    this.punch = 1.0,
  });

  @override
  State<ImageHash> createState() => _ImageHashState();
}

class _ImageHashState extends State<ImageHash> {
  ui.Image? _placeholderImage;

  @override
  void initState() {
    super.initState();
    if (widget.hash != null) {
      _decodeHash();
    }
  }

  @override
  void didUpdateWidget(covariant ImageHash oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hash != widget.hash ||
        oldWidget.decodingWidth != widget.decodingWidth ||
        oldWidget.decodingHeight != widget.decodingHeight ||
        oldWidget.punch != widget.punch) {
      if (widget.hash != null) {
        _decodeHash();
      } else {
        setState(() {
          _placeholderImage?.dispose();
          _placeholderImage = null;
        });
      }
    }
  }

  Future<void> _decodeHash() async {
    if (widget.hash == null) return;
    try {
      final pixels = BlurHashCore.decode(
        widget.hash!,
        widget.decodingWidth,
        widget.decodingHeight,
        punch: widget.punch,
      );

      ui.decodeImageFromPixels(
        pixels,
        widget.decodingWidth,
        widget.decodingHeight,
        ui.PixelFormat.rgba8888,
        (ui.Image img) {
          if (mounted) {
            setState(() {
              _placeholderImage?.dispose();
              _placeholderImage = img;
            });
          } else {
            img.dispose();
          }
        },
      );
    } catch (e) {
      debugPrint('Failed to decode BlurHash: $e');
    }
  }

  String? _tryGenerateThumbnailUrl(String imageUrl) {
    try {
      final uri = Uri.parse(imageUrl);
      
      // Check query parameters commonly used for width/sizing
      final widthParams = ['w', 'width', 'size', 'sz', 'pixel', 'px'];
      for (final param in widthParams) {
        if (uri.queryParameters.containsKey(param)) {
          final params = Map<String, String>.from(uri.queryParameters);
          params[param] = '20'; // Fetch a tiny 20px thumbnail
          
          if (params.containsKey('q')) {
            params['q'] = '10';
          }
          if (params.containsKey('quality')) {
            params['quality'] = '10';
          }
          
          return uri.replace(queryParameters: params).toString();
        }
      }
      
      // Cloudinary format support (e.g. /w_2000,h_1000/ -> /w_20,h_20/)
      final cloudinaryRegExp = RegExp(r'/w_(\d+)(,h_\d+)?/');
      if (cloudinaryRegExp.hasMatch(imageUrl)) {
        return imageUrl.replaceAll(cloudinaryRegExp, '/w_20,h_20/');
      }
    } catch (_) {
      // Gracefully catch parsing exceptions
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget placeholder;

    if (widget.hash != null && _placeholderImage != null) {
      placeholder = RawImage(
        image: _placeholderImage,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    } else {
      String? activeThumbnailUrl = widget.thumbnailUrl;
      if (activeThumbnailUrl == null && widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
        activeThumbnailUrl = _tryGenerateThumbnailUrl(widget.imageUrl!);
      }

      if (activeThumbnailUrl != null && activeThumbnailUrl.isNotEmpty) {
        placeholder = ClipRect(
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: widget.blurSigma,
              sigmaY: widget.blurSigma,
            ),
            child: Image.network(
              activeThumbnailUrl,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              errorBuilder: (context, error, stackTrace) {
                return widget.fallbackPlaceholder ??
                    SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: const ColoredBox(color: Color(0xFF16181F)),
                    );
              },
            ),
          ),
        );
      } else {
        placeholder = widget.fallbackPlaceholder ??
            SizedBox(
              width: widget.width,
              height: widget.height,
              child: const ColoredBox(color: Color(0xFF16181F)),
            );
      }
    }

    Widget content;

    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      content = Image.network(
        widget.imageUrl!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedCrossFade(
            firstChild: placeholder,
            secondChild: child,
            crossFadeState: frame == null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: widget.fadeDuration,
            firstCurve: widget.fadeCurve,
            secondCurve: widget.fadeCurve,
            layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    key: bottomKey,
                    child: bottomChild,
                  ),
                  Positioned.fill(
                    key: topKey,
                    child: topChild,
                  ),
                ],
              );
            },
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return placeholder;
        },
      );
    } else {
      content = placeholder;
    }

    if (widget.decoration != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: widget.decoration,
        clipBehavior: Clip.antiAlias,
        child: content,
      );
    }

    return content;
  }

  @override
  void dispose() {
    _placeholderImage?.dispose();
    super.dispose();
  }
}
