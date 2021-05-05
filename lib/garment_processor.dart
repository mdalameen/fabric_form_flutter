import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fabric_form_flutter/app_colors.dart';
import 'package:fabric_form_flutter/components/add_button.dart';
import 'package:fabric_form_flutter/components/form/app_controllers.dart';
import 'package:flutter/material.dart';

import './data/model.dart';

class GarmentProcessor {
  static const _fabric = 'Fabric';
  static const _pattern = 'Pattern';
  static const _accesories = 'Accesories';
  static const _productionCost = 'Production Cost';
  static const _taxes = 'Taxes';
  static const _extraCost = 'Extra Cost';

  final Garment data;

  Map<Fabric, _FabricWrapper> _fabricControllers = Map();
  Map<Pattern, _PatternWrapper> _patternControllers = Map();
  Map<NameCostPair, _PairWrapper> _accesoriesController = Map();
  Map<NameCostPair, _PairWrapper> _productionCostController = Map();
  Map<NamePercentPair, _PairWrapper> _taxesController = Map();
  Map<NameCostPair, _PairWrapper> _extraCostController = Map();

  GarmentProcessor(Garment data) : this.data = Garment.copy(data) {
    _initController();
  }

  _initController() {
    _fabricControllers.clear();
    data.fabrics.forEach(
        (fabric) => _fabricControllers[fabric] = _FabricWrapper(fabric));
    data.patterns.forEach((pattern) =>
        _patternControllers[pattern] = _PatternWrapper(pattern, data.fabrics));
    data.accesories.forEach((accesory) =>
        _accesoriesController[accesory] = _PairWrapper.nameCost(accesory));
    data.productionCosts.forEach((productionCost) =>
        _productionCostController[productionCost] =
            _PairWrapper.nameCost(productionCost));
    data.taxes.forEach(
        (tax) => _taxesController[tax] = _PairWrapper.namePercent(tax));
    data.extraCosts.forEach((extraCost) =>
        _extraCostController[extraCost] = _PairWrapper.nameCost(extraCost));
  }

