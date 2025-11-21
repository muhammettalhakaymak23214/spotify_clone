import 'package:mobx/mobx.dart';
import 'package:spotify_clone/core/constants/app_strings.dart';
import 'package:spotify_clone/models/library_model.dart';

class LibraryViewModel {
  ObservableList<LibraryItem> items = ObservableList<LibraryItem>();
  LibraryViewModel() {
    items.addAll(sampleData);
  }
  
  void addItem(){
    runInAction(() {
      items.add(LibraryItem(
      id: "1",
      title: "Sonradan eklendi",
      subTitle: "Sonradan eklendi",
      imageUrl: AppStrings.sampleImageUrl,
      type: LibraryItemType.playlists,
    ));
    });
  }
  

  final sampleData = [
    LibraryItem(
      id: "1",
      title: "1.Çalma Listem",
      subTitle: "Çalma listesi - Hüseyin",
      imageUrl: AppStrings.sampleImageUrl,
      type: LibraryItemType.playlists,
    ),
    LibraryItem(
      id: "2",
      title: "2.Çalma Listem",
      subTitle: "Çalma listesi - muhammet",
      imageUrl: AppStrings.sampleImageUrl,
      type: LibraryItemType.playlists,
    ),
    LibraryItem(
      id: "3",
      title: "Beğenilen Şarkılar",
      subTitle: "Çalma Listesi - 194 şarkı",
      imageUrl: AppStrings.sampleImageUrl,
      type: LibraryItemType.likedSongs,
    ),
    LibraryItem(
      id: "4",
      title: "The Witcher Official Playlist",
      subTitle: "Çalma Listesi - Spotify",
      imageUrl: AppStrings.sampleImageUrl,
      type: LibraryItemType.playlists,
    ),
    LibraryItem(
      id: "5",
      title: "Podcasts",
      subTitle: "Podcasts - Pınar Fildan -Seda Yüz",
      imageUrl: AppStrings.sampleImageUrl,
      type: LibraryItemType.podcasts,
    ),
    LibraryItem(
      id: "6",
      title: "Dönmek İçin Eve",
      subTitle: "Gazapizm",
      imageUrl: AppStrings.sampleImageUrl,
      type: LibraryItemType.albums,
    ),
    LibraryItem(
      id: "7",
      title: "Nefes",
      subTitle: "Serdar Ortaç",
      imageUrl: AppStrings.sampleImageUrl,
      type: LibraryItemType.albums,
    ),
    
  ];
}
