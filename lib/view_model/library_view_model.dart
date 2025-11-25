import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/core/services/artist_service.dart';
import 'package:spotify_clone/core/services/album_service.dart';
import 'package:spotify_clone/core/services/playlist_service.dart';
import 'package:spotify_clone/core/services/podcast_service.dart';
import 'package:spotify_clone/models/library_model.dart';

class LibraryViewModel {

  //Services
  final PodcastService podcastService = PodcastService();
  final PlaylistService playlistService = PlaylistService();
  final ArtistService artistService = ArtistService();
  final AlbumService albumService = AlbumService();
  //items
  final ObservableList<LibraryItem> items = ObservableList<LibraryItem>();
  //isLoading
  final Observable<bool> isLoadingArtist = Observable(false);
  final Observable<bool> isLoadingPlaylist = Observable(false);
  final Observable<bool> isLoadingAlbum = Observable(false);
  final Observable<bool> isLoadingPodcast = Observable(false);
  //dio
  final Dio dio = Dio();


  final String token;

  LibraryViewModel({required this.token});

   

  Future<void> fetchPodcast() async {
    if (isLoadingPodcast.value) {
      return;
    }
    runInAction(() {
      isLoadingPodcast.value = true;
    });
    try {
      final podcast = await podcastService.fetchPodcast(token, AppStrings.apiUrlPodcast);
      runInAction(() {
        if (podcast != null) {
          items.addAll(podcast.librarItem ?? []);
        }
      });
    } catch (e) {
      print("Error fetching playlists: $e");
    } finally {
      runInAction(() {
        isLoadingPodcast.value = false;
      });
    }
  }

  Future<void> fetchPlaylist() async {
    if (isLoadingPlaylist.value) {
      return;
    }
    runInAction(() {
      isLoadingPlaylist.value = true;
    });
    try {
      final playlist = await playlistService.fetchPlaylists(token, AppStrings.apiUrlPlaylist);
      runInAction(() {
        if (playlist != null) {
          items.addAll(playlist.librarItem ?? []);
        }
      });
    } catch (e) {
      print("Error fetching playlists: $e");
    } finally {
      runInAction(() {
        isLoadingPlaylist.value = false;
      });
    }
  }

  Future<void> fetchArtist() async {
    if (isLoadingArtist.value) {
      return;
    }
    runInAction(() {
      isLoadingArtist.value = true;
    });
    try {
      final artist = await artistService.fetchArtist(token,AppStrings.apiUrlArtist);
      runInAction(() {
        if (artist != null) {
          items.addAll(artist.librarItem ?? []);
        }
      });
    } catch (e) {
      print("Error fetching playlists: $e");
    } finally {
      runInAction(() {
        isLoadingArtist.value = false;
      });
    }
  }

  Future<void> fetchAlbum() async {
    if (isLoadingAlbum.value) {
      return;
    }
    runInAction(() {
      isLoadingAlbum.value = true;
    });
    try {
      final albums = await albumService.fetchAlbum(token, AppStrings.apiUrlAlbum);

      runInAction(() {
        if (albums != null) {
          items.addAll(albums.librarItem ?? []);
        }
      });
    } catch (e) {
      print("Error fetching playlists: $e");
    } finally {
      runInAction(() {
        isLoadingAlbum.value = false;
      });
    }
  }
}
