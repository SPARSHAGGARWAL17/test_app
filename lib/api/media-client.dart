import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'media-client.g.dart';

@RestApi(baseUrl: 'https://mob-test.pixelotech.com/api/v1')
abstract class MediaApiClient {
  factory MediaApiClient(Dio dio, {String baseUrl}) = _MediaApiClient;

  @GET('/media/')
  Future<String> getUserMedia();

  @POST('/media/')
  Future<String> postUserMedia();

  @DELETE('/media/')
  Future<String> deleteUserMedia(@Body() String id);

  @POST('/media/re-arrange')
  Future<String> rearrangeMedia(@Body() String media);
}
