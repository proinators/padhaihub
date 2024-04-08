import 'package:fluttertoast/fluttertoast.dart';

void showToastMessage(String text, {bool short=true}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: (short) ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
  );
}

void closeAllToasts() {
  Fluttertoast.cancel();
}