class WidgetLanguagePickerGenerator {
  static String gen() {
    return '''import '../../../core/config.dart';
import '../gen/l10n/app_localizations.dart';
import 'button_custom.dart';

class LanguagePicker extends HookWidget {
  const LanguagePicker({super.key});

  static Future<void> pick(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => const LanguagePicker(),
        settings: const RouteSettings(name: 'LanguageRoute'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultLanguage = useState(context.locale);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.l10n.languageScreenTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: AppLocalizations.supportedLocales.length,
                itemBuilder: (BuildContext context, int index) {
                  final language =
                      AppLocalizations.supportedLocales.elementAt(index);
                  return ListTile(
                    title: Text(
                      language.languageCode.toUpperCase(),
                      style: context.bodyLarge,
                    ),
                    trailing: language == defaultLanguage.value
                        ? Icon(
                            Icons.check,
                            color: context.primaryColor,
                          )
                        : null,
                    onTap: () {
                      defaultLanguage.value = language;
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: GradientButton(
                text: context.l10n.languageScreenButton,
                height: 44.h,
                onPressed: () {
                  context.setLocale(defaultLanguage.value);

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

''';
  }
}
