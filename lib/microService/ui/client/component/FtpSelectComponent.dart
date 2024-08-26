import 'package:flutter/material.dart';
import '../../../module/common/Console.dart';
import '../page/FtpClientHomePage.dart';
import '../page/FtpServerHomePage.dart';

class FtpSelectComponent extends StatefulWidget {
  const FtpSelectComponent({super.key});

  @override
  State<FtpSelectComponent> createState() => _FindServerComponentState();
}

class _FindServerComponentState extends State<FtpSelectComponent>
    with SingleTickerProviderStateMixin, Console {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      alignment: Alignment.center,
      // color: Colors.deepOrange,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ftp client
            TextButton(
                onPressed: () {
                  // 跳转设置页面
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const FtpClientHomePage();
                      },
                    ),
                  );
                },
                child: Text("ftp client")),
            // ftp server
            TextButton(
                onPressed: () {
                  // 跳转设置页面
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const FtpServerHomePage();
                      },
                    ),
                  );
                },
                child: Text("ftp server"))
          ],
        ),
      ),
    );
  }
}
