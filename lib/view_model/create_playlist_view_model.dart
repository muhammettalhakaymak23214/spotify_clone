import 'package:flutter/material.dart';
import 'package:spotify_clone/core/services/create_playlist_service.dart';
import 'package:spotify_clone/core/services/user_profile_service.dart';
import 'package:spotify_clone/models/user_profile_model.dart';

class CreatePlaylistViewModel {
  final CreatePlaylistService creatPlaylistService = CreatePlaylistService();
  final UserProfileService userProfileService = UserProfileService();
  
  late UserProfileModel? userProfile;
  late String totalPlaylist;
  late String playlistId;
  bool isLoading = false;

  Future<void> getUserProfile() async {
    userProfile = await userProfileService.getUserProfile();
  }

  Future<void> getTotalPlaylist() async {
    final count = await userProfileService.getTotalPlaylist();
    totalPlaylist = count;
  }

  Future<void> handleCreatePlaylist({
    String? name,
    required String fallbackName,
    required VoidCallback onSuccess,
    required VoidCallback onNotify,
  }) async {
    if (isLoading) return;

    isLoading = true;
    onNotify();

    final success = await createPlaylist(
      name: name,
      fallbackName: fallbackName,
    );

    isLoading = false;
    onNotify();

    if (success) {
      onSuccess();
    }
  }

  Future<bool> createPlaylist({
    String? name,
    required String fallbackName,
  }) async {
    await getUserProfile();
    final finalName = (name != null && name.trim().isNotEmpty)
        ? name
        : fallbackName;

    final String _id = await creatPlaylistService.createPlaylist(
      userProfile?.id ?? "",
      finalName,
    );

    if (_id != "null") {
      playlistId = _id;
      return true;
    }
    
    return false;
  }
}