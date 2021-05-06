import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fabric_form_flutter/app_colors.dart';
import 'package:fabric_form_flutter/components/add_button.dart';
import 'package:fabric_form_flutter/components/form/app_controllers.dart';
import 'package:flutter/material.dart';

import './data/model.dart';
import 'components/app_alert_popup.dart';
import 'components/form/form_helper.dart';

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
    data.fabrics.forEach((fabric) =>
        _fabricControllers[fabric] = _FabricWrapper(fabric, onStateChanged));
    data.patterns.forEach((pattern) => _patternControllers[pattern] =
        _PatternWrapper(pattern, data.fabrics, onStateChanged));
    data.accesories.forEach((accesory) => _accesoriesController[accesory] =
        _PairWrapper.nameCost(accesory, onStateChanged));
    data.productionCosts.forEach((productionCost) =>
        _productionCostController[productionCost] =
            _PairWrapper.nameCost(productionCost, onStateChanged));
    data.taxes.forEach((tax) =>
        _taxesController[tax] = _PairWrapper.namePercent(tax, onStateChanged));
    data.extraCosts.forEach((extraCost) => _extraCostController[extraCost] =
        _PairWrapper.nameCost(extraCost, onStateChanged));
  }

  _displayAlertDialog(String content) {
    AppAlertPopup.error(context, content);
  }

  _addFabric() {
    final f = Fabric(0, '', 0, 0, 0);
    data.fabrics.add(f);
    _fabricControllers[f] = _FabricWrapper(f, onStateChanged);
    onStateChanged();
  }

  _deleteFabric(Fabric fabric) async {
    bool isOk = await AppAlertPopup.confirm(
        context, 'Do you want to delete Fabric item?');
    if (!isOk) return;
    bool isUsing = false;
    for (var v in data.patterns) {
      isUsing = v.fabric == fabric.name;
      if (isUsing) break;
    }

    if (isUsing) {
      _displayAlertDialog('Cannot delete, this field is used by pattern');
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
    pWrapper.edgesController[v] = _PairWrapper.nameValue(v, onStateChanged);
    onStateChanged();
  }

  _deleteEdge(Pattern pattern, NameValuePair edge) async {
    bool isOk = await AppAlertPopup.confirm(
        context, 'Do you want to delete Edge item?');
    if (!isOk) return;
    final pWrapper = _patternControllers[pattern];
    final eWrapper = pWrapper.edgesController[edge];
    eWrapper.dispose();
    pWrapper.edgesController.remove(edge);
    pattern.edges.remove(edge);
    onStateChanged();
  }

  _addPattern() {
    final p = Pattern(
        "", data.fabrics.isNotEmpty ? data.fabrics.first.name : null, 0, []);
    data.patterns.add(p);
    _patternControllers[p] = _PatternWrapper(p, data.fabrics, onStateChanged);
    onStateChanged();
  }

  _deletePattern(Pattern pattern) async {
    bool isOk = await AppAlertPopup.confirm(
        context, 'Do you want to delete Pattern item?');
    if (!isOk) return;
    final pWrapper = _patternControllers[pattern];
    for (var eWrapper in pWrapper.edgesController.values) eWrapper.dispose();
    pWrapper.dispose();
    data.patterns.remove(pattern);
    onStateChanged();
  }

  _addAccesory() {
    final a = NameCostPair("", 0);
    data.accesories.add(a);
    _accesoriesController[a] = _PairWrapper.nameCost(a, onStateChanged);
    onStateChanged();
  }

  _deleteAccesory(NameCostPair pair) async {
    bool isOk = await AppAlertPopup.confirm(
        context, 'Do you want to delete Accesory item?');
    if (!isOk) return;
    final w = _accesoriesController[pair];
    w.dispose();
    _accesoriesController.remove(pair);
    data.accesories.remove(pair);
    onStateChanged();
  }

  _addProductionCost() {
    final v = NameCostPair("", 0);
    data.productionCosts.add(v);
    _productionCostController[v] = _PairWrapper.nameCost(v, onStateChanged);
    onStateChanged();
  }

  _deleteProductionCost(NameCostPair pair) async {
    bool isOk = await AppAlertPopup.confirm(
        context, 'Do you want to delete Product Cost item?');
    if (!isOk) return;
    final w = _productionCostController[pair];
    w.dispose();
    _productionCostController.remove(pair);
    data.productionCosts.remove(pair);
    onStateChanged();
  }

  _addTax() {
    final v = NamePercentPair("", 0);
    data.taxes.add(v);
    _taxesController[v] = _PairWrapper.namePercent(v, onStateChanged);
    onStateChanged();
  }

  _deleteTax(NamePercentPair tax) async {
    bool isOk =
        await AppAlertPopup.confirm(context, 'Do you want to delete Tax item?');
    if (!isOk) return;
    final w = _taxesController[tax];
    w.dispose();
    _taxesController.remove(tax);
    data.taxes.remove(tax);
    onStateChanged();
  }

  _addExtraCost() {
    final v = NameCostPair("", 0);
    data.extraCosts.add(v);
    _extraCostController[v] = _PairWrapper.nameCost(v, onStateChanged);
    onStateChanged();
  }

  _deleteExtraCost(NameCostPair extraCost) async {
    bool isOk = await AppAlertPopup.confirm(
        context, 'Do you want to delete Extra Cost item?');
    if (!isOk) return;
    final w = _extraCostController[extraCost];
    w.dispose();
    _extraCostController.remove(extraCost);
    data.extraCosts.remove(extraCost);
    onStateChanged();
  }

  onStateChanged() {
    if (_onStateChanged != null) _onStateChanged();
  }

  VoidCallback _onStateChanged;
  BuildContext context;
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    this.context = context;
    this._onStateChanged = onStateChanged;
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
                      w.nameController.buildWidget(addPadding: false),
                      SizedBox(height: 10),
                      _dualWidget(
                          w.massController.buildWidget(addPadding: false),
                          w.widthController.buildWidget(addPadding: false)),
                      SizedBox(height: 10),
                      _dualWidget(
                          w.costController.buildWidget(addPadding: false),
                          w.typeController.buildWidget(addPadding: false)),
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
                      w.nameController.buildWidget(addPadding: false),
                      SizedBox(height: 10),
                      _dualWidget(
                          w.fabricController.buildWidget(addPadding: false),
                          w.typeController.buildWidget(addPadding: false)),
                      SizedBox(height: 10),
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
                                      n.nameController
                                          .buildWidget(addPadding: false),
                                      n.valueController
                                          .buildWidget(addPadding: false),
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
                    _dualWidget(w.nameController.buildWidget(addPadding: false),
                        w.valueController.buildWidget(addPadding: false)),
                  ],
                ),
                () => onDeletePressed(index));
          })),
          onAddPressed);

  _buildNameValueWrapper(
      String label, List<Widget> widgets, VoidCallback onAddPressed) {
    return Container(
      margin: EdgeInsets.all(10),
      // padding: EdgeInsets.all(10),
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
        SizedBox(width: 10),
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
          padding: EdgeInsets.all(10),
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
                  child: Icon(Icons.cancel_outlined, color: AppColors.red)),
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

  List<BaseFormController> _getFabricControllers() {
    List<BaseFormController> fabricController = <BaseFormController>[];
    for (var f in _fabricControllers.values) {
      fabricController.add(f.nameController);
      fabricController.add(f.typeController);
      fabricController.add(f.massController);
      fabricController.add(f.costController);
      fabricController.add(f.widthController);
    }
    return fabricController;
  }

  List<BaseFormController> _getPatternsController() {
    List<BaseFormController> patternsController = <BaseFormController>[];
    for (var p in _patternControllers.values) {
      patternsController.add(p.nameController);
      patternsController.add(p.typeController);
      patternsController.add(p.fabricController);
      for (var e in p.edgesController.values) {
        patternsController.add(e.nameController);
        patternsController.add(e.valueController);
      }
    }
    return patternsController;
  }

  List<BaseFormController> _getAccesoriesControllers() {
    List<BaseFormController> accesoriesController = <BaseFormController>[];
    for (var a in _accesoriesController.values) {
      accesoriesController.add(a.nameController);
      accesoriesController.add(a.valueController);
    }
    return accesoriesController;
  }

  List<BaseFormController> _getProductionControllers() {
    List<BaseFormController> productionController = <BaseFormController>[];
    for (var a in _productionCostController.values) {
      productionController.add(a.nameController);
      productionController.add(a.valueController);
    }
    return productionController;
  }

  List<BaseFormController> _getTaxesControllers() {
    List<BaseFormController> taxesController = <BaseFormController>[];
    for (var a in _taxesController.values) {
      taxesController.add(a.nameController);
      taxesController.add(a.valueController);
    }
    return taxesController;
  }

  List<BaseFormController> _getExtrasControllers() {
    List<BaseFormController> extraCostController = <BaseFormController>[];
    for (var a in _extraCostController.values) {
      extraCostController.add(a.nameController);
      extraCostController.add(a.valueController);
    }
    return extraCostController;
  }

  bool validate() {
    if (!FormHelper.validate(context, _getFabricControllers())) {
      onStateChanged();
      _displayAlertDialog('Invalid Data, Please check value in Fabric section');
      return false;
    }

    Set fs = Set();
    for (var f in _fabricControllers.values) {
      String name = f.nameController.getInput();
      if (fs.contains(name)) {
        f.nameController.errorMessage = 'duplicate value found';
        _displayAlertDialog(
            'Invalid Data, Please check value in Fabric section');
        onStateChanged();
        return false;
      }
      fs.add(name);
    }

    if (!FormHelper.validate(context, _getPatternsController())) {
      onStateChanged();
      _displayAlertDialog(
          'Invalid Data, Please check value in Pattern section');
      return false;
    }

    if (!FormHelper.validate(context, _getAccesoriesControllers())) {
      onStateChanged();
      _displayAlertDialog(
          'Invalid Data, Please check value in Accesories section');
      return false;
    }

    if (!FormHelper.validate(context, _getProductionControllers())) {
      onStateChanged();
      _displayAlertDialog(
          'Invalid Data, Please check value in Production Cost section');
      return false;
    }

    if (!FormHelper.validate(context, _getTaxesControllers())) {
      onStateChanged();
      _displayAlertDialog('Invalid Data, Please check value in Taxes section');
      return false;
    }

    if (!FormHelper.validate(context, _getExtrasControllers())) {
      onStateChanged();
      _displayAlertDialog(
          'Invalid Data, Please check value in Extra Cost section');
      return false;
    }
    onStateChanged();
    return true;
  }

  Garment getData() => data;

  dispose() {
    for (var v in [
      ..._getFabricControllers(),
      ..._getPatternsController(),
      ..._getAccesoriesControllers(),
      ..._getProductionControllers(),
      ..._getTaxesControllers(),
      ..._getExtrasControllers()
    ]) v.dispose();
  }
}

