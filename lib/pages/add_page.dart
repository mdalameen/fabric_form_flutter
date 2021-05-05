import 'package:fabric_form_flutter/garment_processor.dart';
import 'package:flutter/material.dart';
import '../data/model.dart';

class AddPage extends StatefulWidget {
  final Garment garment;
  AddPage(this.garment);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  GarmentProcessor _garmentProcessor;
  @override
  initState() {
    super.initState();
    _garmentProcessor = GarmentProcessor(widget.garment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: _onSubmit)],
      ),
      body: SingleChildScrollView(
        child: _garmentProcessor.build(context, () => setState(() {})),
      ),
    );
  }

  _onSubmit() {}
}
