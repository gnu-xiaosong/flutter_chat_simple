# 插件系统开发文档

## 插件归类介绍

### 1.**功能扩展类插件**

- **描述**: 这些插件通过添加新的功能或特性来扩展应用程序的核心功能。

- 示例

  - 浏览器插件（如广告拦截器、翻译工具）。
  - IDE插件（如代码格式化工具、调试工具）。
  - 文档编辑器插件（如拼写检查、模板管理）。

### 2. **集成类插件**

- **描述**: 这些插件允许应用程序与其他服务或工具集成，通常用于数据同步或外部服务调用。

- 示例

  - API集成插件（如支付网关、社交媒体分享）。
  - 数据库连接插件（如支持不同类型的数据库）。
  - 第三方服务集成（如邮件发送、云存储）。

### 3. **UI/UX类插件**

- **描述**: 这些插件通常用于改善用户界面的外观和用户体验，可能包括视觉增强和交互功能。

- 示例

  - 主题/皮肤插件（改变应用程序的外观）。
  - 自定义控件或小部件（如日历、图表）。
  - 动画效果插件。

### 4. **安全类插件**

- **描述**: 这些插件专注于增强应用程序的安全性，通常用于防止攻击或保护用户数据。

- 示例

  - 防火墙插件。
  - 安全扫描插件（如防止SQL注入、XSS攻击）。
  - 身份验证/授权插件。

### 5. **分析与监控类插件**

- **描述**: 这些插件用于收集、分析和监控应用程序的性能和使用情况。

- 示例

  - 性能监控插件（如内存使用、CPU消耗）。
  - 日志记录插件（如错误日志、访问日志）。
  - 分析工具集成（如Google Analytics插件）。

### 6. **内容管理类插件**

- **描述**: 这些插件用于管理应用程序中的内容，通常用于CMS（内容管理系统）中。

- 示例

  - SEO插件（搜索引擎优化）。
  - 多语言支持插件。
  - 媒体管理插件（如图片库、视频播放器）。

### 7. **开发工具类插件**

- **描述**: 这些插件主要用于开发阶段，帮助开发人员更高效地编码、测试和调试。

- 示例

  - 代码生成器插件。
  - 测试框架集成插件。
  - 持续集成插件。

### 8. **自动化类插件**

- **描述**: 这些插件用于自动化某些流程或任务，减少手动操作的需求。

- 示例

  - 构建工具插件（如Gradle、Maven插件）。
  - 部署自动化插件。
  - 测试自动化插件。

### 9. **数据处理类插件**

- **描述**: 这些插件用于处理和转换数据，通常用于数据导入/导出、格式转换等。

- 示例

  - 数据导入/导出插件（如CSV、JSON）。
  - 数据清理和转换插件。
  - 报告生成插件。

### 10. **通信类插件**

- **描述**: 这些插件支持应用程序与其他系统、服务或设备之间的通信。

- 示例

  - WebSocket插件。
  - 消息队列插件（如RabbitMQ、Kafka）。
  - 实时通信插件（如视频会议、聊天）。

### 10.微应用miniAPP

类似小程序独立运行的小型应用

## 插件系统设计

![image-20240814000538731](project/pluginSystem/image-20240814000538731.png)

* 插件管理器

![image-20240813170542699](project/pluginSystem/image-20240813170542699.png)



* 注入器架构图

![image-20240815055250372](project/pluginSystem/image-20240815055250372.png)

### 插件管理类设计：PluginManager

#### 功能

- 注册插件:register
- 注销已注册的插件:unregister
- 获取已注册的插件:getPlugin
- 初始化所有已注册的插件: initialAll
- 释放所有已注册的插件：disposeAll

##### dart语言实现：

```dart
/*
插件管理器
 */
class PluginManager {
  /*
  注册插件
   */
  registerPlugin() {
    //
  }

  /*
  注销插件
   */
  unregisterPlugin() {
    //
  }

  /*
  获取已注册的插件
   */
  getPlugin() {
    //
  }

  /*
  初始还所有已注册的插件
   */
  initialAll() {
    //
  }

  /*
  释放所有已注册插件
   */
  disposeAll() {
    //
  }
}
```

### 插件类设计：Plugin

#### 属性

* 插件唯一性ID: id

- 插件名称: name
- 插件类型: type

#### 方法

