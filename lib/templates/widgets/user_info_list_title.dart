class WidgetUserInfoListTitleGenerator {
  static String gen() {
    return '''import 'package:flutter/cupertino.dart';

import '../core/common/app_user/app_user_cubit.dart';
import '../core/config.dart';
import '../di/injection.dart';
import 'cache_image.dart';

class UserInfoListTitle extends StatelessWidget {
  const UserInfoListTitle({
    super.key,
    this.fromDrawer = false,
  });
  final bool fromDrawer;
  @override
  Widget build(BuildContext context) {
    final user = getIt<AppUserCubit>().state.user;

    if (user == null) {
      return const SizedBox();
    }

    return Container(
      padding: fromDrawer
          ? EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top,
              left: 16,
              bottom: 10,
            )
          : const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
      decoration: BoxDecoration(
        color: context.canvasColor,
        borderRadius: BorderRadius.circular(fromDrawer ? 0 : 16),
        boxShadow: fromDrawer
            ? null
            : [
                BoxShadow(
                  color: const Color(0xffF7901E).withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
      ),
      child: Row(
        children: [
          CacheImage(
            errorWidget: Assets.imagesAvatarDefault.svg(),
            imageUrl: user.image ?? '',
            radius: 100,
            height: 60,
            width: 60,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextApp.bold(
                  user.name,
                  type: TextType.lg,
                ),
                TextApp(
                  user.name,
                  type: TextType.sm,
                  color: greyText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          if (!fromDrawer)
            const Icon(
              CupertinoIcons.chevron_forward,
              size: 20,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}
''';
  }
}
