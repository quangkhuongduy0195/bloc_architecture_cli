class WidgetCacheImageGenerator {
  static String gen() {
    return '''import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../core/config.dart';

/// A widget that displays an image from a URL.
///
/// This widget uses the `cached_network_image` package to cache the image
/// and display a placeholder while the image is loading.
///
/// The `imageUrl` parameter is required and should be a valid URL.
///
/// The `radius` parameter can be used to round the corners of the image.
///
/// The `height` and `width` parameters can be used to set the size of the image.
///
/// The `fit` parameter can be used to control how the image is scaled to fit
/// the available space.
///
/// The `placeholder` parameter can be used to display a widget while the image
/// is loading.
///
/// The `errorWidget` parameter can be used to display a widget if the image
/// fails to load.
class CacheImage extends StatelessWidget {
  /// Creates a new [CacheImage] widget.
  const CacheImage({
    super.key,
    required this.imageUrl,
    this.radius = 0.0,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  /// The URL of the image to display.
  final String imageUrl;

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// The radius of the corners of the image.
  final double radius;

  /// The fit of the image.
  final BoxFit fit;

  /// The widget to display while the image is loading.
  final Widget? placeholder;

  /// The widget to display if the image fails to load.
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Bone.square(
              size: width,
              uniRadius: radius,
            ),
        errorWidget: (context, url, error) =>
            errorWidget ?? const Icon(Icons.error),
      ),
    );
  }
}
''';
  }
}
