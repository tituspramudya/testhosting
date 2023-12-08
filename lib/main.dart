import 'package:example/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key})  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, DeviceType)
    {
      Device.orientation == Orientation.portrait
        ? SizedBox(
        width: 100.w,
        height: 20.5.h,
      )
        : SizedBox(
        width: 100.w,
        height: 12.5.h,
      );
      Device.screenType == ScreenType.tablet
          ? SizedBox(
        width: 100.w,
        height: 20.5.h,
      )
          : SizedBox(
        width: 100.w,
        height: 12.5.h,
      );
      return const MaterialApp(
        home: LoginView(),
      );
    },);
  }
}
