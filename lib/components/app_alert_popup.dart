import 'package:flutter/material.dart';

import '../app_colors.dart';

class AppAlertPopup extends StatelessWidget {
  final double imageSize = 90;
  final String title;
  final IconData icon;
  final String content;
  final String okText;
  final String cancelText;
  final bool showCancelButton;

  AppAlertPopup(
    this.title,
    this.content,
    this.icon, {
    this.showCancelButton: false,
    this.okText: 'Ok',
    this.cancelText: 'Cancel',
  });

  static Future<bool> _display(
    BuildContext context,
    String title,
    String content,
    IconData icon, {
    bool barrierDismissable: true,
    bool showCancelButton: false,
    String okText: 'Ok',
    String cancelText: 'Cancel',
  }) async {
    bool result = await showDialog(
        context: context,
        builder: (_) => AppAlertPopup(title, content, icon,
            okText: okText,
            cancelText: cancelText,
            showCancelButton: showCancelButton));
    return result ?? false;
  }

  static Future<bool> confirm(
    BuildContext context,
    String content, {
    String title: 'Are you sure?',
    IconData icon: Icons.help_outline,
    bool barrierDismissable: true,
    bool showCancelButton: true,
    String okText: 'Yes',
    String cancelText: 'No',
  }) async {
    return _display(context, title, content, icon,
        barrierDismissable: barrierDismissable,
        okText: okText,
        showCancelButton: showCancelButton,
        cancelText: cancelText);
  }

  static Future<bool> error(
    BuildContext context,
    String content, {
    String title: 'Error',
    IconData icon: Icons.warning,
    bool barrierDismissable: true,
    bool showCancelButton: false,
    String okText: 'Ok',
    String cancelText: 'Cancel',
  }) async {
    return _display(context, title, content, icon,
        barrierDismissable: barrierDismissable,
        okText: okText,
        showCancelButton: showCancelButton,
        cancelText: cancelText);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: imageSize / 2),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: imageSize / 2),
                  Text(
                    title,
                    style: TextStyle(color: AppColors.black, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: TextStyle(color: AppColors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _button(okText, Colors.black,
                          () => Navigator.pop(context, true)),
                      if (showCancelButton)
                        _button(cancelText, Colors.grey.shade700,
                            () => Navigator.pop(context, false))
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                    color: AppColors.blue, shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: AppColors.white,
                  size: 50,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _button(String text, Color color, VoidCallback onPressed) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: color),
        ));
  }
}
