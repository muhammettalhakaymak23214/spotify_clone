import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/helpers/currency_helper.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_point.dart';

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});
  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double maxHeight = 374.h;
    final double minHeight = kToolbarHeight + ScreenUtil().statusBarHeight;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: _Constants.appBarBgColor,
            pinned: _Constants.appBarPinned,
            floating: _Constants.appBarFloating,
            snap: _Constants.appBarSnap,
            expandedHeight: maxHeight,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double currentHeight = constraints.biggest.height;
                double t =
                    ((currentHeight - minHeight) / (maxHeight - minHeight))
                        .clamp(0.0, 1.0);

                return Stack(
                  children: [
                    _imageSection(_Constants.appBarImage),
                    _premiumIconWithTextSection(t),
                    _premiumSubtitleSection(t),
                    _appBarButtonSection(t),
                  ],
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _premiumButtonSection(),
              _ConditionsSection(
                conditions1: l10n.premiumViewTermsIndividualWelcome(
                  "2",
                  CurrencyHelper.formatPrice(45, context),
                  CurrencyHelper.formatPrice(99, context),
                ),
                conditions2: l10n.premiumViewTermsApply,
                conditions3: l10n.premiumViewTermsExpiryDate("2025"),
                textAlign: TextAlign.start,
              ),
              const _WhyPremiumSection(),
              _currentPlansSection(),
              _PlanSention(
                title: l10n.premiumViewPromoShortWelcome(2, CurrencyHelper.formatPrice(45, context)),
                subtitle: l10n.premiumViewPlanIndividual,
                price: l10n.premiumViewPlanPricePromo("2", CurrencyHelper.formatPrice(45, context)),
                priceDesciription: l10n.premiumViewPlanPriceAfterPromo(CurrencyHelper.formatPrice(45, context)),
                color: _Constants.colorPink,
                buttonTitle: l10n.premiumViewGetIndividual,
                packageDetails: [
                  l10n.premiumViewPlanIndividualAccount,
                  l10n.premiumViewPlanIndividualCancel,
                ],
                conditions1: l10n.premiumViewConditionsIndividual(
                  "2",
                  CurrencyHelper.formatPrice(45, context),
                  CurrencyHelper.formatPrice(99, context),
                ),
                conditions2: l10n.premiumViewTermsApply,
                conditions3: l10n.premiumViewTermsExpiryDate("2025"),
              ),
              _PlanSention(
                subtitle: l10n.premiumViewPlanStudent,
                price: l10n.premiumViewPlanPricePerMonth(CurrencyHelper.formatPrice(65, context)),
                color: _Constants.colorPurple,
                buttonTitle: l10n.premiumViewGetStudent,
                packageDetails: [
                  l10n.premiumViewPlanStudentDiscount,
                  l10n.premiumViewPlanStudentCancel,
                ],
                conditions1: l10n.premiumViewConditionsStudent,
                conditions2: l10n.premiumViewTermsApply,
              ),
              _PlanSention(
                subtitle: l10n.premiumViewPlanDuo,
                price: l10n.premiumViewPlanPricePerMonth(CurrencyHelper.formatPrice(135, context)),
                color: _Constants.colorYellow,
                buttonTitle: l10n.premiumViewGetDuo,
                packageDetails: [
                  l10n.premiumViewPlanDuoAccount,
                  l10n.premiumViewPlanDuoCancel,
                ],
                conditions1: l10n.premiumViewConditionsDuo,
                conditions2: l10n.premiumViewTermsApply,
              ),
              _PlanSention(
                subtitle: l10n.premiumViewPlanFamily,
                price: l10n.premiumViewPlanPricePerMonth(CurrencyHelper.formatPrice(165, context)),
                color: _Constants.colorBlue,
                buttonTitle: l10n.premiumViewGetFamily,
                packageDetails: [
                  l10n.premiumViewPlanFamilyAccount,
                  l10n.premiumViewPlanFamilyControl,
                  l10n.premiumViewPlanFamilyCancel,
                ],
                conditions1: l10n.premiumViewConditionsFamily,
                conditions2: l10n.premiumViewTermsApply,
              ),
              SizedBox(height: _Constants.heightBottomSpace),
            ]),
          ),
        ],
      ),
    );
  }

  PositionedDirectional _appBarButtonSection(double t) {
    final l10n = AppLocalizations.of(context)!;
    return PositionedDirectional(
      bottom: _Constants.appBarButtonSectionButtonPositionBottom,
      start: _Constants.appBarButtonSectionButtonPositionLeft,
      child: Opacity(
        opacity: t,
        child: Container(
          decoration: BoxDecoration(
            color: _Constants.appBarButtonSectionButtonColor,
          ),
          child: Row(
            children: [
              Padding(
                padding: _Constants.paddingAppBarButtonSection,
                child: FaIcon(
                  FontAwesomeIcons.bell,
                  color: _Constants.appBarButtonSectionButtonIconColor,
                  size: AppSizes.fontSize16,
                ),
              ),
              Padding(
                padding: _Constants.paddingAppBarButtonSection,
                child: AppText(
                  text: l10n.premiumViewSubtitle,
                  style: AppTextStyle.bodyM,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PositionedDirectional _premiumSubtitleSection(double t) {
    final l10n = AppLocalizations.of(context)!;
    return PositionedDirectional(
      bottom: _Constants.premiumSubtitleSectionPositionBottom,
      start: _Constants.premiumSubtitleSectionPositionLeft,
      child: SizedBox(
        width: 0.9.sw,
        child: Opacity(
          opacity: t,
          child: AppText(
            text: l10n.premiumViewTitle("2", CurrencyHelper.formatPrice(45, context)),
            style: AppTextStyle.h2,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  PositionedDirectional _premiumIconWithTextSection(double t) {
    final l10n = AppLocalizations.of(context)!;
    return PositionedDirectional(
      bottom: _Constants.premiumIconWithTextSectionPositionBottom,
      start: _Constants.premiumIconWithTextSectionPositionLeft,
      end: _Constants.premiumIconWithTextSectionPositionLeft,
      child: SizedBox(
        width: _Constants.premiumIconWithTextSectionBoxWidth,
        child: Opacity(
          opacity: t,
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.spotify, color: _Constants.iconColor),
              Padding(
                padding: _Constants.paddingAppBarButtonSection,
                child: AppText(
                  text: l10n.premiumViewPremium,
                  style: AppTextStyle.titleL,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _imageSection(String appBarImagePath) {
    return Positioned.fill(
      child: Image.asset(appBarImagePath, fit: BoxFit.contain),
    );
  }

  Padding _premiumButtonSection() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: _Constants.paddingPremiumButtonSection,
      child: Container(
        height: _Constants.heightPremiumButtonSection,
        decoration: _Constants.decorationPremiumButtonSection,
        alignment: Alignment.center,
        child: AppText(
          text: l10n.premiumViewGetIndividual,
          style: AppTextStyle.bodyM,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding _currentPlansSection() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: _Constants.paddingCurrentPlansSection,
      child: AppText(
        text: l10n.premiumViewCurrentPlansTitle,
        style: AppTextStyle.titleL,
        color: AppColors.white,
      ),
    );
  }
}

class _WhyPremiumSection extends StatelessWidget {
  const _WhyPremiumSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: _Constants.paddingWhyPremiumSection,
      child: Container(
        decoration: _Constants.decorationWhyPremiumSection,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleSection(context),
            Divider(color: _Constants.dividerColor),
            _IconWithTextSection(
              text: l10n.premiumViewWhyFeatureAdFree,
              icon: FontAwesomeIcons.volumeXmark,
            ),
            _IconWithTextSection(
              text: l10n.premiumViewWhyFeatureOffline,
              icon: FontAwesomeIcons.arrowsDownToLine,
            ),
            _IconWithTextSection(
              text: l10n.premiumViewWhyFeatureOnDemand,
              icon: FontAwesomeIcons.shuffle,
            ),
            _IconWithTextSection(
              text: l10n.premiumViewWhyFeatureHighQuality,
              icon: FontAwesomeIcons.headphones,
            ),
            _IconWithTextSection(
              text: l10n.premiumViewWhyFeatureGroupListening,
              icon: FontAwesomeIcons.userGroup,
            ),
            _IconWithTextSection(
              text: l10n.premiumViewWhyFeatureQueueEditing,
              icon: FontAwesomeIcons.list,
            ),
          ],
        ),
      ),
    );
  }

  Padding _titleSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: _Constants.paddingWhyPremiumTitleSection,
      child: AppText(
        text: l10n.premiumViewWhyJoinTitle,
        style: AppTextStyle.titleL,
        color: AppColors.white,
      ),
    );
  }
}

class _PlanSention extends StatelessWidget {
  const _PlanSention({
    this.title,
    required this.subtitle,
    required this.price,
    this.priceDesciription,
    required this.packageDetails,
    required this.buttonTitle,
    required this.color,
    this.conditions1,
    this.conditions2,
    this.conditions3,
  });
  final String? title;
  final String subtitle;
  final String price;
  final String? priceDesciription;
  final List<String> packageDetails;
  final String buttonTitle;
  final String? conditions1;
  final String? conditions2;
  final String? conditions3;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _Constants.paddingPlanSentionOut,
      child: Container(
        decoration: _Constants.decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title?.isNotEmpty ?? false)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _topLeftContainer(),
              ),
            Padding(
              padding: _Constants.paddingPlanSention,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _premiumWithTitleSection(context),
                  _titleSection(),
                  _priceSection(),
                  if (priceDesciription?.isNotEmpty ?? false)
                    _priceDescriptionWidget(),
                ],
              ),
            ),
            _divider(),
            _planDetailSection(),
            _buttonSection(),
            _ConditionsSection(
              conditions1: conditions1,
              conditions2: conditions2,
              conditions3: conditions3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Padding _buttonSection() {
    return Padding(
      padding: _Constants.paddingButtonSection,
      child: Container(
        height: _Constants.heightButtonSection,
        decoration: BoxDecoration(
          color: color,
          borderRadius: _Constants.radiusButtonSection,
        ),
        child: Center(
          child: Padding(
            padding: _Constants.paddingButtonSectionInText,
            child: AppText(
              text: buttonTitle,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyM,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Padding _planDetailSection() {
    return Padding(
      padding: _Constants.paddingPlanDetailSection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: packageDetails.map((detail) {
          return Padding(
            padding: _Constants.paddingPlanDetailSectionInRow,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Point(paddingValue: 8.w),
                Expanded(
                  child: AppText(
                    text: detail,
                    style: AppTextStyle.bodyM,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  AppText _priceDescriptionWidget() {
    return AppText(
      text: priceDesciription!,
      style: AppTextStyle.bodyS,
      color: AppColors.grey,
    );
  }

  AppText _priceSection() {
    return AppText(
      text: price,
      style: AppTextStyle.bodyL,
      color: AppColors.white,
      fontWeight: FontWeight.w600,
    );
  }

  Padding _titleSection() {
    return Padding(
      padding: _Constants.paddingTitleSection,
      child: AppText(text: subtitle, style: AppTextStyle.titleL, color: color),
    );
  }

  Padding _premiumWithTitleSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: _Constants.paddingPremiumWithTitleSection,
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.spotify,
            size: _Constants.iconSize,
            color: _Constants.iconColor,
          ),
          Padding(
            padding: _Constants.paddingPremiumWithTitleSectionInRow,
            child: AppText(
              text: l10n.premiumViewPremium,
              style: AppTextStyle.bodyS,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container _topLeftContainer() {
    return Container(
      height: _Constants.heightTopLeftContainer,
      decoration: BoxDecoration(
        color: color,
        borderRadius: _Constants.radiusTopLeftContainer,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: AppText(
          textAlign: TextAlign.center,
          text: title!,
          style: AppTextStyle.labelM,
          color: AppColors.black,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Padding _divider() {
    return Padding(
      padding: _Constants.paddingDivider,
      child: Divider(color: _Constants.dividerColor),
    );
  }
}

class _ConditionsSection extends StatelessWidget {
  const _ConditionsSection({
    required this.conditions1,
    required this.conditions2,
    required this.conditions3,
    required this.textAlign,
  });

  final String? conditions1;
  final String? conditions2;
  final String? conditions3;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _Constants.paddingConditionsSection,
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSize),
          children: [
            if (conditions1?.isNotEmpty ?? false) TextSpan(text: conditions1),
            if (conditions2?.isNotEmpty ?? false)
              TextSpan(
                text: conditions2,
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
            if (conditions3?.isNotEmpty ?? false) TextSpan(text: conditions3),
          ],
        ),
      ),
    );
  }
}

class _IconWithTextSection extends StatelessWidget {
  const _IconWithTextSection({required this.text, required this.icon});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _Constants.paddingIconWithTextSection,
      child: Row(
        children: [
          Padding(
            padding: _Constants.paddingIconWithTextSection,
            child: FaIcon(
              icon,
              size: _Constants.iconSize,
              color: _Constants.iconColor,
            ),
          ),
          AppText(
            text: text,
            style: AppTextStyle.bodyL,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}

abstract final class _Constants {
  // Size
  static double get iconSize => 22.sp;
  static double get heightTopLeftContainer => 25.h;
  static double get heightButtonSection => 45.h;
  static double get premiumIconWithTextSectionPositionLeft => 16.w;
  static double get premiumIconWithTextSectionPositionBottom => 210.h;
  static double get premiumIconWithTextSectionBoxWidth => 350.w;
  static double get premiumSubtitleSectionPositionBottom => 90.h;
  static double get premiumSubtitleSectionPositionLeft => 16.w;
  static double get appBarButtonSectionButtonPositionLeft => 16.w;
  static double get appBarButtonSectionButtonPositionBottom => 16.h;
  static double get heightPremiumButtonSection => 50.h;
  static double get heightBottomSpace => 200.h;
  // SliverAppBar Settings
  static bool get appBarPinned => false;
  static bool get appBarFloating => false;
  static bool get appBarSnap => false;
  // Color
  static Color get appBarButtonSectionButtonColor =>
      const Color.fromARGB(255, 57, 57, 57);
  static Color get iconColor => AppColors.white;
  static Color get appBarButtonSectionButtonIconColor => Colors.blue;
  static Color get appBarBgColor => AppColors.black;
  static Color get dividerColor => AppColors.grey;
  static Color get colorBlue => AppColors.premiumViewBlueColor;
  static Color get colorPink => AppColors.premiumViewPinkColor;
  static Color get colorPurple => AppColors.premiumViewPurpleColor;
  static Color get colorYellow => AppColors.premiumViewYellowColor;
  // Path
  static String get appBarImage => AppStrings.premiumViewAppBarImage;
  // Padding
  static EdgeInsets get paddingPlanSentionOut =>
      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w);
  static EdgeInsets get paddingIconWithTextSection => EdgeInsets.all(8.w);
  static EdgeInsets get paddingConditionsSection =>
      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w);
  static EdgeInsets get paddingDivider =>
      EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get paddingPremiumWithTitleSectionInRow =>
      EdgeInsets.only(right: 8.0.w, left: 8.0.w);
  static EdgeInsets get paddingPremiumWithTitleSection =>
      EdgeInsets.only(bottom: 10.0.h);
  static EdgeInsets get paddingPlanDetailSectionInRow =>
      EdgeInsets.only(bottom: 10.0.h);
  static EdgeInsets get paddingButtonSectionInText =>
      EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get paddingButtonSection =>
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h);
  static EdgeInsets get paddingPlanDetailSection =>
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h);
  static EdgeInsets get paddingAppBarButtonSection => EdgeInsets.all(8.w);
  static EdgeInsets get paddingPlanSention =>
      EdgeInsets.only(left: 20.w, top: 20.h, bottom: 10.w, right: 20.w);
  static EdgeInsets get paddingTitleSection => EdgeInsets.only(bottom: 10.0.h);
  static EdgeInsets get paddingPremiumButtonSection =>
      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w);
  static EdgeInsets get paddingCurrentPlansSection =>
      EdgeInsets.only(left: 20.w, right: 20.w);
  static EdgeInsets get paddingWhyPremiumSection =>
      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w);
  static EdgeInsets get paddingWhyPremiumTitleSection =>
      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w);
  // Decoration
  static BoxDecoration get decorationPremiumButtonSection => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(20.r),
  );
  static BoxDecoration get decorationWhyPremiumSection => BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(10.r),
  );
  static BoxDecoration get decoration => BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(10.r),
  );
  // Radius
  static BorderRadiusGeometry get radiusButtonSection =>
      BorderRadius.circular(20.r);
  static BorderRadiusGeometry get radiusTopLeftContainer => BorderRadiusDirectional.only(
  topStart: Radius.circular(10.r),  
  bottomEnd: Radius.circular(10.r), 
);
}