class Garment {
  List<Fabric> fabrics;
  List<Pattern> patterns;
  List<NameCostPair> accesories;
  List<NameCostPair> productionCosts;
  List<NamePercentPair> taxes;
  List<NameCostPair> extraCosts;

  Garment(
    this.fabrics,
    this.patterns,
    this.accesories,
    this.productionCosts,
    this.taxes,
    this.extraCosts,
  );

  Garment.fromJson(Map<String, dynamic> map)
      : fabrics = Fabric.getList(map['fabrics']),
        patterns = Pattern.getList(map['patterns']),
        accesories = NameCostPair.getList(map['accessories']),
        productionCosts = NameCostPair.getList(map['production_cost']),
        taxes = NamePercentPair.getList(map['taxes']),
        extraCosts = NameCostPair.getList(map['extra_cost']);

  Map<String, dynamic> toJson() => {
        'fabrics': Fabric.getJsonList(fabrics),
        'patterns': Pattern.getJsonList(patterns),
        'accessories': NameCostPair.getJsonList(accesories),
        'production_cost': NameCostPair.getJsonList(productionCosts),
        'taxes': NamePercentPair.getList(taxes),
        'extra_cost': NameCostPair.getList(extraCosts),
      };

  static List<Garment> getList(List list) =>
      _getList(list, (map) => Garment.fromJson(map));

  static List getJsonList(List<Garment> list) => _getJsonList(list);
}

class Fabric {
  bool type;
  String name;
  double width;
  double mass;
  double cost;

  Fabric(this.type, this.name, this.width, this.mass, this.cost);

  Fabric.fromJson(Map<String, dynamic> map)
      : type = _bool(map['type']),
        name = map['name'],
        width = _double(map['width']),
        mass = _double(map['mass']),
        cost = _double(map['cost']);

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'width': width,
        'mass': mass,
        'cost': cost,
      };

  static List<Fabric> getList(List list) =>
      _getList(list, (map) => Fabric.fromJson(map));

  static List getJsonList(List<Fabric> list) => _getJsonList(list);
}

class Pattern {
  String name;
  String fabric;
  bool areaType;
  List<NameValuePair> edges;

  Pattern(this.name, this.fabric, this.areaType, this.edges);

  Pattern.fromJson(Map<String, dynamic> map)
      : name = map['name'],
        fabric = map['fabric'],
        areaType = _bool(map['area_type']),
        edges = NameValuePair.getList(map['edges']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'fabric': fabric,
        'area_type': areaType,
        'edges': NameValuePair.getJsonList(edges)
      };

  static List<Pattern> getList(List list) =>
      _getList(list, (map) => Pattern.fromJson(map));

  static List getJsonList(List<Pattern> list) => _getJsonList(list);
}

class NameValuePair {
  String name;
  double value;

  NameValuePair(this.name, this.value);

  NameValuePair.fromJson(Map<String, dynamic> map)
      : name = map['name'],
        value = _double(map['value']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };

  static List<NameValuePair> getList(List list) =>
      _getList(list, (map) => NameValuePair.fromJson(map));

  static List getJsonList(List<NameValuePair> list) => _getJsonList(list);
}

class NameCostPair {
  String name;
  double value;

  NameCostPair(this.name, this.value);

  NameCostPair.fromJson(Map<String, dynamic> map)
      : name = map['name'],
        value = _double(map['cost']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'cost': value,
      };

  static List<NameCostPair> getList(List list) =>
      _getList(list, (map) => NameCostPair.fromJson(map));

  static List getJsonList(List<NameCostPair> list) => _getJsonList(list);
}

class NamePercentPair {
  String name;
  double value;

  NamePercentPair(this.name, this.value);

  NamePercentPair.fromJson(Map<String, dynamic> map)
      : name = map['name'],
        value = _double(map['percentage']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'percentage': value,
      };

  static List<NamePercentPair> getList(List list) =>
      _getList(list, (map) => NamePercentPair.fromJson(map));

  static List getJsonList(List<NamePercentPair> list) => _getJsonList(list);
}

double _double(var v) {
  if (v != null) {
    if (v is int) return v.toDouble();
    if (v is double) return v.toDouble();
  }
  return null;
}

bool _bool(var v) {
  if (v != null) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is double) return v == 1.0;
  }
  return null;
}

List _getJsonList(List list) {
  List dList = [];
  if (list != null) list.forEach((e) => dList.add(e.toJson()));
  return dList;
}

List<T> _getList<T>(List dList, _Deserialize<T> d) {
  List<T> list = [];
  if (dList != null) dList.forEach((e) => list.add(d(e)));
  return list;
}

typedef T _Deserialize<T>(Map<String, dynamic> map);