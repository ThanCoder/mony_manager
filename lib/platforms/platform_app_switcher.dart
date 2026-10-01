import 'package:flutter/material.dart';
import 'package:mony_manager/platforms/mobile/mobile_home_screen.dart';

class PlatformAppSwitcher extends StatelessWidget {
  const PlatformAppSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileHomeScreen();
    // if (TPlatform.isDesktop) {
    //   return LayoutBuilder(
    //     builder: (context, constraints) {
    //       final isMobile = constraints.maxWidth < 500;
    //       if (isMobile) {
    //         return MobileHome();
    //       }
    //       return DesktopHome();
    //     },
    //   );
    // }
    // // final isMobile = constraints.maxWidth < 600;
    // final isMobile = TPlatform.isMobile;
    // if (isMobile) {
    //   return MobileHome();
    // }
    // return DesktopHome();
  }
}
