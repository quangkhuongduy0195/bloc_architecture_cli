class SettingPageGenerator {
  static String gen() {
    return '''import '../../core/common/app_user/app_user_cubit.dart';
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
        title: Text(context.l10n.settingsTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            const UserInfoListTitle(),
            HeightBox(20.h),
            SettingsSection(
              title: context.l10n.settingsInformationPersonal,
              children: [
                SettingsTile(
                  leading: Assets.iconsCalendar.svg(),
                  title: TextApp(
                    context.l10n.settingsBirthday,
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
                    context.l10n.settingsEmail,
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
                    context.l10n.settingsPhone,
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
              title: context.l10n.settingsGeneralInformation,
              children: [
                SettingsTile.switchTile(
                  initialValue: false,
                  needToShowDivider: true,
                  activeSwitchColor: Colors.blue,
                  title: TextApp(
                    context.l10n.settingsBiometricAuthentication,
                    fontWeight: FontWeight.w500,
                  ),
                  leading: Assets.iconsBio.svg(),
                  onToggle: (bool value) {},
                ),
                SettingsTile.navigation(
                  leading: Assets.iconsMessage.svg(),
                  needToShowDivider: true,
                  title: TextApp(
                    context.l10n.settingsLanguage,
                    fontWeight: FontWeight.w500,
                  ),
                  trailing: TextApp(
                    context.locale.countryCode ?? context.locale.languageCode,
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
                    context.l10n.settingsChangePassword,
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () {},
                ),
                SettingsTile.navigation(
                  leading: Assets.iconsLogout.svg(),
                  title: TextApp(
                    context.l10n.settingsLogout,
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
