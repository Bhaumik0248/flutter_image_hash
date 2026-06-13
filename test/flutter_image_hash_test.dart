import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_hash/flutter_image_hash.dart';

void main() {
  group('BlurHashCore', () {
    test('decodes valid blurhash without throwing', () {
      const String hash = "L5H2EC=PM+yV0g-mq.wG9c010J}I";
      final pixels = BlurHashCore.decode(hash, 32, 32);
      expect(pixels.length, equals(32 * 32 * 4));
    });

    test('throws ArgumentError on invalid short hash', () {
      expect(() => BlurHashCore.decode("short", 32, 32), throwsArgumentError);
    });
  });

  group('ImageHash Widget', () {
    testWidgets('renders BlurHash placeholder without crashing', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ImageHash(
                hash: "L5H2EC=PM+yV0g-mq.wG9c010J}I",
                width: 100,
                height: 100,
              ),
            ),
          ),
        );
        // Wait a bit for the async decodeImageFromPixels callback
        await Future.delayed(const Duration(milliseconds: 100));
      });

      await tester.pumpAndSettle();

      expect(find.byType(ImageHash), findsOneWidget);
    });

    testWidgets('renders blurred thumbnail placeholder without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageHash(
              thumbnailUrl: "https://thumbs.dreamstime.com/b/sample-jpeg-single-delectable-pink-glazed-donut-adorned-vibrant-rainbow-sprinkles-358283561.jpg?w=20",
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ImageHash), findsOneWidget);
    });

    testWidgets('renders with only imageUrl (auto-thumbnail)', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageHash(
              imageUrl: "https://thumbs.dreamstime.com/b/sample-jpeg-single-delectable-pink-glazed-donut-adorned-vibrant-rainbow-sprinkles-358283561.jpg?w=992",
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ImageHash), findsOneWidget);
    });

    testWidgets('renders fallback placeholder when no thumbnail, hash or resizable imageUrl is provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageHash(
              fallbackPlaceholder: Text('Fallback'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Fallback'), findsOneWidget);
    });
  });
}
