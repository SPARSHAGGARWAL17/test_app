import 'package:test_app/model/media.dart';

abstract class UserMediaStates {}

class UserMediaLoading extends UserMediaStates {}

class UserMediaLoaded extends UserMediaStates {
  final UserMedia data;
  UserMediaLoaded(this.data);

  void deleteMedia(String id) {
    this.data.userMedia.removeWhere((element) => element.id == id);
  }
}
