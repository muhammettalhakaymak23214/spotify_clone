class PlayTrackItem {
  final String? id;
  final String? trackName;
  final String? artistName;
  final String? albumImage;
  final String? previewUrl;
  final String? previewPath;
  final String? albumImagePath;
  PlayTrackItem({
    required this.previewUrl,
    required this.id,
    required this.trackName,
    required this.artistName,
    required this.albumImage,
    this.previewPath,
    this.albumImagePath,
  });
}
