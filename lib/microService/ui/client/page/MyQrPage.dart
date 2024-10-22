import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../common/Tool.dart';
import '../model/AppSettingModel.dart';
import '../module/AppSettingModule.dart';

class MyQrPage extends StatefulWidget {
  const MyQrPage({super.key});

  @override
  State<MyQrPage> createState() => _MyQrPageState();
}

class _MyQrPageState extends State<MyQrPage> {
  AppClientSettingModule appClientSettingModule = AppClientSettingModule();

  // 添加一个方法来获取并编码二维码信息
  Future<String> getQrMessage() async {
    // 生成二维码信息
    Map qrInfo = await UiTool().generateAddUserQrInfo();

    print("qr info: ${qrInfo}");
    return json.encode(qrInfo);
  }

  @override
  Widget build(BuildContext context) {
    AppClientSettingModel? appClientSettingModel =
        appClientSettingModule.getAppConfig();
    return Scaffold(
        appBar: AppBar(
          title: Text('My Qr'.tr()),
          actions: [],
        ),
        body: Container(
            color: Colors.white54,
            alignment: Alignment.center,
            width: double.infinity,
            height: double.maxFinite,
            child: FutureBuilder<String>(
                future: getQrMessage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    String qrData = snapshot.data!;
                    if (qrData.length > 288) {
                      return Text("QR data too long: ${qrData.length} > 288");
                    } else {
                      return Align(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.purple],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25), // 设置圆角
                              ),
                              width: 250.w,
                              height: 250.h,
                              child: PrettyQr(
                                data: qrData,
                                size: 250,
                                roundEdges: true,
                                errorCorrectLevel: QrErrorCorrectLevel.M,
                                image: AssetImage('assets/images/app_icon.png'),
                              ),
                            ),
                            SizedBox(height: 20),
                            // 用戶名称
                            Center(
                              child:
                                  Text("用户:${appClientSettingModel?.username}"),
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    return Text("No data available");
                  }
                })));
  }
}
