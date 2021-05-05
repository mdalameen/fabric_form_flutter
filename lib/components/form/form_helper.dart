import 'package:flutter/material.dart';

import 'app_controllers.dart';

class FormHelper {
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static bool validate(
      BuildContext context, List<BaseFormController> controllers) {
    bool isOk = true;
    FocusNode node;
    GlobalKey key;
    for (BaseFormController controller in controllers) {
      controller.errorMessage = null;
      if (controller.isMandatory && !controller.isInputGiven()) {
        controller.errorMessage =
            (controller.label ?? 'This field') + ' is mandatory';
      }

      if (controller.errorMessage == null && controller.isInputGiven())
        controller.errorMessage = controller.callValidate();

      if (controller.errorMessage != null) {
        if (node == null && controller.enabled) {
          node = controller.focusNode;
          key = controller.key;
        }
        isOk = false;
      }
    }
    if (node != null) FocusScope.of(context).requestFocus(node);
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(key.currentContext);
    }

    return isOk;
  }
}
