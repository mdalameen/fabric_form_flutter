import 'package:fabric_form_flutter/app_preference.dart';
import 'package:fabric_form_flutter/data/model.dart';
import 'package:fabric_form_flutter/pages/add_page.dart';
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

  _onAddPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddPage()));
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
            style: TextStyle(color: Colors.black, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Add model by pressing + in top right corner',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: garments.length,
      itemBuilder: (_, index) => ListTile(
        title:
            _buildItemList('Fabric : ', garments[index].fabrics, (e) => e.name),
        subtitle: _buildItemList(
            'Patterns : ', garments[index].patterns, (e) => e.name),
      ),
    );
  }

  _buildItemList<T>(String label, List<T> list, _TextSerializer<T> s) {
    return Text.rich(
      TextSpan(
        text: 'Fabric: ',
        style: TextStyle(
          color: Colors.black,
        ),
        children: list
            .map((e) => TextSpan(
                text: '${s(e)} ${list.last == e ? "" : ", "}',
                style: TextStyle(color: Colors.grey.shade500)))
            .toList(),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

typedef String _TextSerializer<T>(T t);