- 初始化: initial
- 释放插件: dispose

#### dart语言实现

插件枚举类型

- PluginType.dart

```dart
enum PluginType {
  Functionality,
  Integration,
  UI,
  Security,
  Analytics,
  ContentManagement,
  DevelopmentTools,
  Automation,
  DataProcessing,
  Communication,
  miniApp
}
```

- Plugin.dart

```dart
/*
插件类:抽象类接口
 */
import 'PluginType.dart';

abstract class Plugin<T extends PluginType> {
    
  // 插件ID：唯一性标识
  String get id;

  // 插件名称
  String get name;

  // 插件类型: 采用枚举类型T
  T get type;

  // 启用状态
  bool get status;
    
    
  /*
  抽象实现接口1: 注册插件
   */
  registerPlugin() {
    //
  }

  /*
  抽象实现接口2:: 注销插件
   */
  dispose() {
    //
  }
}
```

### 插件存储设计

#### 应用运行过程插件存储设计

* app启动过程中从**本地化存储**中**获取**插件列表**
* 将本地化存储中取出的插件列表进行注册，同时单例实例化插件管理器为全局单例对象，在GlobalManager全局中进行初始化
* 然后即可调用插件注入点管理器进行管理和运行

#### 应用未运行过程插件存储设计

* 采用Hive能封装对象Object进行对象持久化存储在本地
* 对于Object对象设计
  1. 插件名称:  name
  2. 插件类型：pluginType
  3. 插件类别：pluginCategory
  4. 插件evc的加载路径：path
  5. 插件创建的日期: time
  6. 插件状态:status





### 插件注入点设计

#### 插件注入点抽象类

```dart
/*
插件注入点抽象类
 */

import 'package:socket_service/microService/pluginSystem/Plugin.dart';
import 'package:socket_service/microService/pluginSystem/PluginType.dart';
import 'PluginInsertPointType.dart';

abstract class PluginInsertPoint<T extends ConPluginType,
    Z extends PluginType> {
  // plugin插件类型: PluginType
  Z get type;

  // 串并联控制类型
  T get pluginConnType;

  // 已注册的插件: 用于使用插件
  List<Plugin> get pluginAll;
}
```

运行结果:

![image-20240816074038362](project/pluginSystem/image-20240816074038362.png)

### 插件注入段代码示例

```dart
import 'dart:io';
import 'package:dart_plugin_system/pluginSystem/PluginManager.dart';
import 'package:dart_plugin_system/pluginSystem/PluginType.dart';
import 'package:dart_plugin_system/pluginSystem/plugin/FunctionalityPlugin.dart';
import 'package:dart_plugin_system/pluginSystem/pluginInsert/PluginCategory.dart';
import 'package:hive/hive.dart';
import 'pluginSystem/storeData/PluginModelAdapter.dart';
import 'pluginSystem/storeData/ServerStoreDataPlugin.dart';

main() async {
  // 初始化Hive
  // 获取当前执行环境的路径
  final String directory = Directory.current.path;
  // 初始化Hive，设置存储路径
  Hive.init(directory);
  // 注册调制器
  Hive.registerAdapter(PluginModelAdapter());
  ServerStoreDataPlugin().initialHiveParameter();

  // 实例化一个插件管理器实例单例对象
  PluginManager pluginManager = PluginManager();

  // ************************前置操作：注册插件 and 初始化插件************************************
  print("注册和初始化插件完成");

  // 实例化中间处理模块化插件 继承至Plugin类
  FunctionalityPlugin functionalityPlugin = FunctionalityPlugin(
      category: PluginCategory.Integration,
      evc: false,
      path:    "D:\\ProjectDevelopment\\plugin_system\\dart_plugin_system\\assets\\plugin\\test.dart",
      name: "testPlugin");

  // 注册插件
  pluginManager.registerPlugin(functionalityPlugin);

  /*
  插件初始化:
  1.方式一：仅初始化该插件
  2.方式二: 初始化所有已注册插件：包括方式1和2
   */
  functionalityPlugin.initial(); // 方式1 推荐
  pluginManager.initialAll(); // 方式2

  // 插件流程化测试
  {
    // 步骤一: 原料
    String a = "石材";
    print("-------------step 1: $a");

    // 步骤二: 中间产物(插件化) 注入点
    /// 一行代码即可使用插件
    print("-------------step 2");
    pluginManager.pluginInjector // 获取注入器
      ..pluginType = PluginType.Functionality // 设置插件类型
      ..pluginCategory = PluginCategory.Integration // 设置插件类别
      ..data = "石头"  // 输入数据
      ..run(); // 运行注入器

    // 步骤三: 成品
    String c = "房子";
    print("-------------step 3: $c");
  }

  // *******************exit application***************************
  print("释放插件成功");
  // 释放插件
  functionalityPlugin.dispose();
  pluginManager.disposeAll();
}
```



