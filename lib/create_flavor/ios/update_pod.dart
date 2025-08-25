import 'dart:io';

Future<void> updatePod(String flavorName) async {
  final podfile = File('ios/Podfile');

  if (!await podfile.exists()) {
    print('❌ Podfile not found at ios/Podfile');
    return;
  }

  final content = await podfile.readAsString();

  // Tìm project block pattern
  final regex = RegExp(
    r"(project\s+'Runner',\s*\{)([\s\S]*?)(\})",
    multiLine: true,
  );

  final match = regex.firstMatch(content);
  if (match == null) {
    print('❌ Could not find project \'Runner\' block in Podfile');
    return;
  }

  final projectStart = match.group(1)!; // project 'Runner', {
  final projectContent = match.group(2)!; // existing content
  final projectEnd = match.group(3)!; // }

  // Kiểm tra đã có flavor chưa
  if (projectContent.contains("Debug-$flavorName")) {
    print('⚠️  Flavor $flavorName already exists in Podfile');
    return;
  }

  // Tạo flavor configurations
  final flavorConfigs = '''
  'Debug-$flavorName' => :debug,
  'Profile-$flavorName' => :release,
  'Release-$flavorName' => :release,''';

  // Thêm flavor vào cuối project content (trước dấu })
  final newProjectContent =
      projectContent.trimRight() + '\n' + flavorConfigs + '\n';

  // Tạo nội dung mới
  final newContent = content.replaceFirst(
    regex,
    projectStart + newProjectContent + projectEnd,
  );

  // Ghi file
  await podfile.writeAsString(newContent);

  print('✅ Added flavor "$flavorName" to Podfile');
  print('   - Debug-$flavorName => :debug');
  print('   - Profile-$flavorName => :release');
  print('   - Release-$flavorName => :release');
}
