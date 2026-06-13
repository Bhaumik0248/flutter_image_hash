import 'dart:math';
import 'dart:typed_data';

/// Pure Dart implementation of BlurHash decoding
class BlurHashCore {
  static const String _characters =
      "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#\$%*+,-.:;=?@[]^_{|}~";

  static int _decode83(String str) {
    int value = 0;
    for (int i = 0; i < str.length; i++) {
      int c = _characters.indexOf(str[i]);
      if (c == -1) {
        throw ArgumentError("Invalid character in BlurHash");
      }
      value = value * 83 + c;
    }
    return value;
  }

  static double _sRGBToLinear(int value) {
    double v = value / 255.0;
    if (v <= 0.04045) {
      return v / 12.92;
    } else {
      return pow((v + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  static int _linearTosRGB(double value) {
    double v = max(0, min(1, value));
    if (v <= 0.0031308) {
      return (v * 12.92 * 255 + 0.5).toInt();
    } else {
      return ((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5).toInt();
    }
  }

  static double _signPow(double value, double exp) {
    return value.sign * pow(value.abs(), exp);
  }

  static List<double> _decodeDC(int value) {
    int r = value >> 16;
    int g = (value >> 8) & 255;
    int b = value & 255;
    return [_sRGBToLinear(r), _sRGBToLinear(g), _sRGBToLinear(b)];
  }

  static List<double> _decodeAC(int value, double maximumValue) {
    int quantR = (value / (19 * 19)).floor();
    int quantG = (value / 19).floor() % 19;
    int quantB = value % 19;
    return [
      _signPow((quantR - 9) / 9.0, 2.0) * maximumValue,
      _signPow((quantG - 9) / 9.0, 2.0) * maximumValue,
      _signPow((quantB - 9) / 9.0, 2.0) * maximumValue,
    ];
  }

  /// Decodes a BlurHash string into raw RGBA pixel data.
  static Uint8List decode(String blurhash, int width, int height,
      {double punch = 1.0}) {
    if (blurhash.length < 6) {
      throw ArgumentError("BlurHash string too short");
    }

    int sizeFlag = _decode83(blurhash[0]);
    int numCompY = (sizeFlag / 9).floor() + 1;
    int numCompX = (sizeFlag % 9) + 1;

    int quantizedBoxValue = _decode83(blurhash[1]);
    double maximumValue = (quantizedBoxValue + 1) / 166.0;

    if (blurhash.length != 4 + 2 * numCompX * numCompY) {
      throw ArgumentError("BlurHash string length mismatch");
    }

    List<List<double>> colors = List.generate(
        numCompX * numCompY, (i) => [0.0, 0.0, 0.0],
        growable: false);

    for (int i = 0; i < numCompX * numCompY; i++) {
      if (i == 0) {
        int value = _decode83(blurhash.substring(2, 6));
        colors[i] = _decodeDC(value);
      } else {
        int value = _decode83(blurhash.substring(4 + i * 2, 6 + i * 2));
        colors[i] = _decodeAC(value, maximumValue * punch);
      }
    }

    Uint8List pixels = Uint8List(width * height * 4);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double r = 0, g = 0, b = 0;

        for (int j = 0; j < numCompY; j++) {
          for (int i = 0; i < numCompX; i++) {
            double basis = cos(pi * x * i / width) * cos(pi * y * j / height);
            List<double> color = colors[i + j * numCompX];
            r += color[0] * basis;
            g += color[1] * basis;
            b += color[2] * basis;
          }
        }

        int intR = _linearTosRGB(r);
        int intG = _linearTosRGB(g);
        int intB = _linearTosRGB(b);

        int index = (y * width + x) * 4;
        pixels[index] = intR;
        pixels[index + 1] = intG;
        pixels[index + 2] = intB;
        pixels[index + 3] = 255; // Alpha
      }
    }
    return pixels;
  }
}
