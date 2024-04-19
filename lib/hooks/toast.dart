import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void showToast(BuildContext context, String type, String text) {
    late Icon icon;

    switch (type) {
      case 'error':
        icon = Icon(
          Icons.close_rounded,
          color: Theme.of(context).colorScheme.error,
        );
        break;
      case 'success':
        icon = Icon(
          Icons.check_rounded,
          color: Theme.of(context).colorScheme.inversePrimary,
        );
        break;
      case 'info':
        icon = Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.onPrimary,
        );
        break;
    }

    final fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 4,
          ),
          Text(text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
              )),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: const Duration(milliseconds: 1500),
      gravity: ToastGravity.TOP,
      // positionedToastBuilder: (context, child) {
      //   return Stack(
      //     alignment: Alignment.center,
      //     children: [
      //       Positioned(
      //         bottom: 370,
      //         child: child,
      //       ),
      //     ],
      //   );
      // },
    );
  }
}