### 具体插件实现开发文档

#### 插件类型



#### 插件类别



#### 目录说明



#### 开发须知

##### 插件运作流程说明



##### 其他说明

- 因为插件的运行时执行脚本归功于dart_eval, 因此建议先查阅dart_eval文档再进行插件的开发，以便少走弯路

  同理flutter插件拓展部分，请参见flutter_eval（基于dart_eval）文档

#### 开发步骤

1. 先**阅读插件流程说明**，非必要，做到心中有数，以便更好更高效的开发插件

2. **确开发插件类型以及开发插件的类别**，以便精准定位查件的拓展位置，具体**类型**和**类别**见文档

3. 根据如下**给定的模版进行编写代码**，**入口**函数为**entry**, 需要参数【可选，依据不同业务场景实现】

   - 输入参数：可选，为提前封装的数据类【或者自定义】,如果不想麻烦可以使用官方封装的数据类模型
   - 输出参数：可选，不输出请返回null
     - 返回为null, 则表示该插件只利用数据类进行处理，不影响插件后续正常代码的执行结果
     - 返回not null, 则返回的参数将会传递给后续执行的操作，可能为next plugin 或者 进行过输出数据处理传递给后续代码的处理执行

   ```dart
   /*
   入口函数:
   输入数据： data实例化桥接类, 这里数据对象类需要根据不同业务场景实现，但可以抽象成一个接口，拱具体实现，
   注意由于数据模型类需要在eval中调用，因此要符合规范
   输出数据:  正常为同输入统一桥接类
    */
   dynamic? entry(dynamic dataModel) {
     final timeTracker = MyWorldTimeTracker();
     final myTime = timeTracker.getTimeFor(country);
   
     print(country +
         ' timezone offset: ' +
         myTime.timezoneOffset.toString() +
         ' (from Eval!)');
   
     return timeTracker;
   }
   ```

4. **编写数据模型类**（真实dart环境中的)：封住成数据类以便Eval环境与真实dart环境的数据传递及交换

   你可以这么简单理解：插件相当于一个黑箱，插件管理系统只负责将封装好的数据模型类传递给插件，黑箱操作相当于利用传递的数据模型对象进行业务开发，具体返回的数据，根据具体的插件业务场景需求，返回为null则不对后续本机代码产生影响，否则将会将插件处理返回的数据模型对象给后续本机代码进行处理。

   > 注意：dataModel目录即为定义的数据模型类文件存放目录，用户可以自定义，但要实现或继承数据模型类DataModel类，以便插件管理器能统一进行操作。
   >
   > 

5. 在插件**编写**脚本中编写对应步骤4中的**适用于Eval环境中的数据模型类**，具体编写方法见如下，或者查阅dart_eval官方文档！！！！！！如果编译脚本出现问题，一定请查阅dart_eval官方支持语言模块文档，以免影响插件开发的进度。

6. **确定插件编译方式**: .evc字节码文件 或 .dart源代码文件，为了提高性推荐提前编译成evc字节码文件

   如果要编译成.evc字节码文件,推荐使用cli进行编译: 

   1. 全局启用cli：`dart pub global activate dart_eval`

   2. 开始编译dart项目：

      ```shell
      cd my_project
      dart_eval compile -o program.evc
      ```
7. **得到脚本文件**：xxx.evc 或 xx.dart      


​      

   

   

   

   

   





### dart_eval手册

#### 源代码执行方式

两种都支持

* **编译成evc字节码文件**：速度快、需要提前编译、源代码安全性高
* **runtime时编译再执行**：方便、速度慢

#### 互操作

由于**包装器**互操作性能高且操作性强，因此推荐使用

##### 包装器三步走

