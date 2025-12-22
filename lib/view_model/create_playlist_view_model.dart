import 'package:spotify_clone/core/services/create_playlist_service.dart';
import 'package:spotify_clone/core/services/user_profile_service.dart';
import 'package:spotify_clone/models/user_profile_model.dart';

class CreatePlaylistViewModel {
  //Services
  final CreatePlaylistService creatPlaylistService = CreatePlaylistService();
  final UserProfileService userProfileService = UserProfileService();
  //Variables
  late UserProfileModel? userProfile;
  late String totalPlaylist ;
  late String playlistId ;

  Future<void> getUserProfile() async {
    userProfile = await userProfileService.getUserProfile();
  }

  Future<void> getTotalPlaylist() async {
    final count = await  userProfileService.getTotalPlaylist();
      totalPlaylist = count;
  }

  Future<bool> createPlaylist(String name) async {
    await getUserProfile();
    final String _id = await creatPlaylistService.createPlaylist(userProfile?.id ?? "", name);
    if(_id != "null"){
      playlistId = _id;
      return true;
    }
    return false;
  }
}
