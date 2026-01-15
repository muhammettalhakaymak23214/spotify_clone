import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay/pay.dart';
import 'package:spotify_clone/core/constants/app_colors.dart';
import 'package:spotify_clone/core/enums/premium_plan.dart';
import 'package:spotify_clone/core/l10n/generated/app_localizations.dart';
import 'package:spotify_clone/view_model/payment_methods_view_model.dart';
import 'package:spotify_clone/widgets/custom_widgets/app_text.dart';
import 'package:spotify_clone/widgets/custom_widgets/custom_point.dart';

class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({super.key, required this.plan});

  final PremiumPlan plan;
  //final String price;
  // final String packageTitle;
  //final String packageSubtitle;

  @override
  State<PaymentMethodsView> createState() => _PaymentMethodsViewState();
}

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
  late final PaymentMethodsViewModel paymentVm;

  @override
  void initState() {
    super.initState();
    paymentVm = PaymentMethodsViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: AppText(text: AppLocalizations.of(context)!.payNow, style: AppTextStyle.titleS),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: AppText(
                text: AppLocalizations.of(context)!.changePlan,
                style: AppTextStyle.bodyM,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Divider(color: _Constants.dividerColor),
            ),
            Row(
              children: [
                Padding(
                  padding: _Constants.spotifyLogoContainerPadding,
                  child: Container(
                    height: _Constants.spotifyLogoContainerSize,
                    decoration: _Constants.spotifyLogoContainerDecoration,
                    child: Padding(
                      padding: _Constants.spotifyLogoPadding,
                      child: Image.asset("assets/png/spotify_logo.png"),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: widget.plan.getTitle(context),
                      style: AppTextStyle.titleS,
                    ),
                    AppText(
                      text: widget.plan.getSubtitle(context),
                      style: AppTextStyle.bodyS,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      text: "₺${widget.plan.price}",
                      style: AppTextStyle.titleS,
                    ),
                    AppText(text: AppLocalizations.of(context)!.perMonth, style: AppTextStyle.bodyS),
                  ],
                ),
              ],
            ),
            SizedBox(height: _Constants.premiumPackageDetailsSpaceHeight),
            Row(
              children: [
                Padding(
                  padding: _Constants.pointPadding,
                  child: Point(color: _Constants.pointColor),
                ),
                AppText(
                  text: AppLocalizations.of(context)!.monthlyBilling,
                  style: AppTextStyle.bodyS,
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: _Constants.pointPadding,
                  child: Point(color: _Constants.pointColor),
                ),
                AppText(
                  text: AppLocalizations.of(context)!.cancelAnytime,
                  style: AppTextStyle.bodyS,
                ),
                AppText(
                  text: AppLocalizations.of(context)!.termsApply,
                  style: AppTextStyle.bodyS,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.white,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Divider(color: _Constants.dividerColor),
            ),
            AppText(
              text: AppLocalizations.of(context)!.choosePaymentMethod,
              style: AppTextStyle.titleL,
            ),
            SizedBox(height: 5.h),
            AppText(
              text:
                  AppLocalizations.of(context)!.paymentChoiceDescription,
              style: AppTextStyle.bodyS,
            ),
            SizedBox(height: 20.h),
            Observer(
              builder: (_) => Row(
                children: [
                  Expanded(
                    child: PaymentOptionCard(
                      position: PaymentCardPosition.left,
                      title: 'Spotify',
                      isSelected:
                          paymentVm.selectedMethod == PaymentMethod.spotify,
                      onTap: () {
                        paymentVm.changeMethod(PaymentMethod.spotify);
                      },
                    ),
                  ),
                  Container(height: 60.h, width: 2, color: AppColors.green),
                  Expanded(
                    child: PaymentOptionCard(
                      position: PaymentCardPosition.right,
                      title: 'Google Play',
                      isSelected:
                          paymentVm.selectedMethod == PaymentMethod.googlePlay,
                      onTap: () {
                        paymentVm.changeMethod(PaymentMethod.googlePlay);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Observer(
              builder: (_) {
                switch (paymentVm.selectedMethod) {
                  case PaymentMethod.spotify:
                    return _SpotifyPaymentSection();

                  case PaymentMethod.googlePlay:
                    return _GooglePlayPaymentSection(
                      price: widget.plan.price,
                      packageTitle: widget.plan.getTitle(context),
                    );
                }
              },
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(text: "Türkiye", style: AppTextStyle.labelM),
                SizedBox(width: 20.w),
                AppText(
                  text: AppLocalizations.of(context)!.changeCountry,
                  style: AppTextStyle.labelM,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class _Constants {
  //Size
  static double get spotifyLogoContainerSize => 50.w;
  static double get premiumPackageDetailsSpaceHeight => 20.h;
  //Colors
  static Color get dividerColor => AppColors.grey;
  static Color get pointColor => AppColors.grey;
  //Padding
  static EdgeInsets get spotifyLogoPadding => EdgeInsets.all(4.0.w);
  static EdgeInsetsDirectional get spotifyLogoContainerPadding =>
      EdgeInsetsDirectional.only(end: 10.w);
  static EdgeInsetsDirectional get pointPadding =>
      EdgeInsetsDirectional.only(end: 5.w);
  //Decoration
  static BoxDecoration get spotifyLogoContainerDecoration => BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(10.r),
  );
}

class PaymentOptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final PaymentCardPosition position;

  const PaymentOptionCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = _radius();
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius is BorderRadius ? borderRadius : null,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: _radius(),
          border: _border(isSelected),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                position == PaymentCardPosition.left
                    ? "assets/png/spotify_logo.png"
                    : "assets/png/google_play_logo.png",
              ),
              SizedBox(width: 5),
              AppText(text: title, style: AppTextStyle.titleS),
            ],
          ),
        ),
      ),
    );
  }

  BorderDirectional _border(bool isSelected) {
    final Color borderColor = isSelected ? Colors.green : Colors.grey;
    const double borderWidth = 2.0;

    if (position == PaymentCardPosition.left) {
      // Sol kısımdaki kart için: Üst, Alt ve "Başlangıç" (Start)
      return BorderDirectional(
        top: BorderSide(color: borderColor, width: borderWidth),
        bottom: BorderSide(color: borderColor, width: borderWidth),
        start: BorderSide(color: borderColor, width: borderWidth),
      );
    } else {
      // Sağ kısımdaki kart için: Üst, Alt ve "Bitiş" (End)
      return BorderDirectional(
        top: BorderSide(color: borderColor, width: borderWidth),
        bottom: BorderSide(color: borderColor, width: borderWidth),
        end: BorderSide(color: borderColor, width: borderWidth),
      );
    }
  }

  BorderRadiusGeometry _radius() {
    if (position == PaymentCardPosition.left) {
      return const BorderRadiusDirectional.only(
        topStart: Radius.circular(12),
        bottomStart: Radius.circular(12),
      );
    } else {
      return const BorderRadiusDirectional.only(
        topEnd: Radius.circular(12),
        bottomEnd: Radius.circular(12),
      );
    }
  }
}

class _SpotifyPaymentSection extends StatelessWidget {
  final GlobalKey _plusKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              text:
                  AppLocalizations.of(context)!.paymentMethodDescription,
              color: AppColors.white,
              style: AppTextStyle.bodyS,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PaymentCardItem(asset: "assets/png/visa_logo.png"),
                SizedBox(width: 5.w),
                _PaymentCardItem(asset: "assets/png/mastercard_logo.png"),

                SizedBox(width: 5),
                _PaymentCardItem(asset: "assets/png/american_express_logo.png"),
                SizedBox(width: 5),
                _PaymentCardItem(asset: "assets/png/discover_logo.png"),

                SizedBox(width: 5),
                GestureDetector(
                  key: _plusKey,
                  onTap: () {
                    PaymentCardPopup.show(
                      context: context,
                      anchorKey: _plusKey,
                    );
                  },
                  child: Container(
                    height: 20.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: AppText(text: "+3", style: AppTextStyle.labelM),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                FirebaseCrashlytics.instance.crash();
              },
              child: AppText(
                text: AppLocalizations.of(context)!.continueWithSpotify,
                style: AppTextStyle.titleS,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GooglePlayPaymentSection extends StatelessWidget {
  final GlobalKey _plusKey = GlobalKey();
  final Future<PaymentConfiguration> _googlePayConfigFuture =
      PaymentConfiguration.fromAsset('configs/google_pay_payment_profile.json');
  final String price;
  final String packageTitle;

  _GooglePlayPaymentSection({
    super.key,
    required this.price,
    required this.packageTitle,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: 160.h,
          width: double.infinity,

          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  text:
                      AppLocalizations.of(context)!.googlePlayPointsInfo,
                  color: AppColors.white,
                  style: AppTextStyle.bodyS,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PaymentCardItem(asset: "assets/png/visa_logo.png"),
                    SizedBox(width: 5.w),
                    _PaymentCardItem(asset: "assets/png/mastercard_logo.png"),

                    SizedBox(width: 5),
                    _PaymentCardItem(asset: "assets/png/google_play_logo.png"),
                    SizedBox(width: 10),
                    AppText(
                      text: AppLocalizations.of(context)!.andMore,
                      style: AppTextStyle.bodyS,
                      color: AppColors.white,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FutureBuilder<PaymentConfiguration>(
                      future: _googlePayConfigFuture,
                      builder: (context, snapshot) => snapshot.hasData
                          ? SizedBox(
                              height: 56,
                              child: GooglePayButton(
                                paymentConfiguration: snapshot.data!,
                                paymentItems: [
                                  PaymentItem(
                                    label: packageTitle,
                                    amount: price,
                                    status: PaymentItemStatus.final_price,
                                  ),
                                ],
                                type: GooglePayButtonType.subscribe,
                                theme: GooglePayButtonTheme.dark,
                                width: constraints.maxWidth,
                                onPaymentResult: (result) {
                              
                                  print("Google Pay Result: $result");

                                
                                  final token =
                                      result['paymentMethodData']?['tokenizationData']?['token'];

                                  if (token != null) {
                               
                                    _showSuccessDialog(
                                      context,
                                      token.toString(),
                                    );
                                  } else {
                                    print("Token alınamadı.");
                                  }
                                },
                                loadingIndicator: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(), 
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        AppText(
          style: AppTextStyle.labelS,
          text: AppLocalizations.of(context)!.googlePlayRedirectInfo
              
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context, String googleToken) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title:  Row(
            children: [
              Icon(Icons.verified, color: Colors.green),
              SizedBox(width: 10),
              Text(AppLocalizations.of(context)!.paymentSuccessful, style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.googleTokenReceived,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  googleToken,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
               
              },
              child:  Text(AppLocalizations.of(context)!.close, style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}

enum PaymentCardPosition { left, right }

class PaymentCardPopup {
  static void show({
    required BuildContext context,
    required GlobalKey anchorKey,
  }) {
    final renderBox = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx - 40.w,
        offset.dy + size.height + 6.h,
        offset.dx + size.width,
        0,
      ),
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              // width: 80.w,
              // height: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PaymentCardItem(asset: "assets/png/turkcell_logo.png"),
                  SizedBox(width: 5),
                  _PaymentCardItem(asset: "assets/png/turk_telekom_logo.png"),
                  SizedBox(width: 5),
                  _PaymentCardItem(asset: "assets/png/vodofone_logo.png"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentCardItem extends StatelessWidget {
  final String asset;

  const _PaymentCardItem({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 30.w,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }
}
