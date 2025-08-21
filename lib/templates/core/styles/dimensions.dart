class DimensionsGenerator {
  /// Generates the code for dimensions.
  static String gen() {
    return '''

part of '../config.dart';

class Dimensions {
  factory Dimensions() => _instance;

  Dimensions._internal();

  static final Dimensions _instance = Dimensions._internal();

  static const double size1 = 1.0;
  static const double size2 = 2.0;
  static const double size4 = 4.0;
  static const double size3 = 3.0;
  static const double size6 = 6.0;
  static const double size5 = 5.0;
  static const double size7 = 7.0;
  static const double size8 = 8.0;
  static const double size9 = 9.0;
  static const double size10 = 10.0;
  static const double size11 = 11.0;
  static const double size12 = 12.0;
  static const double size13 = 13.0;
  static const double size14 = 14.0;
  static const double size15 = 15.0;
  static const double size16 = 16.0;
  static const double size17 = 17.0;
  static const double size18 = 18.0;
  static const double size19 = 19.0;
  static const double size20 = 20.0;
  static const double size21 = 21.0;
  static const double size22 = 22.0;
  static const double size24 = 24.0;
  static const double size25 = 25.0;
  static const double size26 = 26.0;
  static const double size27 = 27.0;
  static const double size28 = 28.0;
  static const double size29 = 29.0;
  static const double size30 = 30.0;
  static const double size32 = 32.0;
  static const double size33 = 33.0;
  static const double size35 = 35.0;
  static const double size36 = 36.0;
  static const double size38 = 38.0;
  static const double size40 = 40.0;
  static const double size44 = 44.0;
  static const double size46 = 46.0;
  static const double size47 = 47.0;
  static const double size48 = 48.0;
  static const double size50 = 50.0;
  static const double size52 = 52.0;
  static const double size53 = 53.0;
  static const double size60 = 60.0;
  static const double size62 = 62.0;
  static const double size65 = 65.0;
  static const double size66 = 66.0;
  static const double size72 = 72.0;
  static const double size80 = 80.0;
  static const double size82 = 82.0;
  static const double size88 = 88.0;
  static const double size100 = 100.0;
  static const double size128 = 128.0;
  static const double size160 = 160.0;
  static const double size172 = 172.0;
  /* SizeBox */
  /* height */
  static const height1 = SizedBox(height: Dimensions.size1);
  static const height2 = SizedBox(height: Dimensions.size2);
  static const height3 = SizedBox(height: Dimensions.size3);
  static const height4 = SizedBox(height: Dimensions.size4);
  static const height5 = SizedBox(height: Dimensions.size5);
  static const height6 = SizedBox(height: Dimensions.size6);
  static const height7 = SizedBox(height: Dimensions.size7);
  static const height8 = SizedBox(height: Dimensions.size8);
  static const height9 = SizedBox(height: Dimensions.size9);
  static const height10 = SizedBox(height: Dimensions.size10);
  static const height12 = SizedBox(height: Dimensions.size12);
  static const height13 = SizedBox(height: Dimensions.size13);
  static const height15 = SizedBox(height: Dimensions.size15);
  static const height16 = SizedBox(height: Dimensions.size16);
  static const height17 = SizedBox(height: Dimensions.size17);
  static const height18 = SizedBox(height: Dimensions.size18);
  static const height19 = SizedBox(height: Dimensions.size19);

  static const height20 = SizedBox(height: Dimensions.size20);
  static const height21 = SizedBox(height: Dimensions.size21);
  static const height22 = SizedBox(height: Dimensions.size22);
  static const height24 = SizedBox(height: Dimensions.size24);
  static const height25 = SizedBox(height: Dimensions.size25);
  static const height27 = SizedBox(height: Dimensions.size27);
  static const height28 = SizedBox(height: Dimensions.size28);
  static const height29 = SizedBox(height: Dimensions.size29);
  static const height26 = SizedBox(height: Dimensions.size26);
  static const height30 = SizedBox(height: Dimensions.size30);
  static const height33 = SizedBox(height: Dimensions.size33);
  static const height35 = SizedBox(height: Dimensions.size35);
  static const height36 = SizedBox(height: Dimensions.size36);
  static const height38 = SizedBox(height: Dimensions.size38);
  static const height40 = SizedBox(height: Dimensions.size40);
  static const height44 = SizedBox(height: Dimensions.size44);
  static const height50 = SizedBox(height: Dimensions.size50);
  static const height60 = SizedBox(height: Dimensions.size60);
  static const height62 = SizedBox(height: Dimensions.size62);
  static const height65 = SizedBox(height: Dimensions.size65);

  static const empty = SizedBox();

  /* width */
  static const width2 = SizedBox(width: Dimensions.size2);
  static const width4 = SizedBox(width: Dimensions.size4);
  static const width5 = SizedBox(width: Dimensions.size5);
  static const width6 = SizedBox(width: Dimensions.size6);
  static const width7 = SizedBox(width: Dimensions.size7);
  static const width8 = SizedBox(width: Dimensions.size8);
  static const width10 = SizedBox(width: Dimensions.size10);
  static const width11 = SizedBox(width: Dimensions.size11);
  static const width12 = SizedBox(width: Dimensions.size12);
  static const width13 = SizedBox(width: Dimensions.size13);
  static const width15 = SizedBox(width: Dimensions.size15);
  static const width17 = SizedBox(width: Dimensions.size17);
  static const width16 = SizedBox(width: Dimensions.size16);
  static const width18 = SizedBox(width: Dimensions.size18);
  static const width19 = SizedBox(width: Dimensions.size19);
  static const width20 = SizedBox(width: Dimensions.size20);
  static const width25 = SizedBox(width: Dimensions.size25);

  static const sliverEmpty = SliverToBoxAdapter(
    child: SizedBox.shrink(),
  );
}
''';
  }
}
