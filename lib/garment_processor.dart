import 'package:fabric_form_flutter/app_colors.dart';
import 'package:fabric_form_flutter/components/add_button.dart';
import 'package:fabric_form_flutter/components/form/app_controllers.dart';
import 'package:flutter/material.dart';

import './data/model.dart';

class GarmentProcessor {
  final Garment data;
  AppTextController nameController =
      AppTextController(label: 'Name', isMandatory: true);

  AppTextController amountController =
      AppTextController(label: 'Amount', isMandatory: true, isNumber: true);

  AppDropDownController textController =
      AppDropDownController(label: 'label', options: <String>['one', 'two']);
  AppSwitchController testContrller =
      AppSwitchController(label: 'switch', isSelected: false);

  GarmentProcessor(Garment data) : this.data = Garment.copy(data) {
    _initController();
  }

  _initController() {}

  Widget build(BuildContext context, VoidCallback onStateChanged) {
    return Column(
      children: [
        _buildLineItem(
            'Fabric',
            _fieldsHolder(
                Column(
                  children: [
                    Text('data'),
                    nameController.buildWidget(),
                    amountController.buildWidget(),
                    textController.buildWidget(),
                    testContrller.buildWidget()
                  ],
                ),
                () {})),
        _buildLineItem('Pattern', Text('data')),
        _buildLineItem('Accesories', Text('data')),
        _buildLineItem('Production Cost', Text('data')),
        _buildLineItem('Taxes', Text('data')),
        _buildLineItem('Extra Cost', Text('data')),
      ],
    );
  }

  Widget _fieldsHolder(Widget child, VoidCallback onDeleted) {
    var shadows = <BoxShadow>[BoxShadow(color: AppColors.grey, blurRadius: 3)];
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.white,
              boxShadow: shadows),
          child: child,
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
              child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      boxShadow: shadows),
                  child: Icon(Icons.remove_circle_outline_sharp,
                      color: AppColors.red)),
              onTap: onDeleted),
        )
      ],
    );
  }

  Widget _buildLineItem(String label, Widget child) {
    Color color = AppColors.blue;
    return Theme(
      data: ThemeData.dark().copyWith(accentColor: AppColors.white),
      child: ExpansionTile(
        maintainState: true,
        initiallyExpanded: true,
        backgroundColor: color,
        collapsedBackgroundColor: color,
        title: Container(
          child: Text(label, style: TextStyle(color: AppColors.white)),
        ),
        trailing: null,
        children: <Widget>[
          Theme(
            data: ThemeData.dark().copyWith(accentColor: AppColors.blue),
            child: Container(
              width: double.infinity,
              color: AppColors.white,
              child: child,
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            width: double.infinity,
            color: AppColors.white,
            child: AddButton('Add New', () {}),
          )
        ],
      ),
    );
  }

  dispose() {}
}
