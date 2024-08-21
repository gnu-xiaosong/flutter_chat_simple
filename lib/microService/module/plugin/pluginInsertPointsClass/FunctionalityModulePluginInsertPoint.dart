/*
功能拓展模块插件Functionality注入点类
 */
import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import '../Plugin.dart';
import '../PluginManager.dart';
import '../PluginType.dart';
import '../common.dart';
import '../dataModel/functionalityPluginDataModel.dart';
import '../dataModel/functionalityPluginDataModel.eval.dart';
import '../pluginInsert/PluginInsertPoint.dart';
import '../pluginInsert/PluginInsertPointType.dart';

class FunctionalityModulePluginInsertPoint
    with PluginCommon
    implements PluginInsertPoint {
  late PluginManager pluginManager;
  late dynamic outputData;

  // 回调函数
  late Function callback;
  late Function userOutputDataHandler;
  late Function userInputDataHandler1;

  FunctionalityModulePluginInsertPoint({
    ConPluginType? conPluginType,
  }) {
    _pluginConnType = conPluginType ?? ConPluginType.series;
    pluginManager = PluginManager();
    initialEval();
  }

  /*
  初始化dart_eval的变量，及其桥接类的生命
   */
  initialEval() {
    print("初始化eval环境配置");
  }

  /*
  实现存在的Functionality模块插件列表
   */
  @override
  List<Plugin> get pluginAll => getAllModulePlugin();

  /*
  实现插件的类型:
   */
  @override
  PluginType get type => PluginType.Functionality;

  /*
  私有变量
   */
  ConPluginType _pluginConnType = ConPluginType.series;

  /*
  实现插件连接类型
   */
  @override
  ConPluginType get pluginConnType => _pluginConnType;

  /*
  初始化
   */

  /*
  获取对应地所有插件
   */
  @override
  List<Plugin> getAllModulePlugin() {
    return pluginManager.getRegisterPlugins().where((plugin) {
      // 筛选出该模块插件类型的插件
      if (plugin.type == PluginType.Functionality) return true;
      return false;
    }).toList();
  }

  /*
  运行函数实现接口: 带设置是否带参数
   */
  @override
  dynamic run(dynamic inputData) {
    print("runnig: pluginType =$type  pluginConnType = $pluginConnType");
    print("data: $inputData");
    // 输入数据装饰
    inputData = inputDataHandler(inputData);
    print("input data handler result: $inputData");
    // 输出数据
    late dynamic outputData;

    // 判断插件连接类型
    switch (pluginConnType) {
      case ConPluginType.series:
        outputData = runSeries(inputData);
        break;
      case ConPluginType.parallel:
        outputData = runParallel(inputData);
        break;
    }

    // 输出数据处理
    outputData = outputDataHandler(outputData);
    print("output data handler result: $outputData");

    return outputData;
  }

  /*
  运行串联运行函数
   */
  dynamic runSeries(dynamic data) {
    print("测试数据: $data.id");
    // 循环遍历执行脚本程序
    pluginAll.forEach((plugin) {
      print(
          "------------plugin: ${plugin.name} evc=${plugin.evc}  path=${plugin.path}-----------------");
      print("data: $data");
      // 获取文件leiixng
      bool evc = plugin.evc;
      // 获取文件路径
      String path = plugin.path;

      print("这里");
      // 调用执行脚本函数
      dynamic outData = execScript(evc: evc, path: path, data: data);
      print("outputData: $outData");

      // 判断输出数据是否为null: 串联
      if (outData != null) data = outData;
    });

    print("final output data: ${data}");
    // 数据统一封装
    return data;
  }

  /*
  运行并联运行函数: 默认执行插件列表的第一个，因此只需要排列插件列表顺序即可
   */
  dynamic runParallel(dynamic data) {
    if (pluginAll.isEmpty) {
      // 为空：无插件
      print("plugin list is empty or not plugin is load!");
    } else {
      // 存在注册插件

      // 获取目标plugin
      Plugin plugin = pluginAll.first;
      print(
          "------------plugin: ${plugin.name} evc=${plugin.evc}  path=${plugin.path}-----------------");
      print("input data:$data");

      // 获取文件leiixng
      bool evc = plugin.evc;

      // 获取文件路径
      String path = plugin.path;

      // 调用执行脚本函数
      dynamic outData = execScript(evc: evc, path: path, data: data);
      print("output data: $outData");

      // 判断输出数据是否为null: 串联
      if (outData != null) data = outData;
    }

    return data;
  }

  /*
  执行脚本程序
  @parameter:
    data  dynamic 输入数据
    path  脚本路径
    evc   是否为evc字节码文件
   */
  dynamic execScript(
      {required String path,
      bool evc = false,
      required FunctionalityPluginDataModel data}) {
    print("start exec script........");
    late Runtime runtime;
    /*
    判定是否为evc字节码文件或dart源代码文件
     */
    switch (evc) {
      case true:
        // evc文件
        print("执行文件类型: evc");
        final bytecode = readFileBytes(path);
        // 运行时
        runtime = Runtime(bytecode);
        break;
      case false:
        print("执行文件类型: dart");
        // 1.读取源代码
        final String source = readFileContent(path);
        // 2.编译evc
        final program = compileEvc(source);
        // 3.创建运行时
        runtime = Runtime.ofProgram(program);
        break;
    }

    // 在运行时注册静态方法和构造函数: 以便在脚本中能使用到相关的自定义类，比如数据类DataModel
    runtime.registerBridgeFunc('package:$packetName/bridge.dart',
        'FunctionalityPluginDataModel.', $FunctionalityPluginDataModel.$new);

    // 执行字节码并返回数据封装类
    outputData = runtime.executeLib(
        'package:$packetName/main.dart', // 包名
        'entry', // 入口函数
        [
          // 传入的对象:数据体模型
          $FunctionalityPluginDataModel.wrap(data),
          // 回调函数:便于在dart中出力相关逻辑
          $Closure((runtime, target, args) {
            // args传递过来的参数: 依次为args[0]、args[1].....
            callback(args);
            return null;
          })
        ] // 传入入口函数的参数
        ).$reified; //不带$数据封装对象

    return outputData;
  }

  /*
  编译dart源代码为evc字节码
   */
  compileEvc(String source) {
    // 创建一个编译器
    final compiler = Compiler();

    // 定义桥接类:供dart真实环境与Eval环境通过桥接类传递参数
    compiler.defineBridgeClasses([$FunctionalityPluginDataModel.$declaration]);

    // 2. 将源代码编译成包含元数据和字节码的程序。
    final program = compiler.compile({
      packetName: {'main.dart': source}
    });

    return program;
  }

  @override
  initial() {
    print("初始化FunctionalityModule");
  }

  /*
   输入数据处理装饰函数
   */
  @override
  inputDataHandler(data) {
    return userInputDataHandler1(data);
  }

  /*
  输出数据处理装饰函数
   */
  @override
  outputDataHandler(data) {
    return userOutputDataHandler(data);
  }
}
