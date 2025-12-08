class TrackItem {
  String? id;
  String? name;
  List<String>? artistsName;
  String? type;
  int? discNumber;
  String? albumName;
  String? albumImage;
  String? ownerId;
  int? durationMs;

  TrackItem({
    this.id,
    this.name,
    this.artistsName,
    this.type,
    this.discNumber,
    this.albumName,
    this.albumImage,
    this.ownerId,
    this.durationMs,
  });

  factory TrackItem.fromJson(Map<String, dynamic> json) {
    final trackJson = json['track'] ?? json;

    return TrackItem(
      id: trackJson['id'],
      name: trackJson['name'],
      type: trackJson['type'],
      discNumber: trackJson['disc_number'],
      albumName: trackJson['album']?['name'],
      albumImage:
          (trackJson['album']?['images'] != null &&
              trackJson['album']['images'].isNotEmpty)
          ? trackJson['album']['images'][0]['url']
          : null,
      artistsName: trackJson['artists'] != null
          ? List<String>.from(trackJson['artists'].map((a) => a['name']))
          : null,
      ownerId: trackJson['owner']?['id'],
      durationMs: (trackJson['duration_ms'] ?? 10) as int,
    );
  }

  static List<TrackItem> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => TrackItem.fromJson(json)).toList();
  }
}

class DetailModel {
  String ownerId;
  String name;
  String imageUrl;
  int total;
  String? releaseDate;

  DetailModel({
    this.ownerId = '',
    this.name = '',
    this.imageUrl = '',
    this.total = 0,
    this.releaseDate,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      ownerId: json["owner"]?["id"] ?? json["artists"]?[0]["id"] ?? "No Data",
      name: json["name"] ?? '',
      imageUrl: (json["images"] != null && json["images"].isNotEmpty)
          ? json["images"][0]["url"] ?? ''
          : '',
      total: json["followers"]?["total"] ?? 0,
      releaseDate: json["release_date"] ?? "No Data",
    );
  }
}