  _displayAlertDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Ok',
                      style: TextStyle(color: AppColors.blue),
                    ))
              ],
            ));
  }

  _addFabric() {
    final f = Fabric(data.fabrics.isEmpty, '', 0, 0, 0);
    data.fabrics.add(f);
    _fabricControllers[f] = _FabricWrapper(f);
    onStateChanged();
  }

  _deleteFabric(Fabric fabric) {
    bool isUsing = false;
    for (var v in data.patterns) {
      isUsing = v.fabric == fabric.name;
      if (isUsing) break;
    }

    if (isUsing) {
      _displayAlertDialog('Cannot delete', 'This field is used by pattern');
      return;
    }

    data.fabrics.remove(fabric);
    _fabricControllers[fabric].dispose();
    _fabricControllers.remove(fabric);
    onStateChanged();
  }

  _addEdge(Pattern pattern) {
    final v = NameValuePair("", 0);
    pattern.edges.add(v);
    final pWrapper = _patternControllers[pattern];
    pWrapper.edgesController[v] = _PairWrapper.nameValue(v);
    onStateChanged();
  }

  _deleteEdge(Pattern pattern, NameValuePair edge) {
    final pWrapper = _patternControllers[pattern];
    final eWrapper = pWrapper.edgesController[edge];
    eWrapper.dispose();
    pWrapper.edgesController.remove(eWrapper);
    pattern.edges.remove(edge);
    onStateChanged();
  }

  _addPattern() {
    final p = Pattern(
        "",
        data.fabrics.isNotEmpty ? data.fabrics.first.name : null,
        data.patterns.isEmpty, []);
    data.patterns.add(p);
    _patternControllers[p] = _PatternWrapper(p, data.fabrics);
    onStateChanged();
  }

  _deletePattern(Pattern pattern) {
    final pWrapper = _patternControllers[pattern];
    for (var eWrapper in pWrapper.edgesController.values) eWrapper.dispose();
    pWrapper.dispose();
    data.patterns.remove(pattern);
    onStateChanged();
  }

  _addAccesory() {
    final a = NameCostPair("", 0);
    data.accesories.add(a);
    _accesoriesController[a] = _PairWrapper.nameCost(a);
    onStateChanged();
  }

  _deleteAccesory(NameCostPair pair) {
    final w = _accesoriesController[pair];
    w.dispose();
    _accesoriesController.remove(pair);
    data.accesories.remove(pair);
    onStateChanged();
  }

  _addProductionCost() {
    final v = NameCostPair("", 0);
    data.productionCosts.add(v);
    _productionCostController[v] = _PairWrapper.nameCost(v);
    onStateChanged();
  }

  _deleteProductionCost(NameCostPair pair) {
    final w = _productionCostController[pair];
    w.dispose();
    _productionCostController.remove(pair);
    data.productionCosts.remove(pair);
    onStateChanged();
  }

  _addTax() {
    final v = NamePercentPair("", 0);
    data.taxes.add(v);
    _taxesController[v] = _PairWrapper.namePercent(v);
    onStateChanged();
  }

  _deleteTax(NamePercentPair tax) {
    final w = _taxesController[tax];
    w.dispose();
    _taxesController.remove(tax);
    data.taxes.remove(tax);
    onStateChanged();
  }

  _addExtraCost() {
    final v = NameCostPair("", 0);
    data.extraCosts.add(v);
    _extraCostController[v] = _PairWrapper.nameCost(v);
    onStateChanged();
  }

  _deleteExtraCost(NameCostPair extraCost) {
    final w = _extraCostController[extraCost];
    w.dispose();
    _extraCostController.remove(extraCost);
    data.extraCosts.remove(extraCost);
    onStateChanged();
  }

  VoidCallback onStateChanged;
  BuildContext context;
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    this.context = context;
    this.onStateChanged = onStateChanged;
    return Column(
      children: [
        _buildLineItem(
            _fabric,
            Column(
                children: List.generate(data.fabrics.length, (index) {
              Fabric f = data.fabrics[index];
              _FabricWrapper w = _fabricControllers[f];
              return _fieldsHolder(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      w.nameController.buildWidget(),
                      _dualWidget(w.massController.buildWidget(),
                          w.widthController.buildWidget()),
                      _dualWidget(w.costController.buildWidget(),
                          w.typeController.buildWidget()),
                    ],
                  ), () {
                _deleteFabric(f);
              });
            })),
            _addFabric),
        _buildLineItem(
            _pattern,
            Column(
                children: List.generate(data.patterns.length, (index) {
              Pattern p = data.patterns[index];
              _PatternWrapper w = _patternControllers[p];
              return _fieldsHolder(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      w.nameController.buildWidget(),
                      _dualWidget(w.fabricController.buildWidget(),
                          w.typeController.buildWidget()),
                      _buildNameValueWrapper(
                          'Edge',
                          List.generate(p.edges.length, (index) {
                            NameValuePair pair = p.edges[index];
                            _PairWrapper n = w.edgesController[pair];
                            return _fieldsHolder(
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    _dualWidget(
                                      n.nameController.buildWidget(),
                                      n.valueController.buildWidget(),
                                    )
                                  ],
                                ),
                                () => _deleteEdge(p, pair));
                          }),
                          () => _addEdge(p))
                    ],
                  ), () {
                _deletePattern(p);
              });
            })),
            _addPattern),
        _buildPairWraper(
            _accesories,
            data.accesories.map((e) => _accesoriesController[e]).toList(),
            _addAccesory,
            (index) => _deleteAccesory(data.accesories[index])),
        _buildPairWraper(
            _productionCost,
            data.productionCosts
                .map((e) => _productionCostController[e])
                .toList(),
            _addProductionCost,
            (index) => _deleteProductionCost(data.productionCosts[index])),
        _buildPairWraper(
            _taxes,
            data.taxes.map((e) => _taxesController[e]).toList(),
            _addTax,
            (index) => _deleteTax(data.taxes[index])),
        _buildPairWraper(
            _extraCost,
            data.extraCosts.map((e) => _extraCostController[e]).toList(),
            _addExtraCost,
            (index) => _deleteExtraCost(data.extraCosts[index])),
      ],
    );
  }

  _buildPairWraper(String label, List<_PairWrapper> list,
          VoidCallback onAddPressed, ValueChanged<int> onDeletePressed) =>
      _buildLineItem(
          label,
          Column(
              children: List.generate(list.length, (index) {
            _PairWrapper w = list[index];
            return _fieldsHolder(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _dualWidget(w.nameController.buildWidget(),
                        w.valueController.buildWidget()),
                  ],
                ),
                () => onDeletePressed(index));
          })),
          onAddPressed);

  _buildNameValueWrapper(
      String label, List<Widget> widgets, VoidCallback onAddPressed) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: DottedDecoration(
          color: AppColors.grey,
          shape: Shape.box,
          borderRadius: BorderRadius.circular(5),
          dash: <int>[1, 3]),
      child: Column(
        children: [...widgets, AddButton('Add $label', onAddPressed)],
      ),
    );
  }

  _dualWidget(Widget leftChild, Widget rightChild) {
    return Row(
      children: [
        Expanded(child: leftChild),
        Expanded(
          child: rightChild,
        )
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

  Widget _buildLineItem(String label, Widget child, VoidCallback onPressed) {
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
            child: AddButton('Add New', onPressed),
          )
        ],
      ),
    );
  }

  dispose() {}
}

