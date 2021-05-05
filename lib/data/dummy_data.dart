import 'dart:convert';

import 'package:fabric_form_flutter/data/model.dart';

class DummyData {
  static getDefaultModel() {
    return Garment.fromJson(json.decode(jsonData));
  }

  static const String jsonData = '''
    {
      "fabrics": [
        {
          "type": 0,
          "name": "wool",
          "width": 150,
          "mass": 350,
          "cost": 2.5
        },
        {
          "type": 1,
          "name": "cotton",
          "width": 100,
          "mass": 200,
          "cost": 1.5
        }
      ],
      "patterns": [
        {
          "fabric": "wool",
          "area_type": 0,
          "name": "Sleeves",
          "edges": [
            {
              "name": "Length",
              "value": 60
            }
          ]
        },
        {
          "fabric": "cotton",
          "area_type": 1,
          "name": "Front",
          "edges": [
            {
              "name": "Length",
              "value": 70
            },
            {
              "name": "Width",
              "value": 50
            }
          ]
        }
      ],
      "accessories": [
        {
          "name": "acc01",
          "cost": 10
        },
        {
          "name": "acc02",
          "cost": 20
        }
      ],
      "production_cost": [
        {
          "name": "designer",
          "cost": 20
        },
        {
          "name": "tailor",
          "cost": 15
        }
      ],
      "taxes": [
        {
          "name": "GST",
          "percentage": 0.7
        },
        {
          "name": "PST",
          "percentage": 0.5
        }
      ],
      "extra_cost": [
        {
          "name": "shipping",
          "cost": 15
        },
        {
          "name": "custom",
          "cost": 5
        }
      ]
    }
  ''';
}
