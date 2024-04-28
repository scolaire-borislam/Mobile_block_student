import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:json_theme/json_theme.dart';
import 'dart:convert'; // For jsonDecode
import 'package:mobile_block_student_adm/view/homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_block_student_adm/viewmodel/ApplicationDetailViewModel.dart';
import 'package:mobile_block_student_adm/viewmodel/ApplicationViewModel.dart';
import 'package:mobile_block_student_adm/viewmodel/ProfileViewModel.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';
import 'package:mobile_block_student_adm/viewmodel/WalletViewModel.dart';
import 'package:provider/provider.dart';
import 'view/loginFragment.dart';
import 'view/profileFragment.dart';
import 'viewmodel/LoginViewModel.dart';
import 'package:mobile_block_student_adm/viewmodel/HomeViewModel.dart';

void main() async {
  // https://github.com/zeshuaro/appainter/blob/main/USAGE.md
  await dotenv.load(fileName:'assets/.env');
  //WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  FlutterError.onError = (FlutterErrorDetails details) {
    print("=================== ERROR from OUTSIDE==================");
    print(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    print("=================== OUTSIDE PlatformDispatcher FLUTTER ERROR ==================");
    print(error);
    return true;
  };
  // runZonedGuarded(() async {
  //await runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserManager()),
          ChangeNotifierProxyProvider<UserManager , ProfileViewModel>(
            create: (context) => ProfileViewModel(context),
            update: (context, userManager, profileViewModel) {
              if (userManager == null) throw ArgumentError.notNull('userManager');
              profileViewModel!.userManager = userManager;
              return profileViewModel;
            },
          ),
          ChangeNotifierProxyProvider<UserManager , LoginViewModel>(
            create: (context) => LoginViewModel(context),
            update: (context, userManager, loginViewModel) {
                if (userManager == null) throw ArgumentError.notNull('userManager');
                loginViewModel!.userManager = userManager;
                return loginViewModel;
              },
          ),
          ChangeNotifierProxyProvider<UserManager , HomeViewModel>(
            create: (context) => HomeViewModel(context),
            update: (context, userManager, homeViewModel) {
              if (userManager == null) throw ArgumentError.notNull('userManager');
              homeViewModel!.userManager = userManager;
              return homeViewModel;
            },
          ),
          ChangeNotifierProxyProvider<UserManager , ApplicationViewModel>(
            create: (context) => ApplicationViewModel(context),
            update: (context, userManager, applicationViewModel) {
              if (userManager == null) throw ArgumentError.notNull('userManager');
              applicationViewModel!.userManager = userManager;
              return applicationViewModel;
            },
          ),
          // ChangeNotifierProxyProvider<UserManager , ApplicationDetailViewModel>(
          //   create: (context) => ApplicationDetailViewModel(context),
          //   update: (context, userManager, applicationDetailViewModel) {
          //     if (userManager == null) throw ArgumentError.notNull('userManager');
          //     applicationDetailViewModel!.userManager = userManager;
          //     return applicationDetailViewModel;
          //   },
          // ),
          ChangeNotifierProxyProvider<UserManager , WalletViewModel>(
            create: (context) => WalletViewModel(context),
            update: (context, userManager, walletViewModel) {
              if (userManager == null) throw ArgumentError.notNull('userManager');
              walletViewModel!.userManager = userManager;
              return walletViewModel;
            },
          ),
        ],
        child:  MyApp(theme: theme),
      ),
    );
  // }
  //   ,  onError: (error, stackTrace) {
  //       print("Error FROM OUT_SIDE FRAMEWORK ");
  // });
  // ,(error, stackTrace) {
  //   print("Error FROM OUT_SIDE FRAMEWORK ");
  //   print("--------------------------------");
  //   print("Error :  $error");
  //   print("StackTrace :  $stackTrace");
  // });
}


class MyApp extends StatelessWidget {
  //const MyApp({super.key});
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // This captures errors reported by the FLUTTER framework.
    // FlutterError.onError = (FlutterErrorDetails details) {
    //   print("=================== CAUGHT FLUTTER ERROR");
    //   // Send report
    //   // NEVER REACHES HERE - WHY?
    // };

    return MaterialApp(
      title: 'Flutter HKIT',
      theme: theme,
      home: const MyHomePage(title: 'HKIT'),
      initialRoute: '/',
      // routes: {
      //   '/login': (context) => const LoginPage(),
      //   '/profile': (context) => const ProfilePage(),
      // },
    );
  }
}