class _FabricWrapper {
  AppSwitchController typeController;
  AppTextController nameController;
  AppTextController widthController;
  AppTextController massController;
  AppTextController costController;

  _FabricWrapper(Fabric fabric) {
    typeController =
        AppSwitchController(label: 'Type', isSelected: fabric.type);
    nameController = AppTextController(label: 'Name');
    nameController.controller.text = fabric.name;
    widthController = AppTextController(label: 'Width', isNumber: true);
    widthController.controller.text = '${fabric.width}';
    massController = AppTextController(label: 'mass', isNumber: true);
    massController.controller.text = '${fabric.mass}';
    costController = AppTextController(label: 'cost', isNumber: true);
    costController.controller.text = '${fabric.cost}';
  }

  dispose() {
    typeController.dispose();
    nameController.dispose();
    widthController.dispose();
    massController.dispose();
    costController.dispose();
  }
}

class _PatternWrapper {
  AppSwitchController typeController;
  AppTextController nameController;
  AppDropDownController<Fabric> fabricController;
  Map<NameValuePair, _PairWrapper> edgesController;

  _PatternWrapper(Pattern pattern, List<Fabric> fabrics) {
    typeController =
        AppSwitchController(label: 'Area Type', isSelected: pattern.areaType);
    nameController = AppTextController(label: 'Name');
    nameController.controller.text = pattern.name;
    fabricController = AppDropDownController(
        label: 'Fabic',
        options: fabrics,
        selectedOption: fabrics.singleWhere(
            (element) => element.name == pattern.fabric,
            orElse: () => null));
    edgesController = Map();
    pattern.edges.forEach(
        (edge) => edgesController[edge] = _PairWrapper.nameValue(edge));
  }

  dispose() {
    typeController.dispose();
    nameController.dispose();
    fabricController.dispose();
  }
}

class _PairWrapper {
  AppTextController nameController;
  AppTextController valueController;

  _PairWrapper(String nameLabel, String valueLabel, String name, double value) {
    nameController = AppTextController(label: nameLabel);
    nameController.controller.text = name;

    valueController = AppTextController(label: valueLabel, isNumber: true);
    valueController.controller.text = '$value';
  }

  _PairWrapper.nameValue(NameValuePair pair)
      : this('Name', 'Value', pair.name, pair.value);

  _PairWrapper.nameCost(NameCostPair pair)
      : this('Name', 'Cost', pair.name, pair.value);

  _PairWrapper.namePercent(NamePercentPair pair)
      : this('Name', 'Percent', pair.name, pair.value);

  dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}
