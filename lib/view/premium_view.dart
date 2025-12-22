import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/constants/app_paddings.dart';
import 'package:spotify_clone/core/constants/app_sizes.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_point.dart';

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});
  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  final double maxHeight = 374;
  final double minHeight = kToolbarHeight + 20;
  @override
  Widget build(BuildContext context) {
    final String appBarImagePath = "assets/png/premiums.png";
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.black,
            pinned: false,
            floating: false,
            snap: false,
            expandedHeight: maxHeight,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double currentHeight = constraints.biggest.height;
                double t =
                    (currentHeight - minHeight) / (maxHeight - minHeight);
                if (t > 1) t = 1;
                if (t < 0) t = 0;
                return Stack(
                  children: [
                    _imageSection(appBarImagePath),
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
                conditions1: AppStrings.planConditions1_1,
                conditions2: AppStrings.planConditions1_2,
                conditions3: AppStrings.planConditions1_3,
                textAlign: TextAlign.start,
              ),
              _WhyPremiumSection(),
              _currentPlansSection(),
              _PlanSention(
                title: AppStrings.planTitle1,
                subtitle: AppStrings.planSubtitle1,
                price: AppStrings.planPrice1,
                priceDesciription: AppStrings.planPriceDescription1,
                color: AppColors.pinkColor,
                buttonTitle: AppStrings.planButtonTitle1,
                packageDetails: [
                  AppStrings.planPackageDetails1_1,
                  AppStrings.planPackageDetails1_2,
                ],
                conditions1: AppStrings.planConditions1_1,
                conditions2: AppStrings.planConditions1_2,
                conditions3: AppStrings.planConditions1_3,
              ),
              _PlanSention(
                subtitle: AppStrings.planSubtitle2,
                price: AppStrings.planPrice2,
                color: AppColors.purpleColor,
                buttonTitle: AppStrings.planButtonTitle2,
                packageDetails: [
                  AppStrings.planPackageDetails2_1,
                  AppStrings.planPackageDetails2_2,
                ],
                conditions1: AppStrings.planConditions2_1,
                conditions2: AppStrings.planConditions2_2,
              ),
              _PlanSention(
                subtitle: AppStrings.planSubtitle3,
                price: AppStrings.planPrice3,
                color: AppColors.yellowColor,
                buttonTitle: AppStrings.planButtonTitle3,
                packageDetails: [
                  AppStrings.planPackageDetails3_1,
                  AppStrings.planPackageDetails3_2,
                ],
                conditions1: AppStrings.planConditions3_1,
                conditions2: AppStrings.planConditions3_2,
              ),
              _PlanSention(
                subtitle: AppStrings.planSubtitle4,
                price: AppStrings.planPrice4,
                color: AppColors.blueColor,
                buttonTitle: AppStrings.planButtonTitle4,
                packageDetails: [
                  AppStrings.planPackageDetails4_1,
                  AppStrings.planPackageDetails4_2,
                  AppStrings.planPackageDetails4_3,
                ],
                conditions1: AppStrings.planConditions4_1,
                conditions2: AppStrings.planConditions4_2,
              ),
              SizedBox(height: 120),
            ]),
          ),
        ],
      ),
    );
  }

  Positioned _appBarButtonSection(double t) {
    final Color buttonColor = Color.fromARGB(255, 57, 57, 57);
    final Color iconColor = Colors.blue;
    final double size = 16;
    return Positioned(
      bottom: size,
      left: size,
      child: Opacity(
        opacity: t,
        child: Container(
          decoration: BoxDecoration(color: buttonColor),
          child: Row(
            children: [
              Padding(
                padding: AppPaddings.all8,
                child: FaIcon(
                  FontAwesomeIcons.bell,
                  color: iconColor,
                  size: AppSizes.fontSize16,
                ),
              ),
              Padding(
                padding: AppPaddings.all8,
                child: Text(
                  AppStrings.premiumPageSubtitle,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSizes.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _premiumSubtitleSection(double t) {
    final double fontSize = 30;
    final double sizeBottom = 70;
    final double sizeLeft = 16;
    return Positioned(
      bottom: sizeBottom,
      left: sizeLeft,
      child: SizedBox(
        width: 350,
        child: Opacity(
          opacity: t,
          child: Text(
            AppStrings.premiumPageTitle,
            style: TextStyle(
              color: AppColors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Positioned _premiumIconWithTextSection(double t) {
    final double sizeLeft = 16;
    final double sizeBottom = 210;
    final double sizedBoxWidth = 350;
    return Positioned(
      bottom: sizeBottom,
      left: sizeLeft,
      child: SizedBox(
        width: sizedBoxWidth,
        child: Opacity(
          opacity: t,
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.spotify, color: AppColors.white),
              Padding(
                padding: AppPaddings.all8,
                child: Text(
                  AppStrings.premium,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSizes.fontSize22,
                    fontWeight: FontWeight.bold,
                  ),
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
    return Padding(
      padding: AppPaddings.symmetricH20V10,
      child: Container(
        height: AppSizes.size50,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          AppStrings.premiumButtonTitle,
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Padding _currentPlansSection() {
    return Padding(
      padding: AppPaddings.left20,
      child: Text(
        AppStrings.currentPlans,
        style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontSize22),
      ),
    );
  }
}

class _WhyPremiumSection extends StatelessWidget {
  const _WhyPremiumSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetricH20V10,
      child: Container(
        decoration: _decoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleSection(),
            Divider(color: AppColors.dividerColor),
            _IconWithTextSection(
              text: AppStrings.whyPremiumSection2,
              icon: FontAwesomeIcons.volumeXmark,
            ),
            _IconWithTextSection(
              text: AppStrings.whyPremiumSection3,
              icon: FontAwesomeIcons.arrowsDownToLine,
            ),
            _IconWithTextSection(
              text: AppStrings.whyPremiumSection4,
              icon: FontAwesomeIcons.shuffle,
            ),
            _IconWithTextSection(
              text: AppStrings.whyPremiumSection5,
              icon: FontAwesomeIcons.headphones,
            ),
            _IconWithTextSection(
              text: AppStrings.whyPremiumSection6,
              icon: FontAwesomeIcons.userGroup,
            ),
            _IconWithTextSection(
              text: AppStrings.whyPremiumSection7,
              icon: FontAwesomeIcons.list,
            ),
          ],
        ),
      ),
    );
  }

  Padding _titleSection() {
    return Padding(
      padding: AppPaddings.symmetricH20V10,
      child: Text(
        AppStrings.whyPremiumSection1,
        style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontSize22),
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: AppColors.planSectionColor,
      borderRadius: BorderRadius.circular(10),
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
    final EdgeInsets padding = const EdgeInsets.only(
      left: 20,
      top: 20,
      bottom: 10,
    );
    final double fontSize = 22;
    return Padding(
      padding: AppPaddings.symmetricH20V10,
      child: Container(
        decoration: _decoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (title?.isNotEmpty ?? false)
                ? _topLeftContainer()
                : SizedBox.shrink(),
            Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _premiumWithTitleSection(),
                  _titleSection(fontSize),
                  _priceSection(),
                  (priceDesciription?.isNotEmpty ?? false)
                      ? _priceDesciription()
                      : SizedBox.shrink(),
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
      padding: AppPaddings.symmetricH20V5,
      child: Container(
        height: AppSizes.size45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Padding(
            padding: AppPaddings.horizontal20,
            child: Text(
              buttonTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _planDetailSection() {
    return Padding(
      padding: AppPaddings.symmetricH20V5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: packageDetails.map((detail) {
          return Padding(
            padding: AppPaddings.bottom10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Point(paddingValue: 8),
                Expanded(
                  child: Text(detail, style: TextStyle(color: AppColors.white)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Text _priceDesciription() {
    return Text(
      priceDesciription!,
      style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSize),
    );
  }

  Text _priceSection() {
    return Text(
      price,
      style: TextStyle(
        color: AppColors.white,
        fontSize: AppSizes.fontSize16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Padding _titleSection(double fontSize) {
    return Padding(
      padding: AppPaddings.bottom10,
      child: Text(
        subtitle,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Padding _premiumWithTitleSection() {
    return Padding(
      padding: AppPaddings.bottom10,
      child: Row(
        children: [
          Padding(
            padding: AppPaddings.right8,
            child: FaIcon(
              FontAwesomeIcons.spotify,
              size: 15,
              color: Colors.white,
            ),
          ),
          Text(
            AppStrings.premium,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Container _topLeftContainer() {
    final double width = 120;
    final double height = 25;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          title!,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w800,
            fontSize: AppSizes.fontSize,
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: AppColors.planSectionColor,
      borderRadius: BorderRadius.circular(10),
    );
  }

  Padding _divider() {
    return Padding(
      padding: AppPaddings.horizontal20,
      child: Divider(color: AppColors.dividerColor),
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
      padding: AppPaddings.symmetricH20V10,
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSize),
          children: [
            (conditions1?.isNotEmpty ?? false)
                ? TextSpan(text: conditions1)
                : _emptyTextSpan(),
            (conditions2?.isNotEmpty ?? false)
                ? TextSpan(
                    text: conditions2,
                    style: TextStyle(decoration: TextDecoration.underline),
                  )
                : _emptyTextSpan(),
            (conditions3?.isNotEmpty ?? false)
                ? TextSpan(text: conditions3)
                : _emptyTextSpan(),
          ],
        ),
      ),
    );
  }

  TextSpan _emptyTextSpan() => TextSpan(text: AppStrings.emty);
}

class _IconWithTextSection extends StatelessWidget {
  const _IconWithTextSection({
    required this.text,
    required this.icon,
  });
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.all8,
      child: Row(
        children: [
          Padding(
            padding: AppPaddings.all8,
            child: FaIcon(
              icon,
              size: AppSizes.iconSize,
              color: AppColors.white,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.fontSize16,
            ),
          ),
        ],
      ),
    );
  }
}
