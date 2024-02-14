class UrlEncapsulation {
 String defaulturl = "virtuosocity.com";
 String awsUrl = "selflearning.dtechex.com";
  String? _baseUrl;
  Encapsulation() {
    _baseUrl = defaulturl;
  }

  void setName({required String url}){
    _baseUrl = url;
  }
  String? getUrl(){
    return _baseUrl;
  }
}