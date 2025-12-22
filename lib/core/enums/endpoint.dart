enum Endpoint {
  userTopArtists,
  newReleases,
  recentlyPlayed,
  category,
  podcast,
  playlist,
  artist,
  album,
  search,
  me,
  
}

extension SpotifyEndpointPath on Endpoint {
  String get path {
    switch (this) {
      case Endpoint.userTopArtists:
        return "me/top/artists";
      case Endpoint.newReleases:
        return "browse/new-releases";
      case Endpoint.recentlyPlayed:
        return "me/player/recently-played";
      case Endpoint.category:
        return "browse/categories";
      case Endpoint.podcast:
        return "me/shows";
      case Endpoint.playlist:
        return "me/playlists";
      case Endpoint.artist:
        return "me/following?type=artist";
      case Endpoint.album:
        return "me/albums";
      case Endpoint.search:
        return "search";
      case Endpoint.me:
        return "me";
    }
  }
}