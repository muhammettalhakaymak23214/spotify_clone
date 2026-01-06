// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get bottomNavigatorHome => 'الصفحة الرئيسية';

  @override
  String get bottomNavigatorSearch => 'بحث';

  @override
  String get bottomNavigatorLibrary => 'مكتبتك';

  @override
  String get bottomNavigatorPremium => 'Premium';

  @override
  String get bottomNavigatorCreate => 'إنشاء';

  @override
  String get miniPlayerNextTrack => 'الأغنية التالية';

  @override
  String get miniPlayerPreviousTrack => 'الأغنية السابقة';

  @override
  String get searchViewTitle => 'تصفح الكل';

  @override
  String get searchViewSearchBarText => 'ما الذي تريد الاستماع إليه؟';

  @override
  String get drawerProfileView => 'عرض الملف الشخصي';

  @override
  String get drawerAddAccount => 'إضافة حساب';

  @override
  String get drawerUpdates => 'ما الجديد';

  @override
  String get drawerListeningStats => 'إحصائيات الاستماع';

  @override
  String get drawerRecentlyPlayed => 'تم تشغيله مؤخراً';

  @override
  String get drawerNotifications => 'تحديثاتك';

  @override
  String get drawerSettingsPrivacy => 'الإعدادات والخصوصية';

  @override
  String get premiumViewPremium => 'Premium';

  @override
  String premiumViewTitle(String monthCount, String price) {
    return 'العودة إلى Premium: أول $monthCount أشهر مقابل $price* عند الانضمام إلى Spotify';
  }

  @override
  String get premiumViewSubtitle => 'عرض لفترة محدودة';

  @override
  String get premiumViewGetIndividual => 'احصل على Premium Individual';

  @override
  String get premiumViewGetStudent => 'احصل على Premium Student';

  @override
  String get premiumViewGetDuo => 'احصل على Premium Duo';

  @override
  String get premiumViewGetFamily => 'احصل على Premium Family';

  @override
  String get premiumViewPlanIndividual => 'فردي';

  @override
  String get premiumViewPlanStudent => 'طالب';

  @override
  String get premiumViewPlanDuo => 'Duo';

  @override
  String get premiumViewPlanFamily => 'عائلي';

  @override
  String get premiumViewPlanIndividualAccount => 'حساب Premium واحد';

  @override
  String get premiumViewPlanIndividualCancel => 'إلغاء الاشتراك في أي وقت';

  @override
  String get premiumViewPlanStudentAccount => 'حساب Premium واحد تم التحقق منه';

  @override
  String get premiumViewPlanStudentDiscount => 'خصم للطلاب المؤهلين';

  @override
  String get premiumViewPlanStudentCancel => 'إلغاء الاشتراك في أي وقت';

  @override
  String get premiumViewPlanDuoAccount => 'حسابا Premium';

  @override
  String get premiumViewPlanDuoCancel => 'إلغاء الاشتراك في أي وقت';

  @override
  String get premiumViewPlanFamilyAccount => 'ما يصل إلى 6 حسابات Premium';

  @override
  String get premiumViewPlanFamilyControl =>
      'التحكم في المحتوى المصنف كغير لائق';

  @override
  String get premiumViewPlanFamilyCancel => 'إلغاء الاشتراك في أي وقت';

  @override
  String premiumViewPlanPricePromo(String monthCount, String price) {
    return '$monthCount أشهر مقابل $price';
  }

  @override
  String premiumViewPlanPriceAfterPromo(String price) {
    return 'بعد ذلك $price شهرياً';
  }

  @override
  String premiumViewPlanPricePerMonth(String price) {
    return '$price/شهرياً';
  }

  @override
  String get premiumViewWhyJoinTitle => 'لماذا تنضم إلى Premium؟';

  @override
  String get premiumViewWhyFeatureAdFree => 'استمتع بالموسيقى بدون إعلانات';

  @override
  String get premiumViewWhyFeatureOffline =>
      'تنزيل الموسيقى للاستماع إليها بدون إنترنت';

  @override
  String get premiumViewWhyFeatureOnDemand => 'تشغيل الأغاني بأي ترتيب';

  @override
  String get premiumViewWhyFeatureHighQuality => 'جودة صوت عالية';

  @override
  String get premiumViewWhyFeatureGroupListening =>
      'استمع مع أصدقائك في نفس الوقت';

  @override
  String get premiumViewWhyFeatureQueueEditing => 'تنظيم قائمة انتظار الاستماع';

  @override
  String get premiumViewCurrentPlansTitle => 'الخطط الحالية';

  @override
  String premiumViewPromoShortWelcome(int monthCount, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      monthCount,
      locale: localeName,
      other: '$monthCount أشهر',
      many: '$monthCount شهراً',
      two: 'شهرين',
      one: 'شهر واحد',
    );
    return '$price لـ $_temp0';
  }

  @override
  String premiumViewTermsIndividualWelcome(
    String monthCount,
    String promoPrice,
    String standardPrice,
  ) {
    return 'أول $monthCount أشهر مقابل $promoPrice، ثم $standardPrice شهرياً. عرض العودة إلى Premium Individual. متاح فقط للمستخدمين الذين لم يشتركوا في Premium لأكثر من 30 يوماً. قد تختلف العروض على Google Play.';
  }

  @override
  String get premiumViewTermsApply => 'تطبق الشروط.';

  @override
  String premiumViewTermsExpiryDate(String date) {
    return 'ينتهي العرض في $date.';
  }

  @override
  String premiumViewConditionsIndividual(
    String monthCount,
    String promoPrice,
    String standardPrice,
  ) {
    return 'أول $monthCount أشهر مقابل $promoPrice، ثم $standardPrice شهرياً. عرض العودة إلى Premium Individual.';
  }

  @override
  String get premiumViewConditionsStudent =>
      'العرض متاح فقط للطلاب في مؤسسات التعليم العالي المعتمدة.';

  @override
  String get premiumViewConditionsDuo => 'لشخصين يعيشان في نفس العنوان.';

  @override
  String get premiumViewConditionsFamily =>
      'لما يصل إلى 6 أفراد من العائلة يعيشون في نفس العنوان.';

  @override
  String get premiumViewConditionsGeneralTerms => 'تطبق الشروط.';

  @override
  String premiumViewConditionsExpiryDate(String date) {
    return 'ينتهي العرض في $date.';
  }

  @override
  String get playerViewMenuDownload => 'تنزيل';

  @override
  String get playerViewMenuDeleteDownload => 'إزالة المحتوى الذي تم تنزيله';

  @override
  String get playerViewMenuShare => 'مشاركة';

  @override
  String get playerViewMenuAddPlaylist => 'إضافة إلى قائمة أغاني أخرى';

  @override
  String get playerViewMenuHideAlbum => 'إخفاء في هذا الألبوم';

  @override
  String get playerViewMenuAdFree => 'استمع إلى الموسيقى بدون إعلانات';

  @override
  String get playerViewMenuAddQueue => 'إضافة إلى قائمة الانتظار';

  @override
  String get playerViewMenuGoQueue => 'انتقل إلى قائمة الانتظar';

  @override
  String get playerViewMenuGoAlbum => 'انتقل إلى الألبوم';

  @override
  String get playerViewMenuGoArtist => 'انتقل إلى الفنان';

  @override
  String get playerViewMenuStartJam => 'ابدأ Jam';

  @override
  String get playerViewMenuExcludeTaste => 'استبعاد من ذوقك الموسيقي';

  @override
  String get playerViewMenuSleepTimer => 'إيقاف التشغيل التلقائي';

  @override
  String get playerViewMenuSongRadio => 'انتقل إلى راديو الأغنية';

  @override
  String get playerViewMenuContributors => 'عرض المساهمين في الأغنية';

  @override
  String get playerViewMenuSpotifyCode => 'عرض رمز Spotify';

  @override
  String get playerViewMenuListenModes => 'أوضاع الاستماع';

  @override
  String get playerViewMenuAutoNext => 'تشغيل تلقائي';

  @override
  String get playerViewMenuMixPlay => 'تشغيل عشوائي';

  @override
  String get playerViewMenuPlayInOrder => 'تشغيل بالترتيب';

  @override
  String get createPlaylistTitle => 'قائمة أغاني';

  @override
  String get createPlaylistSubtitle =>
      'إنشاء قائمة أغاني تحتوي على أغاني أو حلقات';

  @override
  String get createCollaborativeTitle => 'قائمة أغاني مشتركة';

  @override
  String get createCollaborativeSubtitle => 'إنشاء قائمة أغاني مع أصدقائك';

  @override
  String get createBlendTitle => 'Blend';

  @override
  String get createBlendSubtitle =>
      'اجمع بين ذوقك وذوق أصدقائك في قائمة أغاني واحدة';

  @override
  String get createPlaylistViewDialogPlaylistNameHint =>
      'اختر اسماً لقائمة الأغاني';

  @override
  String myPlaylistHint(String count) {
    return 'قائمة التشغيل رقم $count';
  }

  @override
  String get createPlaylistViewCancel => 'إلغاء';

  @override
  String get createPlaylistViewCreate => 'إنشاء';

  @override
  String get updatePlaylistViewChange => 'تغيير';

  @override
  String get updatePlaylistViewRefresh => 'تحديث';

  @override
  String get updatePlaylistViewPlaylistAddToThis => 'إضافة إلى هذه القائمة';

  @override
  String get updatePlaylistViewPlaylistRecommendedTitle => 'أغانٍ مقترحة';

  @override
  String get updatePlaylistViewPlaylistNoRecommendations =>
      'لا توجد أغانٍ مقترحة';

  @override
  String get shareVisibilityTitle =>
      'هل تريد مشاركة قائمة الأغاني هذه مع الآخرين؟';

  @override
  String get shareVisibilitySubtitle =>
      'يمكن للأشخاص الذين تدعوهم إضافة وإزالة الأغاني من هذه القائمة.';

  @override
  String get shareVisibilityMakePublic => 'اجعلها قابلة للمشاركة';

  @override
  String get shareVisibilityCancel => 'إلغاء';

  @override
  String get playlistDeleteAlertDialogDeletePlaylistTitle =>
      'حذف قائمة الأغاني؟';

  @override
  String get playlistDeleteAlertCancel => 'إلغاء';

  @override
  String get playlistDeleteAlertDelete => 'حذف';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterMusic => 'موسيقى';

  @override
  String get filterPodcasts => 'بودكاست';

  @override
  String get filterArtists => 'فنانون';

  @override
  String get filterAlbums => 'ألبومات';

  @override
  String get filterPlaylists => 'قوائم الأغاني الخاصة بك';
}
