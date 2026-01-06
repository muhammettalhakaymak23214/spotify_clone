import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('tr'),
    Locale('en'),
  ];

  /// No description provided for @bottomNavigatorHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get bottomNavigatorHome;

  /// No description provided for @bottomNavigatorSearch.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get bottomNavigatorSearch;

  /// No description provided for @bottomNavigatorLibrary.
  ///
  /// In tr, this message translates to:
  /// **'Kitaplığın'**
  String get bottomNavigatorLibrary;

  /// No description provided for @bottomNavigatorPremium.
  ///
  /// In tr, this message translates to:
  /// **'Premium'**
  String get bottomNavigatorPremium;

  /// No description provided for @bottomNavigatorCreate.
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get bottomNavigatorCreate;

  /// No description provided for @miniPlayerNextTrack.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki parça'**
  String get miniPlayerNextTrack;

  /// No description provided for @miniPlayerPreviousTrack.
  ///
  /// In tr, this message translates to:
  /// **'Önceki parça'**
  String get miniPlayerPreviousTrack;

  /// No description provided for @searchViewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hepsine göz at'**
  String get searchViewTitle;

  /// No description provided for @searchViewSearchBarText.
  ///
  /// In tr, this message translates to:
  /// **'Ne dinlemek istiyorsun?'**
  String get searchViewSearchBarText;

  /// No description provided for @drawerProfileView.
  ///
  /// In tr, this message translates to:
  /// **'Profili görüntüle'**
  String get drawerProfileView;

  /// No description provided for @drawerAddAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap ekle'**
  String get drawerAddAccount;

  /// No description provided for @drawerUpdates.
  ///
  /// In tr, this message translates to:
  /// **'Yenilikler'**
  String get drawerUpdates;

  /// No description provided for @drawerListeningStats.
  ///
  /// In tr, this message translates to:
  /// **'Dinleme istatistikleri'**
  String get drawerListeningStats;

  /// No description provided for @drawerRecentlyPlayed.
  ///
  /// In tr, this message translates to:
  /// **'Son çalınanlar'**
  String get drawerRecentlyPlayed;

  /// No description provided for @drawerNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Güncellemelerin'**
  String get drawerNotifications;

  /// No description provided for @drawerSettingsPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar ve gizlilik'**
  String get drawerSettingsPrivacy;

  /// No description provided for @premiumViewPremium.
  ///
  /// In tr, this message translates to:
  /// **'Premium'**
  String get premiumViewPremium;

  /// No description provided for @premiumViewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Premium\'a geri dön: Spotify\'a üye olduğunda ilk {monthCount} ay boyunca {price}*'**
  String premiumViewTitle(String monthCount, String price);

  /// No description provided for @premiumViewSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınırlı süreli teklif'**
  String get premiumViewSubtitle;

  /// No description provided for @premiumViewGetIndividual.
  ///
  /// In tr, this message translates to:
  /// **'Premium\'u edin'**
  String get premiumViewGetIndividual;

  /// No description provided for @premiumViewGetStudent.
  ///
  /// In tr, this message translates to:
  /// **'Premium Öğrenci planını edin'**
  String get premiumViewGetStudent;

  /// No description provided for @premiumViewGetDuo.
  ///
  /// In tr, this message translates to:
  /// **'Premium Duo planını edin'**
  String get premiumViewGetDuo;

  /// No description provided for @premiumViewGetFamily.
  ///
  /// In tr, this message translates to:
  /// **'Premium Aile planını edin'**
  String get premiumViewGetFamily;

  /// No description provided for @premiumViewPlanIndividual.
  ///
  /// In tr, this message translates to:
  /// **'Bireysel'**
  String get premiumViewPlanIndividual;

  /// No description provided for @premiumViewPlanStudent.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci'**
  String get premiumViewPlanStudent;

  /// No description provided for @premiumViewPlanDuo.
  ///
  /// In tr, this message translates to:
  /// **'Duo'**
  String get premiumViewPlanDuo;

  /// No description provided for @premiumViewPlanFamily.
  ///
  /// In tr, this message translates to:
  /// **'Aile'**
  String get premiumViewPlanFamily;

  /// No description provided for @premiumViewPlanIndividualAccount.
  ///
  /// In tr, this message translates to:
  /// **'1 Premium hesabı'**
  String get premiumViewPlanIndividualAccount;

  /// No description provided for @premiumViewPlanIndividualCancel.
  ///
  /// In tr, this message translates to:
  /// **'İstediğin zaman iptal et'**
  String get premiumViewPlanIndividualCancel;

  /// No description provided for @premiumViewPlanStudentAccount.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulanmış 1 Premium hesabı'**
  String get premiumViewPlanStudentAccount;

  /// No description provided for @premiumViewPlanStudentDiscount.
  ///
  /// In tr, this message translates to:
  /// **'Koşulları sağlayan öğrenciler için indirim'**
  String get premiumViewPlanStudentDiscount;

  /// No description provided for @premiumViewPlanStudentCancel.
  ///
  /// In tr, this message translates to:
  /// **'İstediğin zaman iptal et'**
  String get premiumViewPlanStudentCancel;

  /// No description provided for @premiumViewPlanDuoAccount.
  ///
  /// In tr, this message translates to:
  /// **'2 Premium hesap'**
  String get premiumViewPlanDuoAccount;

  /// No description provided for @premiumViewPlanDuoCancel.
  ///
  /// In tr, this message translates to:
  /// **'İstediğin zaman iptal et'**
  String get premiumViewPlanDuoCancel;

  /// No description provided for @premiumViewPlanFamilyAccount.
  ///
  /// In tr, this message translates to:
  /// **'6 Premium hesap'**
  String get premiumViewPlanFamilyAccount;

  /// No description provided for @premiumViewPlanFamilyControl.
  ///
  /// In tr, this message translates to:
  /// **'Sansürsüz olarak işaretlenen içerikleri kontrol et'**
  String get premiumViewPlanFamilyControl;

  /// No description provided for @premiumViewPlanFamilyCancel.
  ///
  /// In tr, this message translates to:
  /// **'İstediğin zaman iptal et'**
  String get premiumViewPlanFamilyCancel;

  /// No description provided for @premiumViewPlanPricePromo.
  ///
  /// In tr, this message translates to:
  /// **'{monthCount} ay boyunca {price}'**
  String premiumViewPlanPricePromo(String monthCount, String price);

  /// No description provided for @premiumViewPlanPriceAfterPromo.
  ///
  /// In tr, this message translates to:
  /// **'Sonra ayda {price}'**
  String premiumViewPlanPriceAfterPromo(String price);

  /// No description provided for @premiumViewPlanPricePerMonth.
  ///
  /// In tr, this message translates to:
  /// **'{price}/ay'**
  String premiumViewPlanPricePerMonth(String price);

  /// No description provided for @premiumViewWhyJoinTitle.
  ///
  /// In tr, this message translates to:
  /// **'Neden Premium\'a katılmalısın?'**
  String get premiumViewWhyJoinTitle;

  /// No description provided for @premiumViewWhyFeatureAdFree.
  ///
  /// In tr, this message translates to:
  /// **'Reklamsız müzik dinle'**
  String get premiumViewWhyFeatureAdFree;

  /// No description provided for @premiumViewWhyFeatureOffline.
  ///
  /// In tr, this message translates to:
  /// **'İndir ve çevrimdışı dinle'**
  String get premiumViewWhyFeatureOffline;

  /// No description provided for @premiumViewWhyFeatureOnDemand.
  ///
  /// In tr, this message translates to:
  /// **'Şarkıları istediğin sırada çal'**
  String get premiumViewWhyFeatureOnDemand;

  /// No description provided for @premiumViewWhyFeatureHighQuality.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek ses kalitesi'**
  String get premiumViewWhyFeatureHighQuality;

  /// No description provided for @premiumViewWhyFeatureGroupListening.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlarınla aynı anda dinle'**
  String get premiumViewWhyFeatureGroupListening;

  /// No description provided for @premiumViewWhyFeatureQueueEditing.
  ///
  /// In tr, this message translates to:
  /// **'Dinleme sıranı düzenle'**
  String get premiumViewWhyFeatureQueueEditing;

  /// No description provided for @premiumViewCurrentPlansTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut Planlar'**
  String get premiumViewCurrentPlansTitle;

  /// No description provided for @premiumViewPromoShortWelcome.
  ///
  /// In tr, this message translates to:
  /// **'{monthCount} ay boyunca {price}'**
  String premiumViewPromoShortWelcome(int monthCount, String price);

  /// No description provided for @premiumViewTermsIndividualWelcome.
  ///
  /// In tr, this message translates to:
  /// **'İlk {monthCount} ay boyunca {promoPrice}, sonra ayda {standardPrice}. Premium Bireysel için tekrar hoş geldin teklifi. Premium\'a erişimi 30 günden uzun süre önce sona eren ve son 24 ay içinde hiçbir \"tekrar hoş geldin\" teklifinden yararlanmamış olan kullanıcılar tarafından kullanılabilir. Sadece Spotify aracılığıyla üye olan kişiler tekliften yararlanabilir. Google Play\'de teklifler farklı olabilir.'**
  String premiumViewTermsIndividualWelcome(
    String monthCount,
    String promoPrice,
    String standardPrice,
  );

  /// No description provided for @premiumViewTermsApply.
  ///
  /// In tr, this message translates to:
  /// **'Koşullar geçerlidir.'**
  String get premiumViewTermsApply;

  /// No description provided for @premiumViewTermsExpiryDate.
  ///
  /// In tr, this message translates to:
  /// **'Teklif {date} tarihinde sona erecek.'**
  String premiumViewTermsExpiryDate(String date);

  /// No description provided for @premiumViewConditionsIndividual.
  ///
  /// In tr, this message translates to:
  /// **'İlk {monthCount} ay boyunca {promoPrice}, sonra ayda {standardPrice}. Premium Bireysel için tekrar hoş geldin teklifi. Premium\'a erişimi 30 günden uzun süre önce sona eren ve son 24 ay içinde hiçbir \"tekrar hoş geldin\" teklifinden yararlanmamış olan kullanıcılar tarafından kullanılabilir. Sadece Spotify aracılığıyla üye olan kişiler tekliften yararlanabilir. Google Play\'de teklifler farklı olabilir.'**
  String premiumViewConditionsIndividual(
    String monthCount,
    String promoPrice,
    String standardPrice,
  );

  /// No description provided for @premiumViewConditionsStudent.
  ///
  /// In tr, this message translates to:
  /// **'Teklif, yalnızca geçerli yükseköğretim kurumlarındaki öğrenciler içindir.'**
  String get premiumViewConditionsStudent;

  /// No description provided for @premiumViewConditionsDuo.
  ///
  /// In tr, this message translates to:
  /// **'Aynı adreste yaşayan çiftler için.'**
  String get premiumViewConditionsDuo;

  /// No description provided for @premiumViewConditionsFamily.
  ///
  /// In tr, this message translates to:
  /// **'Aynı adreste oturan en fazla 6 aile üyesi için.'**
  String get premiumViewConditionsFamily;

  /// No description provided for @premiumViewConditionsGeneralTerms.
  ///
  /// In tr, this message translates to:
  /// **'Koşullar geçerlidir.'**
  String get premiumViewConditionsGeneralTerms;

  /// No description provided for @premiumViewConditionsExpiryDate.
  ///
  /// In tr, this message translates to:
  /// **'Teklif {date} tarihinde sona erecek.'**
  String premiumViewConditionsExpiryDate(String date);

  /// No description provided for @playerViewMenuDownload.
  ///
  /// In tr, this message translates to:
  /// **'İndir'**
  String get playerViewMenuDownload;

  /// No description provided for @playerViewMenuDeleteDownload.
  ///
  /// In tr, this message translates to:
  /// **'İndirilenlerden Kaldır'**
  String get playerViewMenuDeleteDownload;

  /// No description provided for @playerViewMenuShare.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get playerViewMenuShare;

  /// No description provided for @playerViewMenuAddPlaylist.
  ///
  /// In tr, this message translates to:
  /// **'Başka bir çalma listesine ekle'**
  String get playerViewMenuAddPlaylist;

  /// No description provided for @playerViewMenuHideAlbum.
  ///
  /// In tr, this message translates to:
  /// **'Bu albümde gizle'**
  String get playerViewMenuHideAlbum;

  /// No description provided for @playerViewMenuAdFree.
  ///
  /// In tr, this message translates to:
  /// **'Müzikleri reklamsız dinle'**
  String get playerViewMenuAdFree;

  /// No description provided for @playerViewMenuAddQueue.
  ///
  /// In tr, this message translates to:
  /// **'Sıraya Ekle'**
  String get playerViewMenuAddQueue;

  /// No description provided for @playerViewMenuGoQueue.
  ///
  /// In tr, this message translates to:
  /// **'Çalma Sırasına git'**
  String get playerViewMenuGoQueue;

  /// No description provided for @playerViewMenuGoAlbum.
  ///
  /// In tr, this message translates to:
  /// **'Albüme git'**
  String get playerViewMenuGoAlbum;

  /// No description provided for @playerViewMenuGoArtist.
  ///
  /// In tr, this message translates to:
  /// **'Sanatçıya git'**
  String get playerViewMenuGoArtist;

  /// No description provided for @playerViewMenuStartJam.
  ///
  /// In tr, this message translates to:
  /// **'Jam başlat'**
  String get playerViewMenuStartJam;

  /// No description provided for @playerViewMenuExcludeTaste.
  ///
  /// In tr, this message translates to:
  /// **'Parçayı müzik zevki profilinden hariç tut'**
  String get playerViewMenuExcludeTaste;

  /// No description provided for @playerViewMenuSleepTimer.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik kapatma'**
  String get playerViewMenuSleepTimer;

  /// No description provided for @playerViewMenuSongRadio.
  ///
  /// In tr, this message translates to:
  /// **'Şarkı radyosuna git'**
  String get playerViewMenuSongRadio;

  /// No description provided for @playerViewMenuContributors.
  ///
  /// In tr, this message translates to:
  /// **'Şarkıya katkıda bulunanları görüntüle'**
  String get playerViewMenuContributors;

  /// No description provided for @playerViewMenuSpotifyCode.
  ///
  /// In tr, this message translates to:
  /// **'Spotify kodunu göster'**
  String get playerViewMenuSpotifyCode;

  /// No description provided for @playerViewMenuListenModes.
  ///
  /// In tr, this message translates to:
  /// **'Dinleme modları'**
  String get playerViewMenuListenModes;

  /// No description provided for @playerViewMenuAutoNext.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik oynatma'**
  String get playerViewMenuAutoNext;

  /// No description provided for @playerViewMenuMixPlay.
  ///
  /// In tr, this message translates to:
  /// **'Karışık çal'**
  String get playerViewMenuMixPlay;

  /// No description provided for @playerViewMenuPlayInOrder.
  ///
  /// In tr, this message translates to:
  /// **'Sırayla çal'**
  String get playerViewMenuPlayInOrder;

  /// No description provided for @createPlaylistTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalma listesi'**
  String get createPlaylistTitle;

  /// No description provided for @createPlaylistSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Şarkı veya bölüm içeren bir çalma listesi oluştur'**
  String get createPlaylistSubtitle;

  /// No description provided for @createCollaborativeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ortak çalma listesi'**
  String get createCollaborativeTitle;

  /// No description provided for @createCollaborativeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlarınla birlikte çalma listesi oluştur'**
  String get createCollaborativeSubtitle;

  /// No description provided for @createBlendTitle.
  ///
  /// In tr, this message translates to:
  /// **'Blend'**
  String get createBlendTitle;

  /// No description provided for @createBlendSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlarının zevklerini bir çalma listesinde buluştur'**
  String get createBlendSubtitle;

  /// No description provided for @createPlaylistViewDialogPlaylistNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Çalma listene bir isim ver'**
  String get createPlaylistViewDialogPlaylistNameHint;

  /// No description provided for @myPlaylistHint.
  ///
  /// In tr, this message translates to:
  /// **'{count}. çalma listem'**
  String myPlaylistHint(String count);

  /// No description provided for @createPlaylistViewCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get createPlaylistViewCancel;

  /// No description provided for @createPlaylistViewCreate.
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get createPlaylistViewCreate;

  /// No description provided for @updatePlaylistViewChange.
  ///
  /// In tr, this message translates to:
  /// **'Değiştir'**
  String get updatePlaylistViewChange;

  /// No description provided for @updatePlaylistViewRefresh.
  ///
  /// In tr, this message translates to:
  /// **'Yenile'**
  String get updatePlaylistViewRefresh;

  /// No description provided for @updatePlaylistViewPlaylistAddToThis.
  ///
  /// In tr, this message translates to:
  /// **'Bu çalma listesine ekle'**
  String get updatePlaylistViewPlaylistAddToThis;

  /// No description provided for @updatePlaylistViewPlaylistRecommendedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen Şarkılar'**
  String get updatePlaylistViewPlaylistRecommendedTitle;

  /// No description provided for @updatePlaylistViewPlaylistNoRecommendations.
  ///
  /// In tr, this message translates to:
  /// **'Önerilebilecek şarkı yok'**
  String get updatePlaylistViewPlaylistNoRecommendations;

  /// No description provided for @shareVisibilityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalma listesini başkalarıyla paylaşmak ister misin?'**
  String get shareVisibilityTitle;

  /// No description provided for @shareVisibilitySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu çalma listesine davet ettiğin kişiler şarkı ekleyebilir ve çıkarabilir.'**
  String get shareVisibilitySubtitle;

  /// No description provided for @shareVisibilityMakePublic.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşılabilir yap'**
  String get shareVisibilityMakePublic;

  /// No description provided for @shareVisibilityCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get shareVisibilityCancel;

  /// No description provided for @playlistDeleteAlertDialogDeletePlaylistTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalma listesini sil?'**
  String get playlistDeleteAlertDialogDeletePlaylistTitle;

  /// No description provided for @playlistDeleteAlertCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get playlistDeleteAlertCancel;

  /// No description provided for @playlistDeleteAlertDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get playlistDeleteAlertDelete;

  /// No description provided for @filterAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get filterAll;

  /// No description provided for @filterMusic.
  ///
  /// In tr, this message translates to:
  /// **'Müzik'**
  String get filterMusic;

  /// No description provided for @filterPodcasts.
  ///
  /// In tr, this message translates to:
  /// **'Podcast\'ler'**
  String get filterPodcasts;

  /// No description provided for @filterArtists.
  ///
  /// In tr, this message translates to:
  /// **'Sanatçılar'**
  String get filterArtists;

  /// No description provided for @filterAlbums.
  ///
  /// In tr, this message translates to:
  /// **'Albümler'**
  String get filterAlbums;

  /// No description provided for @filterPlaylists.
  ///
  /// In tr, this message translates to:
  /// **'Çalma Listelerin'**
  String get filterPlaylists;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'tr', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'tr':
      return AppLocalizationsTr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