String _numberValidator(String number) {
  var v = double.tryParse(number);
  return v == null ? 'Enter valid number' : null;
}

class _FabricWrapper {
  AppSelectController typeController;
  AppTextController nameController;
  AppTextController widthController;
  AppTextController massController;
  AppTextController costController;

  _FabricWrapper(Fabric fabric, VoidCallback changeState) {
    typeController = AppSelectController(
        label: 'Type',
        index: fabric.type,
        options: <String>['WOOL', 'KNIT'],
        displayMandatory: false,
        isMandatory: true);
    typeController.onChanged = () {
      fabric.type = typeController.getInput();
      changeState();
    };
    nameController = AppTextController(
        label: 'Name', displayMandatory: false, isMandatory: true);
    nameController.onChanged = () {
      fabric.name = nameController.getInput();
      changeState();
    };
    nameController.controller.text = fabric.name;
    widthController = AppTextController(
        label: 'Width',
        isNumber: true,
        validate: _numberValidator,
        displayMandatory: false,
        isMandatory: true);
    widthController.controller.text = '${fabric.width}';
    widthController.onChanged = () {
      fabric.width = DataUtil.getDouble(widthController.getInput());
      changeState();
    };
    massController = AppTextController(
        label: 'mass',
        isNumber: true,
        validate: _numberValidator,
        displayMandatory: false,
        isMandatory: true);
    massController.controller.text = '${fabric.mass}';
    massController.onChanged = () {
      fabric.mass = DataUtil.getDouble(massController.getInput());
      changeState();
    };
    costController = AppTextController(
        label: 'cost',
        isNumber: true,
        validate: _numberValidator,
        displayMandatory: false,
        isMandatory: true);
    costController.controller.text = '${fabric.cost}';
    costController.onChanged = () {
      fabric.cost = DataUtil.getDouble(costController.getInput());
      changeState();
    };
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
  AppSelectController typeController;
  AppTextController nameController;
  AppDropDownController<Fabric> fabricController;
  Map<NameValuePair, _PairWrapper> edgesController;

  _PatternWrapper(
      Pattern pattern, List<Fabric> fabrics, VoidCallback setStateChanged) {
    typeController = AppSelectController(
        label: 'Area Type',
        index: pattern.areaType,
        options: <String>['SOLID', 'STRIPE'],
        displayMandatory: false,
        isMandatory: true);
    typeController.onChanged = () {
      pattern.areaType = typeController.getInput();
      setStateChanged();
    };

    nameController = AppTextController(
        label: 'Name', displayMandatory: false, isMandatory: true);
    nameController.controller.text = pattern.name;
    nameController.onChanged = () {
      pattern.name = nameController.getInput();
      setStateChanged();
    };

    fabricController = AppDropDownController(
        label: 'Fabic',
        options: fabrics,
        selectedOption: fabrics.singleWhere(
            (element) => element.name == pattern.fabric,
            orElse: () => null),
        displayMandatory: false,
        isMandatory: true);
    fabricController.onChanged = () {
      pattern.fabric = fabricController.getInput()?.name;
      setStateChanged();
    };

    edgesController = Map();
    pattern.edges.forEach((edge) =>
        edgesController[edge] = _PairWrapper.nameValue(edge, setStateChanged));
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

  _PairWrapper(
      String nameLabel,
      String valueLabel,
      String name,
      double value,
      ValueChanged<String> onNameChanged,
      ValueChanged<double> onValueChanged,
      VoidCallback setStateChanged) {
    nameController = AppTextController(
        label: nameLabel, displayMandatory: false, isMandatory: true);
    nameController.controller.text = name;
    nameController.onChanged = () {
      onNameChanged(nameController.getInput());
      setStateChanged();
    };

    valueController = AppTextController(
        label: valueLabel,
        isNumber: true,
        validate: _numberValidator,
        displayMandatory: false,
        isMandatory: true);
    valueController.controller.text = '$value';
    valueController.onChanged = () {
      onValueChanged(DataUtil.getDouble(valueController.getInput()));
      setStateChanged();
    };
  }

  _PairWrapper.nameValue(NameValuePair pair, VoidCallback setStateChanged)
      : this('Name', 'Value', pair.name, pair.value, (s) => pair.name = s,
            (d) => pair.value = d, setStateChanged);

  _PairWrapper.nameCost(NameCostPair pair, VoidCallback setStateChanged)
      : this('Name', 'Cost', pair.name, pair.value, (s) => pair.name = s,
            (d) => pair.value = d, setStateChanged);

  _PairWrapper.namePercent(NamePercentPair pair, VoidCallback setStateChanged)
      : this('Name', 'Percent', pair.name, pair.value, (s) => pair.name = s,
            (d) => pair.value = d, setStateChanged);

  dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}
