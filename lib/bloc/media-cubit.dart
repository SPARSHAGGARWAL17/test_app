import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/api/media-client.dart';
import 'package:test_app/bloc/media-states.dart';
import 'package:test_app/key.dart';
import 'package:dio/dio.dart';
import 'package:test_app/model/media.dart';

class UserMediaCubit extends Cubit<UserMediaStates> {
  UserMediaCubit() : super(UserMediaLoading());
  Dio dio = Dio();

  Future<void> loadUserMedia() async {
    dio.options.headers['Authorization'] = authToken;
    final client = MediaApiClient(dio);
    client
        .getUserMedia()
        .catchError((error) {
          if (error is DioError) {
            print('Dio-Error-while-loading-media: ${error.response}');
          }
          print('Error-while-loading-media: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('Response-load-user-media');
            print(value);
            MediaResponse response = MediaResponse.fromJson(jsonDecode(value));
            emit(UserMediaLoaded(response.data));
          }
        });
  }

  Future<void> deleteUserMedia(String id, UserMedia media) async {
    dio.options.headers['Authorization'] = authToken;
    final client = MediaApiClient(dio);
    await client
        .deleteUserMedia(id)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-Error-while-deleting-media: ${error.response}');
          }
          print('Error-while-deleting-media: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('User-media-delete-response');
            print(value);
            emit(UserMediaLoaded(media));
          }
        });
  }

  Future<void> postUserMedia(File file) async {
    dio.options.headers['Authorization'] = authToken;
    final client = MediaApiClient(dio);
    await client
        .postUserMedia(file)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-Error-while-posting-media: ${error.response}');
          }
          print('Error-while-posting-media: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('User-media-post-response');
            print(value);
          }
        });
  }

  Future<void> rearrangeMedia(List<Media> userMedia) async {
    dio.options.headers['Authorization'] = authToken;
    final client = MediaApiClient(dio);
    for (int i = 1; i < 7; i++) {
      userMedia[i-1].order = i;
    }
    var body = {"media": List<dynamic>.from(userMedia.map((e) => e.toJson()))};
    print(body);
    client
        .rearrangeMedia(body)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-Error-while-rearranging-media: ${error.response}');
          }
          print('Error-while-rearranging-media: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('User-media-rearranging-response');
            print(value);
          }
        });
  }
}
