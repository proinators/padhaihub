import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void showToastMessage(String text, {bool short=true}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: (short) ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
  );
}

void closeAllToasts() {
  Fluttertoast.cancel();
}

Future<bool> checkConnectivity() async {
  // final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  // return connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);
  int timeout = 5;
  try {
    http.Response response = await http.get(Uri.parse('https://www.google.com'))
      .timeout(Duration(seconds: timeout));
    if (response.statusCode == 200) {
      return true;
    }
  } on TimeoutException catch (e) {
    print('Timeout Error: $e');
  } on SocketException catch (e) {
    print('Socket Error: $e');
  } on Error catch (e) {
    print('General Error: $e');
  }
  return false;
}