import 'package:fabric_form_flutter/app_colors.dart';
import 'package:flutter/material.dart';

import 'controller_widgets.dart';

abstract class BaseFormController<T> {
  GlobalKey key;
  bool enabled;
  bool isMandatory;
  bool displayMandatory;
  String errorMessage;
  final String label;
  FocusNode focusNode;
  AppValidation<T> validate;
  VoidCallback onChanged;
  bool hideLabel;

  BaseFormController(
      {@required this.label,
      this.isMandatory,
      this.focusNode,
      this.enabled,
      this.onChanged,
      this.displayMandatory: true,
      this.validate,
      this.key,
      this.hideLabel: false}) {
    enabled = enabled ?? true;
    focusNode = focusNode ?? FocusNode();
    hideLabel = hideLabel ?? false;
    isMandatory = isMandatory ?? false;
    key = key ?? GlobalKey();
  }

  String callValidate() {
    if (validate != null) return validate(getInput());
    return null;
  }

  Widget buildWidget({bool addPadding, bool isEnabled});

  bool isInputGiven();
  bool isChanged();
  void dispose() {
    focusNode.dispose();
  }

  T getInput();

  static buildLabel(String label, bool isMandatory) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: AppColors.blue, fontSize: 16)),
        if (isMandatory)
          Text('*', style: TextStyle(color: AppColors.red, fontSize: 16)),
      ],
    );
  }

  static buildError(String error) {
    return Container(
        alignment: Alignment.centerRight,
        child:
            Text(error, style: TextStyle(fontSize: 14, color: AppColors.red)));
  }
}

class AppTextController extends BaseFormController<String> {
  TextEditingController controller;
  String hint;
  bool _isDataChanged = false;
  bool isPassword;
  bool isNumber;

  String getInput() {
    return controller.text.trim();
  }

  void setInput(String input) {
    controller.text = input;
  }

  AppTextController(
      {@required String label,
      this.hint,
      TextEditingController controller,
      FocusNode focusNode,
      this.isPassword: false,
      AppValidation<String> validate,
      bool displayMandatory: true,
      this.isNumber: false,
      bool isMandatory,
      bool enabled,
      VoidCallback onChanged,
      GlobalKey key,
      bool hideLabel})
      : super(
            label: label,
            isMandatory: isMandatory,
            focusNode: focusNode,
            enabled: enabled,
            validate: validate,
            displayMandatory: displayMandatory,
            key: key,
            onChanged: onChanged,
            hideLabel: hideLabel) {
    this.controller = controller ?? TextEditingController();
  }

  @override
  bool isInputGiven() {
    if (controller.text.trim().length > 0) return true;
    return false;
  }

  @override
  bool isChanged() {
    return _isDataChanged;
  }

  @override
  Widget buildWidget(
      {bool addPadding: true, bool isEnabled: true, FocusNode nextNode}) {
    return AppTextWidget(this, addPadding, isEnabled, nextNode, isNumber);
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }
}

typedef String AppValidation<T>(T input);

class AppDropDownController<T> extends BaseFormController<T> {
  List<T> options;
  T selectedOption;
  bool isFieldChanged = false;

  AppDropDownController(
      {@required String label,
      TextEditingController controller,
      FocusNode focusNode,
      AppValidation<String> validate,
      bool displayMandatory: true,
      bool isMandatory,
      bool enabled,
      @required this.options,
      this.selectedOption,
      VoidCallback onChanged,
      GlobalKey key,
      bool hideLabel})
      : super(
            label: label,
            isMandatory: isMandatory,
            focusNode: focusNode,
            enabled: enabled,
            displayMandatory: displayMandatory,
            key: key,
            onChanged: onChanged,
            hideLabel: hideLabel);

  @override
  Widget buildWidget({bool addPadding: true, bool isEnabled: true}) {
    return AppDropDownField(this, addPadding, isEnabled, null);
  }

  @override
  T getInput() {
    return selectedOption;
  }

  @override
  bool isChanged() {
    return isFieldChanged;
  }

  @override
  bool isInputGiven() {
    return selectedOption != null;
  }
}

class AppSwitchController extends BaseFormController<bool> {
  bool isSelected;
  bool isFieldChanged = false;

  AppSwitchController(
      {@required String label,
      TextEditingController controller,
      FocusNode focusNode,
      AppValidation<String> validate,
      bool displayMandatory: true,
      bool isMandatory,
      bool enabled,
      @required this.isSelected,
      VoidCallback onChanged,
      GlobalKey key,
      bool hideLabel})
      : super(
            label: label,
            isMandatory: isMandatory,
            focusNode: focusNode,
            enabled: enabled,
            displayMandatory: displayMandatory,
            key: key,
            onChanged: onChanged,
            hideLabel: hideLabel);

  @override
  Widget buildWidget({bool addPadding: true, bool isEnabled: true}) {
    return AppSwitchField(this, addPadding, isEnabled);
  }

  @override
  bool getInput() {
    return isSelected;
  }

  @override
  bool isChanged() {
    return isFieldChanged;
  }

  @override
  bool isInputGiven() {
    return isSelected != null;
  }
}
