import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  AddButton(this.label, this.onPressed);
  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue.shade900;
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(50)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: color),
              SizedBox(
                width: 5,
              ),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
