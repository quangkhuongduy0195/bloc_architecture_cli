class SettingPageGenerator {
  static String gen() {
    return '''import 'package:auto_route/auto_route.dart';

import '../../core/common/app_user/app_user_cubit.dart';
import '../../core/config.dart';
import '../../widgets/language.dart';
import '../../widgets/setting_ui.dart';
import '../../widgets/user_info_list_title.dart';
import '../auth/presentation/bloc/auth_bloc.dart';

@RoutePage(name: 'SettingRoute')
class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppUserCubit bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(LocaleKeys.settingsTitle)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            const UserInfoListTitle(),
            HeightBox(20.h),
            SettingsSection(
              title: context.tr(LocaleKeys.settingsInformationPersonal),
              children: [
                SettingsTile(
                  leading: Assets.iconsCalendar.svg(),
                  title: TextApp(
                    context.tr(LocaleKeys.settingsBirthday),
                    fontWeight: FontWeight.w500,
                  ),
                  trailing: TextApp(
                    user?.birthDate ?? '-',
                    color: greyText,
                  ),
                ),
                SettingsTile(
                  leading: Assets.iconsMailBlue.svg(),
                  title: TextApp(
                    context.tr(LocaleKeys.settingsEmail),
                    fontWeight: FontWeight.w500,
                  ),
                  trailing: TextApp(
                    user?.email ?? '-',
                    color: greyText,
                  ),
                ),
                SettingsTile(
                  leading: Assets.iconsPhone.svg(),
                  title: TextApp(
                    context.tr(LocaleKeys.settingsPhone),
                    fontWeight: FontWeight.w500,
                  ),
                  trailing: TextApp(
                    user?.phone ?? '-',
                    color: greyText,
                  ),
                ),
              ],
            ),
            HeightBox(20.h),
            SettingsSection(
              title: context.tr(LocaleKeys.settingsGeneralInformation),
              children: [
                SettingsTile.switchTile(
                  initialValue: false,
                  needToShowDivider: true,
                  activeSwitchColor: Colors.blue,
                  title: TextApp(
                    context.tr(LocaleKeys.settingsBiometricAuthentication),
                    fontWeight: FontWeight.w500,
                  ),
                  leading: Assets.iconsBio.svg(),
                  onToggle: (bool value) {},
                ),
                SettingsTile.navigation(
                  leading: Assets.iconsMessage.svg(),
                  needToShowDivider: true,
                  title: TextApp(
                    context.tr(LocaleKeys.settingsLanguage),
                    fontWeight: FontWeight.w500,
                  ),
                  trailing: TextApp(
                    context.tr(
                      LanguageLocals.getDisplayLanguage(
                        context.locale.languageCode,
                      ).name,
                    ),
                    color: greyText,
                  ),
                  onPressed: () {
                    LanguagePicker.pick(context);
                  },
                ),
                SettingsTile.navigation(
                  leading: Assets.iconsShield.svg(),
                  needToShowDivider: true,
                  title: TextApp(
                    context.tr(LocaleKeys.settingsChangePassword),
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () {},
                ),
                SettingsTile.navigation(
                  leading: Assets.iconsLogout.svg(),
                  title: TextApp(
                    context.tr(LocaleKeys.settingsLogout),
                    fontWeight: FontWeight.w500,
                    color: error,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthUserLoggedOut());
                  },
                ),
              ],
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
