import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_block_student_adm/view/profileFragment.dart';
import 'package:mobile_block_student_adm/view/programDetailFragment.dart';
import 'package:mobile_block_student_adm/view/recoverWalletConfirmFragment.dart';
import 'package:mobile_block_student_adm/view/recoverWalletFragment.dart';
import 'package:mobile_block_student_adm/view/setupWalletFragment.dart';
import 'package:mobile_block_student_adm/view/setupWalletMnemonicFragment.dart';
import 'package:mobile_block_student_adm/view/walletFragment.dart';
import 'package:provider/provider.dart';
import '../viewmodel/HomeViewModel.dart';
import 'aboutFragment.dart';
import 'applicationConfirmFragment.dart';
import 'applicationDetailFragment.dart';
import 'applicationDocumentFragment.dart';
import 'applicationIdVerifyFragment.dart';
import 'applicationProgramDetailFragment.dart';
import 'applicationStartFragment.dart';
import 'errorFragment.dart';
import 'logoutSuccessfulFragment.dart';
import 'noValidSessionFragment.dart';
import 'programmeFragment.dart';
import 'admissionApplicationFragment.dart';
import 'appDrawer.dart';
import 'loginFragment.dart';
import 'homeFragment.dart';
import 'registrationFragment.dart';
import 'registrationConfirmFragment.dart';
import 'dart:developer';
import 'registrationCompleteFragment.dart';

//https://medium.com/@kashifmin/flutter-setting-up-a-navigation-drawer-with-multiple-fragments-widgets-1914fda3c8a8
//https://stackoverflow.com/questions/51659805/persisting-appbar-drawer-across-all-pages-flutter
//https://github.com/flutter-tuts/drawer_demo/blob/master/lib/pages/home_page.dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  // @override
  // State<MyHomePage> createState() => _MyHomePageState();
  @override
  MyHomePageState createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  String _pageName = "/home";
  Map<String, dynamic> _argumentMap = {};
  Map<String, dynamic> get argumentMap  => _argumentMap;
  bool hasError = false;

  void handleError() {
    log("Error handling now ......................");
    setState(() {
      _pageName  = "/error";
      hasError = true;
    });
    closeMenu();
  }

  void closeMenu() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(); // close the drawer
    }
  }

  @override
  void initState() {
    super.initState();

    // This captures errors reported by the FLUTTER framework.
    FlutterError.onError = (FlutterErrorDetails details) {
      print("=================== ERROR in Application (sync) ==================");
      print(details);
      handleError();

    };

    PlatformDispatcher.instance.onError = (error, stack) {
      print("=================== Error in Application (Async) ==================");
      print(error);
      print(stack);
      handleError();
      return true;
    };
  }





  void _setPageAndNavigator(String pageName, Map<String, dynamic> pageArgument) {
    setState(() {
      _pageName  = pageName;
      _argumentMap = pageArgument;
    });
    closeMenu();
    debugPrint(_pageName + "!!");
    debugPrint(_argumentMap.toString() );
  }

  // void _nagvigatePageFromMenu(String pageName, Map<String, dynamic> pageArgument) {
  //   _setPageAndNavigator(pageName, pageArgument);
  //   if (Navigator.canPop(context)) {
  //     Navigator.of(context).pop(); // close the drawer
  //   }
  //   debugPrint(_pageName + "!!");
  //   debugPrint(_argumentMap.toString() );
  // }

  _getDrawerItemWidget(String pagename) {


    switch (pagename) {
      case "/home":
        return  HomeFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
                  _pageName  = page;
                  _argumentMap = param;
                  _setPageAndNavigator(_pageName, _argumentMap);
                });
      case "/error":
        return  ErrorFragment();

      case "/profile":
        return
          ProfileFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });

      case "/logout":
        return  const LogoutSuccessfulFragment();
      case "/noValidSession":
        return   NoValidSessionFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
                _pageName  = page;
                _argumentMap = param;
                _setPageAndNavigator(_pageName, _argumentMap);
              });
      case "/login":
        return  LoginFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
                  _pageName  = page;
                  _argumentMap = param;
                  _setPageAndNavigator(_pageName, _argumentMap);
                });
      case "/wallet":
        return  Walletragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/setupWallet" :
        return SetupWalletFragment( callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/setupWalletMnemonic" :
        return SetupWalletMnemonicFragment( callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/recoverWalletConfirm" :
        return RecoverWalletConfirmFragment( callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/recoverWallet" :
        return RecoverWalletFragment( callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/admissionApplication":
        return  AdmissionApplicationFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/application" :
        return ApplicationStartFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/applicationDocument" :
        return ApplicationDocumentFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/applicationIdVerify" :
        return ApplicationIdVerifyFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/applicationConfirmFragment" :
        return ApplicationConfirmFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });

      case "/applicationDetail" :
        return ApplicationDetailFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/applicationProgram" :
        return ApplicationProgramDetailFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/programme" :
        return ProgrammeFragment();
      case "/programmeDetail" :
        return ProgrammeDetailFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName, _argumentMap);
        });
      case "/registration" :
        return RegistrationFragment(callbackNavigate: (String page, Map<String, dynamic> param) {
                  _pageName  = page;
                  _argumentMap = param;
                  _setPageAndNavigator(_pageName, _argumentMap);
                });
      case "/registrationConfirmation" :
        return RegistrationConfirmFragment( callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName,  _argumentMap);
        });
      case "/registrationComplete" :
        return RegistrationCompleteFragment( callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName,  _argumentMap);
        });
      case "/about" :
        return AboutFragment( callbackNavigate: (String page, Map<String, dynamic> param) {
          _pageName  = page;
          _argumentMap = param;
          _setPageAndNavigator(_pageName,  _argumentMap);
        });
      default:
        return  const Text("There is error in navigation");
    }
  }

  @override
  Widget build(BuildContext context) {



    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      //resizeToAvoidBottomInset : false,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
        SingleChildScrollView(
            child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
            child: _getDrawerItemWidget(_pageName),
          )
        ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.home_filled),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer:  AppDrawer( callbackNavigate: (String page, Map<String, dynamic> param) {
        _pageName  = page;
        _argumentMap = param;
        _setPageAndNavigator(_pageName,_argumentMap);
      }),


    );
  }
}
