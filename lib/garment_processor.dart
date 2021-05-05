import 'package:fabric_form_flutter/components/add_button.dart';
import 'package:flutter/material.dart';

import './data/model.dart';

class GarmentProcessor {
  final Garment data;
  GarmentProcessor(Garment data) : this.data = Garment.copy(data) {
    _initController();
  }

  _initController() {}

  Widget build(BuildContext context, VoidCallback onStateChanged) {
    return Column(
      children: [
        _buildLineItem('Fabric', Text('data')),
        _buildLineItem('Pattern', Text('data')),
        _buildLineItem('Accesories', Text('data')),
        _buildLineItem('Production Cost', Text('data')),
        _buildLineItem('Taxes', Text('data')),
        _buildLineItem('Extra Cost', Text('data')),
      ],
    );
  }

  Widget _buildLineItem(String label, Widget child) {
    Color color = Colors.blue.shade900;
    return Theme(
      data: ThemeData.dark().copyWith(accentColor: Colors.white),
      child: ExpansionTile(
        maintainState: true,
        initiallyExpanded: true,
        backgroundColor: color,
        collapsedBackgroundColor: color,
        title: Container(
          // color: Colors.yellow,
          child: Text(label, style: TextStyle(color: Colors.white)),
        ),
        trailing: null,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Colors.white,
            child: child,
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.white,
            child: AddButton('Add New', () {}),
          )
        ],
      ),
    );
  }

  dispose() {}
}
