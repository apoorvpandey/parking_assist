import 'package:flutter/material.dart';

class Utils {
  static void pushToNewRoute(BuildContext context, Widget routeName) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => routeName));
  }

  static void pushToNewRouteAndClearAll(
      BuildContext context, Widget routeName) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => routeName), (route) => false);
  }

  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }

  static Future<void> showCustomAlertDialog(
      BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Dismiss'),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showSnackBar(
      BuildContext context, String message, int durationInMilliseconds) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: durationInMilliseconds),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showLoadingDialog(BuildContext context, String message) =>
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Text(message)),
                ],
              ),
            ),
          );
        },
      );

  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function onYesPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog not dismissible by clicking outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  onYesPressed();
                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
    );
  }
}
