class Media {
  String id;
  int order;
  String longURL;

  Media({
    this.id,
    this.longURL,
    this.order,
  });

  factory Media.fromJson(Map<String, dynamic> data) {
    return Media(
      id: data['id'],
      longURL: data['long_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "order": order,
    };
  }
}

class UserMedia {
  List<Media> userMedia;

  UserMedia({this.userMedia});

  factory UserMedia.fromJson(Map<String, dynamic> data) {
    return UserMedia(
      userMedia: List<Media>.from(
        data['user_media'].map((e) => Media.fromJson(e)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "media": List<dynamic>.from(
        userMedia.map((e) => e.toJson()),
      ),
    };
  }
}

class MediaResponse {
  bool success;
  UserMedia data;
  MediaResponse({
    this.data,
    this.success,
  });

  factory MediaResponse.fromJson(Map<String, dynamic> data) {
    return MediaResponse(
      success: data['success'],
      data: UserMedia.fromJson(data['data']),
    );
  }
}
