import 'dart:convert';

import 'package:fabric_form_flutter/app_colors.dart';
import 'package:fabric_form_flutter/app_preference.dart';
import 'package:fabric_form_flutter/data/dummy_data.dart';
import 'package:fabric_form_flutter/data/model.dart';
import 'package:fabric_form_flutter/pages/add_page.dart';
import 'package:fabric_form_flutter/pages/view_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Garment> garments;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    garments = await AppPreference.getGarments();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garment Models'),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _onAddPressed)],
        centerTitle: true,
      ),
      body: garments == null
          ? Container()
          : garments.isEmpty
              ? _buildEmptyView()
              : _buildList(),
    );
  }

  _onViewPressed(Garment garment) {
    var encoder = JsonEncoder.withIndent('  ');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ViewPage(encoder.convert(garment.toJson()))));
  }

  _onDeletePressed(Garment garment) {
    garments.remove(garment);
    AppPreference.setGarments(garments);
    setState(() {});
  }

  _onAddPressed([Garment data]) async {
    int removeIndex;
    if (data != null) removeIndex = garments.indexOf(data);
    Garment garment = data ?? DummyData.getDefaultModel();
    Garment updatedGarment = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => AddPage(garment)));
    if (updatedGarment != null) {
      if (removeIndex != null) {
        garments.removeAt(removeIndex);
      }
      garments.insert(0, updatedGarment);
      AppPreference.setGarments(garments);
      setState(() {});
    }
  }

  Widget _buildEmptyView() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'List is empty',
            style: TextStyle(color: AppColors.black, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Add model by pressing + in top right corner',
            style: TextStyle(color: AppColors.grey, fontSize: 18),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: garments.length,
        itemBuilder: (_, index) => Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade300))),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildItemList(
                      'Fabric : ', garments[index].fabrics, (e) => e.name),
                  _buildItemList(
                      'Patterns : ', garments[index].patterns, (e) => e.name),
                  Row(
                    children: [
                      _buildItemActionButton(Icons.edit_outlined, 'Edit',
                          () => _onAddPressed(garments[index])),
                      _buildItemActionButton(Icons.visibility_outlined, 'View',
                          () => _onViewPressed(garments[index])),
                      _buildItemActionButton(Icons.remove_circle_outline,
                          'Delete', () => _onDeletePressed(garments[index]))
                    ],
                  )
                ],
              ),
            ));
  }

  _buildItemActionButton(IconData icon, String text, VoidCallback onPressed) {
    return Expanded(
        child: InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.blue,
          ),
          SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(color: AppColors.blue),
          )
        ],
      ),
    ));
  }

  _buildItemList<T>(String label, List<T> list, _TextSerializer<T> s) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text.rich(
        TextSpan(
          text: label,
          style: TextStyle(color: AppColors.black, fontSize: 14),
          children: list
              .map((e) => TextSpan(
                  text: '${s(e)} ${list.last == e ? "" : ", "}',
                  style: TextStyle(color: AppColors.grey)))
              .toList(),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

typedef String _TextSerializer<T>(T t);
