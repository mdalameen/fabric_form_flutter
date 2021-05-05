import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_colors.dart';
import 'app_controllers.dart';

class AppTextWidget extends StatefulWidget {
  final AppTextController controller;
  final bool addPadding;
  final bool isEnabled;
  final bool isNumberOnly;
  final FocusNode nextNode;
  AppTextWidget(this.controller, this.addPadding, this.isEnabled, this.nextNode,
      this.isNumberOnly);
  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<AppTextWidget> {
  bool isPasswordDisplaying = false;

  void togglePasswordDisplaying() {
    isPasswordDisplaying = !isPasswordDisplaying;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _fieldWrapper(
      widget.controller,
      widget.addPadding,
      TextField(
        obscureText: widget.controller.isPassword && !isPasswordDisplaying,
        focusNode: widget.controller.focusNode,
        controller: widget.controller.controller,
        enabled: widget.isEnabled || widget.controller.enabled,
        cursorColor: AppColors.blue,
        onSubmitted: widget.nextNode != null
            ? (_) => FocusScope.of(context).requestFocus(widget.nextNode)
            : null,
        style: TextStyle(color: AppColors.black, fontSize: 15),
        keyboardType: widget.isNumberOnly ? TextInputType.number : null,
        textInputAction: widget.nextNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(right: 0, left: 0, bottom: 8, top: 8),
          suffixIconConstraints: BoxConstraints(),
          suffixIcon: widget.controller.isPassword
              ? IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(isPasswordDisplaying
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: togglePasswordDisplaying)
              : null,
          hintText: widget.controller.hint ?? '',
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: widget.controller.errorMessage == null
                      ? AppColors.grey
                      : Colors.red)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: AppColors.red,
          )),
          alignLabelWithHint: true,
          errorMaxLines: 1,
          hintStyle: TextStyle(color: AppColors.grey, fontSize: 16),
          isDense: true,
        ),
      ),
    );
  }
}

class AppDropDownField<T> extends StatefulWidget {
  final AppDropDownController<T> controller;
  final bool addPadding;
  final bool isEnabled;
  final FocusNode nextNode;

  AppDropDownField(
    this.controller,
    this.addPadding,
    this.isEnabled,
    this.nextNode,
  );

  @override
  _AppDropDownFieldState createState() => _AppDropDownFieldState<T>();
}

class _AppDropDownFieldState<T> extends State<AppDropDownField> {
  @override
  Widget build(BuildContext context) {
    return _fieldWrapper(
      widget.controller,
      widget.addPadding,
      Theme(
        data: ThemeData.light(),
        child: DropdownButton<T>(
          underline: Divider(
            height: 0,
            color: AppColors.grey,
            thickness: 1,
          ),
          isExpanded: true,
          onChanged: (_) => _onChanged(_),
          value: widget.controller.selectedOption,
          items: widget.controller.options
              .map((e) => DropdownMenuItem<T>(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(e.toString()),
                    ),
                    value: e,
                  ))
              .toList(),
        ),
      ),
    );
  }

  _onChanged(T t) {
    widget.controller.selectedOption = t;
    widget.controller.isFieldChanged = true;
    setState(() {});
  }
}

class AppSwitchField extends StatefulWidget {
  final AppSwitchController controller;
  final bool addPadding;
  final bool isEnabled;

  AppSwitchField(
    this.controller,
    this.addPadding,
    this.isEnabled,
  );

  @override
  _AppSwitchFieldState createState() => _AppSwitchFieldState();
}

class _AppSwitchFieldState extends State<AppSwitchField> {
  @override
  Widget build(BuildContext context) {
    return _fieldWrapper(
        widget.controller,
        widget.addPadding,
        Row(
          children: [
            Expanded(
              child:
                  BaseFormController.buildLabel(widget.controller.label, false),
            ),
            Switch(
                value: widget.controller.isSelected,
                onChanged: _onChanged,
                activeColor: AppColors.blue,
                inactiveThumbColor: AppColors.grey,
                inactiveTrackColor: Colors.grey.shade300)
          ],
        ),
        hideLabel: true);
  }

  _onChanged(bool value) {
    widget.controller.isSelected = value;
    widget.controller.isFieldChanged = true;
    setState(() {});
  }
}

_fieldWrapper(BaseFormController controller, bool addPadding, Widget child,
    {bool hideLabel: false}) {
  addPadding = addPadding ?? false;
  return Padding(
    key: controller.key,
    padding: EdgeInsets.symmetric(
        horizontal: addPadding ? 20.0 : 0.0, vertical: addPadding ? 8.0 : 0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.label != null && !(controller.hideLabel || hideLabel))
          BaseFormController.buildLabel(controller.label,
              controller.isMandatory && controller.displayMandatory),
        Row(
          children: [
            Expanded(
              child: child,
            ),
          ],
        ),
        if (controller.errorMessage != null)
          BaseFormController.buildError(controller.errorMessage)
      ],
    ),
  );
}
