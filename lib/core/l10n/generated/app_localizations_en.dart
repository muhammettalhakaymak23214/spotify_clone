// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get bottomNavigatorHome => 'Home';

  @override
  String get bottomNavigatorSearch => 'Search';

  @override
  String get bottomNavigatorLibrary => 'Your Library';

  @override
  String get bottomNavigatorPremium => 'Premium';

  @override
  String get bottomNavigatorCreate => 'Create';

  @override
  String get miniPlayerNextTrack => 'Next track';

  @override
  String get miniPlayerPreviousTrack => 'Previous track';

  @override
  String get searchViewTitle => 'Browse all';

  @override
  String get searchViewSearchBarText => 'What do you want to listen to?';

  @override
  String get drawerProfileView => 'View profile';

  @override
  String get drawerAddAccount => 'Add account';

  @override
  String get drawerUpdates => 'What\'s new';

  @override
  String get drawerListeningStats => 'Listening stats';

  @override
  String get drawerRecentlyPlayed => 'Recently played';

  @override
  String get drawerNotifications => 'Notifications';

  @override
  String get drawerSettingsPrivacy => 'Settings and privacy';

  @override
  String get premiumViewPremium => 'Premium';

  @override
  String premiumViewTitle(String monthCount, String price) {
    return 'Get back to Premium: $monthCount months for $price* when you join Spotify';
  }

  @override
  String get premiumViewSubtitle => 'Limited time offer';

  @override
  String get premiumViewGetIndividual => 'Get Premium Individual';

  @override
  String get premiumViewGetStudent => 'Get Premium Student';

  @override
  String get premiumViewGetDuo => 'Get Premium Duo';

  @override
  String get premiumViewGetFamily => 'Get Premium Family';

  @override
  String get premiumViewPlanIndividual => 'Individual';

  @override
  String get premiumViewPlanStudent => 'Student';

  @override
  String get premiumViewPlanDuo => 'Duo';

  @override
  String get premiumViewPlanFamily => 'Family';

  @override
  String get premiumViewPlanIndividualAccount => '1 Premium account';

  @override
  String get premiumViewPlanIndividualCancel => 'Cancel anytime';

  @override
  String get premiumViewPlanStudentAccount => '1 verified Premium account';

  @override
  String get premiumViewPlanStudentDiscount => 'Discount for eligible students';

  @override
  String get premiumViewPlanStudentCancel => 'Cancel anytime';

  @override
  String get premiumViewPlanDuoAccount => '2 Premium accounts';

  @override
  String get premiumViewPlanDuoCancel => 'Cancel anytime';

  @override
  String get premiumViewPlanFamilyAccount => 'Up to 6 Premium accounts';

  @override
  String get premiumViewPlanFamilyControl =>
      'Control content marked as explicit';

  @override
  String get premiumViewPlanFamilyCancel => 'Cancel anytime';

  @override
  String premiumViewPlanPricePromo(String monthCount, String price) {
    return '$monthCount months for $price';
  }

  @override
  String premiumViewPlanPriceAfterPromo(String price) {
    return '$price per month thereafter';
  }

  @override
  String premiumViewPlanPricePerMonth(String price) {
    return '$price/month';
  }

  @override
  String get premiumViewWhyJoinTitle => 'Why join Premium?';

  @override
  String get premiumViewWhyFeatureAdFree => 'Ad-free music listening';

  @override
  String get premiumViewWhyFeatureOffline => 'Download to listen offline';

  @override
  String get premiumViewWhyFeatureOnDemand => 'Play songs in any order';

  @override
  String get premiumViewWhyFeatureHighQuality => 'High audio quality';

  @override
  String get premiumViewWhyFeatureGroupListening =>
      'Listen with friends in real time';

  @override
  String get premiumViewWhyFeatureQueueEditing =>
      'Organize your listening queue';

  @override
  String get premiumViewCurrentPlansTitle => 'Current Plans';

  @override
  String premiumViewPromoShortWelcome(int monthCount, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      monthCount,
      locale: localeName,
      other: '$monthCount months',
      one: '1 month',
    );
    return '$price for the first $_temp0';
  }

  @override
  String premiumViewTermsIndividualWelcome(
    String monthCount,
    String promoPrice,
    String standardPrice,
  ) {
    return '$promoPrice for first $monthCount months, then $standardPrice/month. Welcome back offer for Premium Individual. Only available to users who haven\'t had Premium for more than 30 days and haven\'t used a \'welcome back\' offer in the last 24 months. Only available through Spotify. Google Play offers may vary.';
  }

  @override
  String get premiumViewTermsApply => 'Terms apply.';

  @override
  String premiumViewTermsExpiryDate(String date) {
    return 'Offer ends on $date.';
  }

  @override
  String premiumViewConditionsIndividual(
    String monthCount,
    String promoPrice,
    String standardPrice,
  ) {
    return '$promoPrice for first $monthCount months, then $standardPrice/month. Welcome back offer for Premium Individual. Available only to users who have been without Premium for more than 30 days. Google Play offers may vary.';
  }

  @override
  String get premiumViewConditionsStudent =>
      'Offer available only to students at accredited higher education institutions.';

  @override
  String get premiumViewConditionsDuo =>
      'For couples residing at the same address.';

  @override
  String get premiumViewConditionsFamily =>
      'For up to 6 family members residing at the same address.';

  @override
  String get premiumViewConditionsGeneralTerms => 'Terms apply.';

  @override
  String premiumViewConditionsExpiryDate(String date) {
    return 'Offer ends on $date.';
  }

  @override
  String get playerViewMenuDownload => 'Download';

  @override
  String get playerViewMenuDeleteDownload => 'Remove Download';

  @override
  String get playerViewMenuShare => 'Share';

  @override
  String get playerViewMenuAddPlaylist => 'Add to another playlist';

  @override
  String get playerViewMenuHideAlbum => 'Hide in this album';

  @override
  String get playerViewMenuAdFree => 'Listen to music ad-free';

  @override
  String get playerViewMenuAddQueue => 'Add to Queue';

  @override
  String get playerViewMenuGoQueue => 'Go to Queue';

  @override
  String get playerViewMenuGoAlbum => 'Go to album';

  @override
  String get playerViewMenuGoArtist => 'Go to artist';

  @override
  String get playerViewMenuStartJam => 'Start a Jam';

  @override
  String get playerViewMenuExcludeTaste => 'Exclude from your taste profile';

  @override
  String get playerViewMenuSleepTimer => 'Sleep timer';

  @override
  String get playerViewMenuSongRadio => 'Go to song radio';

  @override
  String get playerViewMenuContributors => 'Show credits';

  @override
  String get playerViewMenuSpotifyCode => 'Show Spotify Code';

  @override
  String get playerViewMenuListenModes => 'Listening modes';

  @override
  String get playerViewMenuAutoNext => 'Autoplay';

  @override
  String get playerViewMenuMixPlay => 'Shuffle';

  @override
  String get playerViewMenuPlayInOrder => 'Play in order';

  @override
  String get createPlaylistTitle => 'Playlist';

  @override
  String get createPlaylistSubtitle =>
      'Create a playlist with songs or episodes';

  @override
  String get createCollaborativeTitle => 'Collaborative Playlist';

  @override
  String get createCollaborativeSubtitle =>
      'Create a playlist with your friends';

  @override
  String get createBlendTitle => 'Blend';

  @override
  String get createBlendSubtitle =>
      'Combine your tastes with friends in a playlist';

  @override
  String get createPlaylistViewDialogPlaylistNameHint =>
      'Give your playlist a name';

  @override
  String myPlaylistHint(String count) {
    return 'My playlist #$count';
  }

  @override
  String get createPlaylistViewCancel => 'Cancel';

  @override
  String get createPlaylistViewCreate => 'Create';

  @override
  String get updatePlaylistViewChange => 'Change';

  @override
  String get updatePlaylistViewRefresh => 'Refresh';

  @override
  String get updatePlaylistViewPlaylistAddToThis => 'Add to this playlist';

  @override
  String get updatePlaylistViewPlaylistRecommendedTitle => 'Recommended Songs';

  @override
  String get updatePlaylistViewPlaylistNoRecommendations =>
      'No songs to recommend';

  @override
  String get shareVisibilityTitle =>
      'Do you want to share this playlist with others?';

  @override
  String get shareVisibilitySubtitle =>
      'People you invite can add and remove songs in this playlist.';

  @override
  String get shareVisibilityMakePublic => 'Make shareable';

  @override
  String get shareVisibilityCancel => 'Cancel';

  @override
  String get playlistDeleteAlertDialogDeletePlaylistTitle => 'Delete playlist?';

  @override
  String get playlistDeleteAlertCancel => 'Cancel';

  @override
  String get playlistDeleteAlertDelete => 'Delete';

  @override
  String get filterAll => 'All';

  @override
  String get filterMusic => 'Music';

  @override
  String get filterPodcasts => 'Podcasts';

  @override
  String get filterArtists => 'Artists';

  @override
  String get filterAlbums => 'Albums';

  @override
  String get filterPlaylists => 'Your Playlists';
}
