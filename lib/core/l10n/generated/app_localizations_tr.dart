// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get bottomNavigatorHome => 'Ana Sayfa';

  @override
  String get bottomNavigatorSearch => 'Ara';

  @override
  String get bottomNavigatorLibrary => 'Kitaplığın';

  @override
  String get bottomNavigatorPremium => 'Premium';

  @override
  String get bottomNavigatorCreate => 'Oluştur';

  @override
  String get miniPlayerNextTrack => 'Sonraki parça';

  @override
  String get miniPlayerPreviousTrack => 'Önceki parça';

  @override
  String get searchViewTitle => 'Hepsine göz at';

  @override
  String get searchViewSearchBarText => 'Ne dinlemek istiyorsun?';

  @override
  String get drawerProfileView => 'Profili görüntüle';

  @override
  String get drawerAddAccount => 'Hesap ekle';

  @override
  String get drawerUpdates => 'Yenilikler';

  @override
  String get drawerListeningStats => 'Dinleme istatistikleri';

  @override
  String get drawerRecentlyPlayed => 'Son çalınanlar';

  @override
  String get drawerNotifications => 'Güncellemelerin';

  @override
  String get drawerSettingsPrivacy => 'Ayarlar ve gizlilik';

  @override
  String get premiumViewPremium => 'Premium';

  @override
  String premiumViewTitle(String monthCount, String price) {
    return 'Premium\'a geri dön: Spotify\'a üye olduğunda ilk $monthCount ay boyunca $price*';
  }

  @override
  String get premiumViewSubtitle => 'Sınırlı süreli teklif';

  @override
  String get premiumViewGetIndividual => 'Premium\'u edin';

  @override
  String get premiumViewGetStudent => 'Premium Öğrenci planını edin';

  @override
  String get premiumViewGetDuo => 'Premium Duo planını edin';

  @override
  String get premiumViewGetFamily => 'Premium Aile planını edin';

  @override
  String get premiumViewPlanIndividual => 'Bireysel';

  @override
  String get premiumViewPlanStudent => 'Öğrenci';

  @override
  String get premiumViewPlanDuo => 'Duo';

  @override
  String get premiumViewPlanFamily => 'Aile';

  @override
  String get premiumViewPlanIndividualAccount => '1 Premium hesabı';

  @override
  String get premiumViewPlanIndividualCancel => 'İstediğin zaman iptal et';

  @override
  String get premiumViewPlanStudentAccount => 'Doğrulanmış 1 Premium hesabı';

  @override
  String get premiumViewPlanStudentDiscount =>
      'Koşulları sağlayan öğrenciler için indirim';

  @override
  String get premiumViewPlanStudentCancel => 'İstediğin zaman iptal et';

  @override
  String get premiumViewPlanDuoAccount => '2 Premium hesap';

  @override
  String get premiumViewPlanDuoCancel => 'İstediğin zaman iptal et';

  @override
  String get premiumViewPlanFamilyAccount => '6 Premium hesap';

  @override
  String get premiumViewPlanFamilyControl =>
      'Sansürsüz olarak işaretlenen içerikleri kontrol et';

  @override
  String get premiumViewPlanFamilyCancel => 'İstediğin zaman iptal et';

  @override
  String premiumViewPlanPricePromo(String monthCount, String price) {
    return '$monthCount ay boyunca $price';
  }

  @override
  String premiumViewPlanPriceAfterPromo(String price) {
    return 'Sonra ayda $price';
  }

  @override
  String premiumViewPlanPricePerMonth(String price) {
    return '$price/ay';
  }

  @override
  String get premiumViewWhyJoinTitle => 'Neden Premium\'a katılmalısın?';

  @override
  String get premiumViewWhyFeatureAdFree => 'Reklamsız müzik dinle';

  @override
  String get premiumViewWhyFeatureOffline => 'İndir ve çevrimdışı dinle';

  @override
  String get premiumViewWhyFeatureOnDemand => 'Şarkıları istediğin sırada çal';

  @override
  String get premiumViewWhyFeatureHighQuality => 'Yüksek ses kalitesi';

  @override
  String get premiumViewWhyFeatureGroupListening =>
      'Arkadaşlarınla aynı anda dinle';

  @override
  String get premiumViewWhyFeatureQueueEditing => 'Dinleme sıranı düzenle';

  @override
  String get premiumViewCurrentPlansTitle => 'Mevcut Planlar';

  @override
  String premiumViewPromoShortWelcome(int monthCount, String price) {
    return '$monthCount ay boyunca $price';
  }

  @override
  String premiumViewTermsIndividualWelcome(
    String monthCount,
    String promoPrice,
    String standardPrice,
  ) {
    return 'İlk $monthCount ay boyunca $promoPrice, sonra ayda $standardPrice. Premium Bireysel için tekrar hoş geldin teklifi. Premium\'a erişimi 30 günden uzun süre önce sona eren ve son 24 ay içinde hiçbir \"tekrar hoş geldin\" teklifinden yararlanmamış olan kullanıcılar tarafından kullanılabilir. Sadece Spotify aracılığıyla üye olan kişiler tekliften yararlanabilir. Google Play\'de teklifler farklı olabilir.';
  }

  @override
  String get premiumViewTermsApply => 'Koşullar geçerlidir.';

  @override
  String premiumViewTermsExpiryDate(String date) {
    return 'Teklif $date tarihinde sona erecek.';
  }

  @override
  String premiumViewConditionsIndividual(
    String monthCount,
    String promoPrice,
    String standardPrice,
  ) {
    return 'İlk $monthCount ay boyunca $promoPrice, sonra ayda $standardPrice. Premium Bireysel için tekrar hoş geldin teklifi. Premium\'a erişimi 30 günden uzun süre önce sona eren ve son 24 ay içinde hiçbir \"tekrar hoş geldin\" teklifinden yararlanmamış olan kullanıcılar tarafından kullanılabilir. Sadece Spotify aracılığıyla üye olan kişiler tekliften yararlanabilir. Google Play\'de teklifler farklı olabilir.';
  }

  @override
  String get premiumViewConditionsStudent =>
      'Teklif, yalnızca geçerli yükseköğretim kurumlarındaki öğrenciler içindir.';

  @override
  String get premiumViewConditionsDuo => 'Aynı adreste yaşayan çiftler için.';

  @override
  String get premiumViewConditionsFamily =>
      'Aynı adreste oturan en fazla 6 aile üyesi için.';

  @override
  String get premiumViewConditionsGeneralTerms => 'Koşullar geçerlidir.';

  @override
  String premiumViewConditionsExpiryDate(String date) {
    return 'Teklif $date tarihinde sona erecek.';
  }

  @override
  String get playerViewMenuDownload => 'İndir';

  @override
  String get playerViewMenuDeleteDownload => 'İndirilenlerden Kaldır';

  @override
  String get playerViewMenuShare => 'Paylaş';

  @override
  String get playerViewMenuAddPlaylist => 'Başka bir çalma listesine ekle';

  @override
  String get playerViewMenuHideAlbum => 'Bu albümde gizle';

  @override
  String get playerViewMenuAdFree => 'Müzikleri reklamsız dinle';

  @override
  String get playerViewMenuAddQueue => 'Sıraya Ekle';

  @override
  String get playerViewMenuGoQueue => 'Çalma Sırasına git';

  @override
  String get playerViewMenuGoAlbum => 'Albüme git';

  @override
  String get playerViewMenuGoArtist => 'Sanatçıya git';

  @override
  String get playerViewMenuStartJam => 'Jam başlat';

  @override
  String get playerViewMenuExcludeTaste =>
      'Parçayı müzik zevki profilinden hariç tut';

  @override
  String get playerViewMenuSleepTimer => 'Otomatik kapatma';

  @override
  String get playerViewMenuSongRadio => 'Şarkı radyosuna git';

  @override
  String get playerViewMenuContributors =>
      'Şarkıya katkıda bulunanları görüntüle';

  @override
  String get playerViewMenuSpotifyCode => 'Spotify kodunu göster';

  @override
  String get playerViewMenuListenModes => 'Dinleme modları';

  @override
  String get playerViewMenuAutoNext => 'Otomatik oynatma';

  @override
  String get playerViewMenuMixPlay => 'Karışık çal';

  @override
  String get playerViewMenuPlayInOrder => 'Sırayla çal';

  @override
  String get createPlaylistTitle => 'Çalma listesi';

  @override
  String get createPlaylistSubtitle =>
      'Şarkı veya bölüm içeren bir çalma listesi oluştur';

  @override
  String get createCollaborativeTitle => 'Ortak çalma listesi';

  @override
  String get createCollaborativeSubtitle =>
      'Arkadaşlarınla birlikte çalma listesi oluştur';

  @override
  String get createBlendTitle => 'Blend';

  @override
  String get createBlendSubtitle =>
      'Arkadaşlarının zevklerini bir çalma listesinde buluştur';

  @override
  String get createPlaylistViewDialogPlaylistNameHint =>
      'Çalma listene bir isim ver';

  @override
  String myPlaylistHint(String count) {
    return '$count. çalma listem';
  }

  @override
  String get createPlaylistViewCancel => 'İptal';

  @override
  String get createPlaylistViewCreate => 'Oluştur';

  @override
  String get updatePlaylistViewChange => 'Değiştir';

  @override
  String get updatePlaylistViewRefresh => 'Yenile';

  @override
  String get updatePlaylistViewPlaylistAddToThis => 'Bu çalma listesine ekle';

  @override
  String get updatePlaylistViewPlaylistRecommendedTitle => 'Önerilen Şarkılar';

  @override
  String get updatePlaylistViewPlaylistNoRecommendations =>
      'Önerilebilecek şarkı yok';

  @override
  String get shareVisibilityTitle =>
      'Çalma listesini başkalarıyla paylaşmak ister misin?';

  @override
  String get shareVisibilitySubtitle =>
      'Bu çalma listesine davet ettiğin kişiler şarkı ekleyebilir ve çıkarabilir.';

  @override
  String get shareVisibilityMakePublic => 'Paylaşılabilir yap';

  @override
  String get shareVisibilityCancel => 'İptal';

  @override
  String get playlistDeleteAlertDialogDeletePlaylistTitle =>
      'Çalma listesini sil?';

  @override
  String get playlistDeleteAlertCancel => 'İptal';

  @override
  String get playlistDeleteAlertDelete => 'Sil';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterMusic => 'Müzik';

  @override
  String get filterPodcasts => 'Podcast\'ler';

  @override
  String get filterArtists => 'Sanatçılar';

  @override
  String get filterAlbums => 'Albümler';

  @override
  String get filterPlaylists => 'Çalma Listelerin';

  @override
  String get filterDownloads => 'İndirilenler';

  @override
  String get homeViewYourPlaylists => 'Çalma Listelerin';

  @override
  String get homeViewNewReleases => 'Yeni Çıkanlar';

  @override
  String get homeViewYourFavoriteArtists => 'Sevdiğin Sanatçılar';

  @override
  String get libraryViewEmtyDownloadedList => 'Sonuç bulunamadi';

  @override
  String get mediaTypePlaylist => 'ÇALMA LİSTESİNDEN ÇALINIYOR';

  @override
  String get mediaTypeAlbum => 'ALBUMDEN ÇALINIYOR';

  @override
  String get mediaTypeArtist => 'SANATÇILARDAN ÇALINIYOR';

  @override
  String get mediaTypeShow => 'PODCAST\'TEN ÇALINIYOR';

  @override
  String get mediaTypeDownloaded => 'İNDİRİLENLERDEN ÇALINIYOR';
}