1. 给出一个真实dart中的类定义

   ```dart
   import 'package:dart_eval/dart_eval.dart';
   import 'package:dart_eval/dart_eval_bridge.dart';
   import 'package:dart_eval/dart_eval_extensions.dart';
   
   /// 想要去包装的类
   class Book {
     Book(this.pages);
     final List<String> pages;
    
     String getPage(int index) => pages[index];
   }
   ```

2. 使用包装器实现对$instance接口的实现，即给出编译时类的定义(在eval环境中的类)。重写$getProperty、$setProperty 和$getRuntimeType，允许Eval环境访问类中的属性和方法

   ```dart
   /// 包装器的类
   class $Book implements $Instance {
     /// 为dart_eval编译器创建一个类型说明
     static final $type = BridgeTypeSpec('package:hello/book.dart', 'Book').ref;
   
     /// 为dart_eval编译器创建一个类声明
     static final $declaration = BridgeClassDef(BridgeClassType($type),
       // 构造函数                                
       constructors: {
         // 用空字符串定义默认构造函数
         '': BridgeFunctionDef(returns: $type.annotate, params: [
           'pages'.param(CoreTypes.string.ref.annotate)
         ]).asConstructor
       },
       // 方法
       methods: {
          // getPage方法
         'getPage': BridgeFunctionDef(
           returns: CoreTypes.string.ref.annotate,
             // 参数int index
           params: ['index'.param(CoreTypes.int.ref.annotate)],
         ).asMethod,
       }, wrap: true);  // wrap为true包装器类型
   
     /// 重写$value和$reified以返回值
     @override
     final Book $value;
   
     @override
     get $reified => $value;
     
     /// 创建包装Book类的构造函数
     $Book.wrap(this.$value);
     
     static $Value? $new(
       Runtime runtime, $Value? target, List<$Value?> args) {
       return $Book.wrap(Book(args[0]!.$value));
     }
   
     /// 为属性和方法getter创建包装器
     @override
     $Value? $getProperty(Runtime runtime, String identifier) {
       if (identifier == 'getPage') {
         return $Function((_, target, args) {
           return $String($value.getPage(args[0]!.$value));
         });
       }
       return $Object(this).$getProperty(runtime, identifier);
     }
   
     ///为属性设置器创建包装器
     @override
     void $setProperty(Runtime runtime, String identifier, $Value value) {
       return $Object(this).$setProperty(runtime, identifier, value);
     }
   
     /// 允许运行时类型查找
     @override
     int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);
   }
   ```

3. 使用

   ```dart
   /// 现在我们可以使用dart_eval!
   void main() {
     // 实例化一个编译器对象
     final compiler = Compiler();
      
     // 定义一个桥接类: $Book
     compiler.defineBridgeClass($Book.$declaration);
     
     // 开始编译程序
     final program = compiler.compile({
         // 包名
         'hello' : {
             // 文件名和对应源程序
       'main.dart': '''
         import 'book.dart';
         void main() {
           final book = Book(['Hello world!', 'Hello again!']);
           print(book.getPage(1));
         }
       '''
     }});
   
     // 获取源程序的运行时
     final runtime = Runtime.ofProgram(program);
       
     // 在运行时中注册静态方法和构造函数
     runtime.registerBridgeFunc('package:hello/book.dart', 'Book.', $Book.$new);
     
     // 运行时执行包中的程序
     runtime.executeLib('package:hello/main.dart', 'main'); // -> 'Hello again!'
   
   ```

> 提示：有个实验性的项目，包装器的绑定生成。从 v0.7.1 开始，dart_eval CLI 包含一个实验性的包装器绑定生成器。它可在项目中使用 调用`dart_eval bind`，并将为所有使用 eval_annotation 包中的 @Bind 注释的类生成绑定。您还可以传递“--all”标志来为项目中的所有类生成绑定。请注意，生成的绑定并不支持所有边缘情况，可能需要手动调整。
>
> 绑定生成目前无法直接创建 JSON 绑定，但您可以使用生成的 Dart 绑定通过 创建 JSON 绑定`BridgeSerializer`。





## 插件实现日志记录

### 1.**功能扩展类插件**





### 2. **集成类插件**



### 3. **UI/UX类插件**



### 4. **安全类插件**



### 5. **分析与监控类插件**



### 6. **内容管理类插件**



### 7. **开发工具类插件**



### 8. **自动化类插件**



### 9. **数据处理类插件**



### 10. **通信类插件**



### 11.微应用

