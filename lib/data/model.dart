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

  Garment.copy(Garment garment)
      : fabrics = Fabric.copyList(garment.fabrics),
        patterns = Pattern.copyList(garment.patterns),
        accesories = NameCostPair.copyList(garment.accesories),
        productionCosts = NameCostPair.copyList(garment.productionCosts),
        taxes = NamePercentPair.copyList(garment.taxes),
        extraCosts = NameCostPair.copyList(garment.extraCosts);

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
        'taxes': NamePercentPair.getJsonList(taxes),
        'extra_cost': NameCostPair.getJsonList(extraCosts),
      };

  static List<Garment> getList(List list) =>
      _getList(list, (map) => Garment.fromJson(map));

  static List getJsonList(List<Garment> list) => _getJsonList(list);
}

class Fabric {
  int type;
  String name;
  double width;
  double mass;
  double cost;

  Fabric(this.type, this.name, this.width, this.mass, this.cost);

  Fabric.fromJson(Map<String, dynamic> map)
      : type = DataUtil.getInt(map['type']),
        name = map['name'],
        width = DataUtil.getDouble(map['width']),
        mass = DataUtil.getDouble(map['mass']),
        cost = DataUtil.getDouble(map['cost']);

  Map<String, dynamic> toJson() => {
        'type': DataUtil.getInt(type),
        'name': name,
        'width': width,
        'mass': mass,
        'cost': cost,
      };

  @override
  String toString() => name;

  static List<Fabric> copyList(List<Fabric> list) {
    List<Fabric> nList = [];
    list.forEach(
        (e) => nList.add(Fabric(e.type, e.name, e.width, e.mass, e.cost)));

    return nList;
  }

  static List<Fabric> getList(List list) =>
      _getList(list, (map) => Fabric.fromJson(map));

  static List getJsonList(List<Fabric> list) => _getJsonList(list);
}

class Pattern {
  String name;
  String fabric;
  int areaType;
  List<NameValuePair> edges;

  Pattern(this.name, this.fabric, this.areaType, this.edges);

  Pattern.fromJson(Map<String, dynamic> map)
      : name = map['name'],
        fabric = map['fabric'],
        areaType = DataUtil.getInt(map['area_type']),
        edges = NameValuePair.getList(map['edges']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'fabric': fabric,
        'area_type': DataUtil.getInt(areaType),
        'edges': NameValuePair.getJsonList(edges)
      };

  static List<Pattern> copyList(List<Pattern> list) {
    List<Pattern> nList = [];
    list.forEach((e) => nList.add(Pattern(
        e.name, e.fabric, e.areaType, NameValuePair.copyList(e.edges))));
    return nList;
  }

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
        value = DataUtil.getDouble(map['value']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };

  static List<NameValuePair> copyList(List<NameValuePair> list) {
    List<NameValuePair> nList = [];
    list.forEach((e) => nList.add(NameValuePair(e.name, e.value)));
    return nList;
  }

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
        value = DataUtil.getDouble(map['cost']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'cost': value,
      };

  static List<NameCostPair> copyList(List<NameCostPair> list) {
    List<NameCostPair> nList = [];
    list.forEach((e) => nList.add(NameCostPair(e.name, e.value)));
    return nList;
  }

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
        value = DataUtil.getDouble(map['percentage']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'percentage': value,
      };

  static List<NamePercentPair> copyList(List<NamePercentPair> list) {
    List<NamePercentPair> nList = [];
    list.forEach((e) => nList.add(NamePercentPair(e.name, e.value)));
    return nList;
  }

  static List<NamePercentPair> getList(List list) =>
      _getList(list, (map) => NamePercentPair.fromJson(map));

  static List getJsonList(List<NamePercentPair> list) => _getJsonList(list);
}

class DataUtil {
  static getDouble(var v) {
    if (v != null) {
      if (v is int) return v.toDouble();
      if (v is double) return v.toDouble();
      if (v is String) return double.tryParse(v);
    }
    return null;
  }

  static bool getBool(var v) {
    if (v != null) {
      if (v is bool) return v;
      if (v is int) return v == 1;
      if (v is double) return v == 1.0;
      if (v is String && (<String>['true', 'false'].contains(v.toLowerCase())))
        return v.toLowerCase() == 'true';
      if (v is String) return double.tryParse(v) == 1;
    }
    return null;
  }

  static int getInt(var v) {
    if (v != null) {
      if (v is bool) return v ? 1 : 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v);
    }
    return null;
  }
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
