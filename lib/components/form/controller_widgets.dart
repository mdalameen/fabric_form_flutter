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
  final VoidCallback onChanged;
  AppTextWidget(this.controller, this.addPadding, this.isEnabled, this.nextNode,
      this.isNumberOnly, this.onChanged);
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
      TextFormField(
        onChanged: (s) {
          if (widget.onChanged != null) widget.onChanged();
        },
        obscureText: widget.controller.isPassword && !isPasswordDisplaying,
        focusNode: widget.controller.focusNode,
        controller: widget.controller.controller,
        enabled: widget.isEnabled && widget.controller.enabled,
        cursorColor: AppColors.blue,
        // onSubmitted: widget.nextNode != null
        //     ? (_) => FocusScope.of(context).requestFocus(widget.nextNode)
        //     : null,
        style: TextStyle(color: AppColors.black, fontSize: 15),
        keyboardType: widget.isNumberOnly ? TextInputType.number : null,

        textInputAction: widget.nextNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: InputDecoration(
          labelText: widget.controller.label,
          labelStyle: TextStyle(color: AppColors.black, fontSize: 15),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
          contentPadding:
              EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 13),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.controller.errorMessage == null
                      ? Colors.grey
                      : Colors.red)),

          // hintText: widget.controller.label ?? '',
          // enabledBorder: UnderlineInputBorder(
          //     borderSide: BorderSide(
          //         color: widget.controller.errorMessage == null
          //             ? AppColors.grey
          //             : Colors.red)),
          // border: UnderlineInputBorder(
          //     borderSide: BorderSide(
          //   width: 1,
          //   style: BorderStyle.solid,
          //   color: AppColors.red,
          // )),
          // alignLabelWithHint: true,
          // errorMaxLines: 1,
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
  final VoidCallback onChanged;

  AppDropDownField(
    this.controller,
    this.addPadding,
    this.isEnabled,
    this.nextNode,
    this.onChanged,
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
      _getFieldContainer(
          widget.controller.label,
          Theme(
            data: ThemeData.light(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                isDense: true,
                onChanged: (_) => _onChanged(_),
                value: widget.controller.selectedOption,
                items: widget.controller.options
                    .map((e) => DropdownMenuItem<T>(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            child: Text(e.toString()),
                          ),
                          value: e,
                        ))
                    .toList(),
              ),
            ),
          ),
          7),
    );
  }

  _onChanged(T t) {
    if (widget.onChanged != null) widget.onChanged();
    widget.controller.selectedOption = t;
    widget.controller.isFieldChanged = true;
    setState(() {});
  }
}

_getFieldContainer(String label, Widget child, double verticalPadding) {
  return Stack(
    children: [
      Container(
        padding:
            EdgeInsets.only(top: verticalPadding + 2, bottom: verticalPadding),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        child: child,
      ),
      Container(
        margin: EdgeInsets.only(
          left: 7,
        ),
        transform: Transform.translate(offset: Offset(0, -4)).transform,
        padding: EdgeInsets.symmetric(horizontal: 2),
        color: Colors.white,
        child: Text(
          label ?? '',
          style: TextStyle(fontSize: 11),
        ),
      )
    ],
  );
}

class AppSelectField extends StatefulWidget {
  final AppSelectController controller;
  final bool addPadding;
  final bool isEnabled;

  AppSelectField(
    this.controller,
    this.addPadding,
    this.isEnabled,
  );

  @override
  _AppSelectFieldState createState() => _AppSelectFieldState();
}

class _AppSelectFieldState extends State<AppSelectField> {
  @override
  Widget build(BuildContext context) {
    return _fieldWrapper(
        widget.controller,
        widget.addPadding,
        Wrap(
            children: List.generate(widget.controller.options.length, (index) {
          String text = widget.controller.options[index];
          bool isSelected = index == widget.controller.index;
          return InkWell(
            onTap: () => _onChanged(index),
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isSelected ? AppColors.blue : AppColors.grey,
              ),
              child: Text(text,
                  style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.white : AppColors.black)),
            ),
          );
        })
            // children: [

            //   Expanded(
            //     child:
            //         BaseFormController.buildLabel(widget.controller.label, false),
            //   ),
            //   Switch(
            //       value: widget.controller.isSelected,
            //       onChanged: _onChanged,
            //       activeColor: AppColors.blue,
            //       inactiveThumbColor: AppColors.grey,
            //       inactiveTrackColor: Colors.grey.shade300)
            // ],
            ),
        hideLabel: true);
  }

  _onChanged(int value) {
    widget.controller.index = value;
    widget.controller.isFieldChanged = true;
    if (widget.controller.onChanged != null) widget.controller.onChanged();
    setState(() {});
  }
}

_fieldWrapper(BaseFormController controller, bool addPadding, Widget child,
    {bool hideLabel: false}) {
  addPadding = addPadding ?? false;
  return Padding(
    key: controller.key,
    padding: EdgeInsets.symmetric(
        horizontal: addPadding ? 10.0 : 0.0, vertical: addPadding ? 6.0 : 0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // if (controller.label != null && !(controller.hideLabel || hideLabel))
        //   BaseFormController.buildLabel(controller.label,
        //       controller.isMandatory && controller.displayMandatory),
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
