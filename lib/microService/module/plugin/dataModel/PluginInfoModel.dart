class PluginInfoModel {
  final String id;
  final String name;
  final String version;
  final String author;
  final String icon;
  final String description;
  final String license;
  final String homepage;
  final String repository;
  final Map<String, String> dependencies;
  final String pluginType;
  final String pluginCategory;
  final List<String> supportedPlatforms;
  final DateTime lastUpdated;
  final AdditionalInfo additionalInfo;

  PluginInfoModel({
    required this.id,
    required this.name,
    required this.version,
    required this.author,
    required this.icon,
    required this.description,
    required this.license,
    required this.homepage,
    required this.repository,
    required this.dependencies,
    required this.pluginType,
    required this.pluginCategory,
    required this.supportedPlatforms,
    required this.lastUpdated,
    required this.additionalInfo,
  });

  // 从 JSON 创建 PluginInfoModel 实例
  factory PluginInfoModel.fromJson(Map<String, dynamic> json) {
    return PluginInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      author: json['author'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      license: json['license'] as String,
      homepage: json['homepage'] as String,
      repository: json['repository'] as String,
      dependencies: Map<String, String>.from(json['dependencies']),
      pluginType: json['pluginType'] as String,
      pluginCategory: json['pluginCategory'] as String,
      supportedPlatforms: List<String>.from(json['supportedPlatforms']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      additionalInfo: AdditionalInfo.fromJson(
          Map<String, dynamic>.from(json['additionalInfo'])),
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'author': author,
      'icon': icon,
      'description': description,
      'license': license,
      'homepage': homepage,
      'repository': repository,
      'dependencies': dependencies,
      'pluginType': pluginType,
      'pluginCategory': pluginCategory,
      'supportedPlatforms': supportedPlatforms,
      'lastUpdated': lastUpdated.toIso8601String(),
      'additionalInfo': additionalInfo.toMap(),
    };
  }

  // 转换为 Map
  Map<String, dynamic> toMap() {
    return toJson();
  }
}

class AdditionalInfo {
  final String apiVersion;
  final int minSdkVersion;
  final int maxSdkVersion;

  AdditionalInfo({
    required this.apiVersion,
    required this.minSdkVersion,
    required this.maxSdkVersion,
  });

  // 从 JSON 创建 AdditionalInfo 实例
  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      apiVersion: json['apiVersion'] as String,
      minSdkVersion: json['minSdkVersion'] as int,
      maxSdkVersion: json['maxSdkVersion'] as int,
    );
  }

  // 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'apiVersion': apiVersion,
      'minSdkVersion': minSdkVersion,
      'maxSdkVersion': maxSdkVersion,
    };
  }
}
