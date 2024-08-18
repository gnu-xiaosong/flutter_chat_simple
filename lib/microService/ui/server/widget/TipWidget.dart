import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import '../common/serverTool.dart';

class TipWidget extends StatefulWidget {
  String? label;
  String? text;

  TipWidget({this.label, this.text});

  @override
  State<TipWidget> createState() => _IndexState();
}

class _IndexState extends State<TipWidget> {
  ServerUiTool serverUiTool = ServerUiTool();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // left
        Text(
          widget.label!.toString(),
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
          widget.text.toString(),
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
            serverUiTool.copyToClipboard(widget.text!);
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
