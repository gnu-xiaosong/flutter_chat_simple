import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import '../common/serverTool.dart';

class TipWidget extends StatelessWidget {
  String? label;
  String? text;
  ServerUiTool serverUiTool = ServerUiTool();
  TipWidget({this.label, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // left
        Text(
          label!.toString(),
          style: GoogleFonts.adamina(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 12.sp,
            color: Colors.green,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
          ),
        ),
        Text(
          ":",
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        // 分割
        SizedBox(width: 3),
        // text
        Text(
          text.toString(),
          style: GoogleFonts.aleo(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 12.sp,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w700,
          ),
        ),
        // 分割
        SizedBox(width: 3),
        // copy
        GestureDetector(
          onTap: () {
            // 复制
            serverUiTool.copyToClipboard(text!);
          },
          child: const Iconify(
            Ion.copy,
            size: 15,
            color: Colors.purple,
          ),
        )
      ],
    );
  }
}
