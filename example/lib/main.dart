
import 'dart:convert';

import 'package:curl_logger_flutter/curl_logger_interceptor_http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  late final http ;

  MyApp({Key? key}) : super(key: key) {
    // avoid using it in production or do it at your own risks!
     http = InterceptedHttp.build(interceptors: [
        if(kDebugMode)  CurlLoggerInterceptorHttp(printOnSuccess: true),
      ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: () async {
             await http.post( "https://flutter.dev/some404".toUri()  ,body:jsonEncode({"xyz" : "123" , "abc" : "456"}), headers: {'Authorization': 'Bearer 7d8e043e-6561-442a-bb9b-6da8a33sws331' , 'Content-type' : 'application/json' , 'Accept' : 'application/json'});
          },
          child: const Text('Run POST errored request'),
        ),
        const SizedBox(height: 20),
        const Text(
          'After pressing the button, go in your terminal and copy the curl code. Paste it in your terminal. Tada ✨',
          textAlign: TextAlign.center,
        )
      ]),
    ));
  }
}