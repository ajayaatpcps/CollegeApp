abstract class BaseApiServices {
  Future<dynamic> getApiResponse(String url);
  Future<dynamic> getPostApiResponse(String url, dynamic body);
  Future<dynamic> getDeleteApiResponse(String url);
  Future<dynamic> getPutResponse(String url, dynamic data);
  Future<dynamic> getPostBiometricsApiResponse(String url, dynamic data, String session);
}
