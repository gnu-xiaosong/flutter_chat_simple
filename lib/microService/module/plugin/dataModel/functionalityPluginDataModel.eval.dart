import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'functionalityPluginDataModel.dart';
import 'package:dart_eval/stdlib/core.dart';

/// dart_eval wrapper binding for [FunctionalityPluginDataModel]
class $FunctionalityPluginDataModel implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc('package:plugin_system/bridge.dart',
        'FunctionalityPluginDataModel.', $FunctionalityPluginDataModel.$new);
  }

  /// Compile-time type declaration of [$FunctionalityPluginDataModel]
  static const $type = BridgeTypeRef(
    BridgeTypeSpec(
      'package:plugin_system/bridge.dart',
      'FunctionalityPluginDataModel',
    ),
  );

  /// Compile-time class declaration of [$FunctionalityPluginDataModel]
  static const $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      isAbstract: false,
    ),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'id',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              true,
            ),
            BridgeParameter(
              'name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
              true,
            ),
            BridgeParameter(
              'payload',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map)),
              true,
            ),
          ],
          params: [],
        ),
        isFactory: false,
      ),
    },
    methods: {
      'toMap': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map)),
          namedParams: [],
          params: [],
        ),
      ),
    },
    getters: {},
    setters: {},
    fields: {
      'id': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
        isStatic: false,
      ),
      'name': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)),
        isStatic: false,
      ),
      'payload': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.map)),
        isStatic: false,
      ),
    },
    wrap: true,
  );

  /// Wrapper for the [FunctionalityPluginDataModel.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $FunctionalityPluginDataModel.wrap(
      FunctionalityPluginDataModel(
          id: args[0]!.$value, name: args[1]!.$value, payload: args[2]!.$value),
    );
  }

  final $Instance _superclass;

  @override
  final FunctionalityPluginDataModel $value;

  @override
  FunctionalityPluginDataModel get $reified => $value;

  /// Wrap a [FunctionalityPluginDataModel] in a [$FunctionalityPluginDataModel]
  $FunctionalityPluginDataModel.wrap(this.$value)
      : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'id':
        final _id = $value.id;
        return $String(_id);

      case 'name':
        final _name = $value.name;
        return $String(_name);

      case 'payload':
        final _payload = $value.payload;
        return $Map.wrap(_payload);
      case 'toMap':
        return __toMap;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __toMap = $Function(_toMap);
  static $Value? _toMap(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target as $FunctionalityPluginDataModel;
    final result = self.$value.toMap();
    return $Map.wrap(result);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
