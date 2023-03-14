import 'dart:convert';
import 'dart:developer';
import 'package:http_interceptor/http_interceptor.dart';


class CurlLoggerInterceptorHttp extends InterceptorContract {
  final bool? printOnSuccess;

  CurlLoggerInterceptorHttp({this.printOnSuccess,});
 

  void _renderCurlRepresentation(RequestData request) {
    // add a breakpoint here so all errors can break
    try {
      log(_cURLRepresentation(request));
    } catch (err) {
      log('unable to create a CURL representation of the requestOptions');
    }
  }

  String _cURLRepresentation(RequestData request) {
    List<String> components = ['curl -i'];
    if (request.method.name.toUpperCase() != 'GET') {
      components.add('-X ${request.method.name}');
    }

    request.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if ( request.body != null    ) {
      final data = json.encode(request.body);
      components.add('-d "$data"');
    }

    components.add('"${request.url}"');

    return components.join(' \\\n\t');
  }
  
  @override
  Future<RequestData> interceptRequest({required RequestData data})async {
        _renderCurlRepresentation(data);
   return   data;
  }
  
  @override
  Future<ResponseData> interceptResponse({required ResponseData data})async {
    if (printOnSuccess is bool &&  printOnSuccess == true ) {
      if(data.request != null){
      _renderCurlRepresentation(data.request!);
    }else{
       log('unable to create a CURL representation as Request data not found on response.');
    }
  }

    return   data;
  }
}
