// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _MediaApiClient implements MediaApiClient {
  _MediaApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://mob-test.pixelotech.com/api/v1';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> getUserMedia() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<String>('/media/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<String> postUserMedia(file) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final formData =
        FormData.fromMap({"media": await MultipartFile.fromFile(file.path)});
    final _data = formData;
    final _result = await _dio.request<String>('/media/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<String> deleteUserMedia(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"id":id};
    final _result = await _dio.request<String>('/media/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'DELETE',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<String> rearrangeMedia(media) async {
    ArgumentError.checkNotNull(media, 'media');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = media;
    final _result = await _dio.request<String>('/media/re-arrange/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }
}
