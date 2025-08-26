import 'dart:io';

Future<void> updateAndroidManifest(String manifestPath) async {
  final file = File(manifestPath);
  var content = await file.readAsString();

  final applicationTagRegex = RegExp(r'<application[^>]*>');
  final androidLabelRegex = RegExp(r'android:label="[^"]*"');

  final applicationMatch = applicationTagRegex.firstMatch(content);

  if (applicationMatch != null) {
    final applicationTag = applicationMatch.group(0)!;

    if (androidLabelRegex.hasMatch(applicationTag)) {
      // Nếu đã có android:label, thay thế nó
      final updatedApplicationTag = applicationTag.replaceFirst(
        androidLabelRegex,
        'android:label="@string/app_name"',
      );

      content = content.replaceRange(
        applicationMatch.start,
        applicationMatch.end,
        updatedApplicationTag,
      );

      await file.writeAsString(content);
      print(
          'Updated android:label to "@string/app_name" in AndroidManifest.xml.');
    } else {
      // Nếu chưa có android:label, thêm mới
      final updatedApplicationTag = applicationTag.replaceFirst(
        RegExp(r'<application'),
        '<application android:label="@string/app_name"',
      );

      content = content.replaceRange(
        applicationMatch.start,
        applicationMatch.end,
        updatedApplicationTag,
      );

      await file.writeAsString(content);
      print(
          'Added android:label="@string/app_name" to <application> tag in AndroidManifest.xml.');
    }
  } else {
    print('No <application> tag found in AndroidManifest.xml.');
  }
}
