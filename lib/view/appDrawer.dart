import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_block_student_adm/model/user.dart';
import 'package:mobile_block_student_adm/viewmodel/WalletViewModel.dart';
import 'package:provider/provider.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';

class AppDrawer extends StatelessWidget {
  final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type

  const AppDrawer({super.key, required this.callbackNavigate});
  // void logoutHandler(userManager) async{
  //
  //   // userManager.signOut().then((result) {
  //   //   // Handle the result of the signOut operation
  //   //   print("sign out complete !");
  //   //
  //   // });
  //   await userManager.signOut();
  //
  // }

  @override
  Widget build(BuildContext context) {
    UserManager userManager = context.watch<UserManager>();
    User? user = userManager?.user;
    String username = user ==null ? "" : user.email;
    bool validSession = userManager.checkValidSession();

    WalletViewModel walletViewModel = context.watch<WalletViewModel>();
    String walletPublicAddress = walletViewModel.walletPublicAddress;
    bool walletCreated = false;
    if (walletPublicAddress != "NO_DATA_FOUND") {
      walletCreated = true;
    } else {
      walletCreated = false;
    }
    return
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          child: Column (
            children : <Widget> [
              Expanded (
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  //padding: EdgeInsets.zero,
                  children:  [
                     SizedBox(
                      //height: 200,
                      child: DrawerHeader(
                        decoration:  BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Column(
                              children: <Widget>[
                                SizedBox(height: 16.0),
                                FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: Image.asset(
                                    'assets/Scolaire-Ledger-horizontal-white.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                    )
                    ,
                    ListTile(
                      leading: const Icon(Icons.home_filled),
                      title:  const Text('Home'),
                      onTap: () {
                        callbackNavigate('/home',{});
                      },
                    ),
                    Visibility(
                      visible: validSession,
                      child:
                      ListTile(
                        leading: const Icon(Icons.person),
                        title:  const Text('Profile'),
                        onTap: () {
                          callbackNavigate('/profile',{});
                        },
                      ),
                    ),
                    Visibility(
                      visible: !validSession,
                      child:
                        ListTile(
                          leading: const Icon(Icons.app_registration),
                          title:  const Text('Account Registration'),
                          onTap: () {
                            callbackNavigate('/registration',{});
                          },
                        )
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.school_outlined),
                    //   title:  const Text('Programme'),
                    //   onTap: () {
                    //     // Navigator.pushNamed(context, '/login');
                    //     callbackNavigate('/programme',{});
                    //   },
                    // ),
                    Visibility(
                      visible: validSession,
                      child:
                        ListTile(
                          leading: const Icon(Icons.door_back_door_outlined),
                          title:  const Text('My Application'),
                          onTap: () {
                            callbackNavigate('/admissionApplication',{});
                          },
                        )
                    ),
                    ListTile(
                      leading: const Icon(Icons.wallet_outlined),
                      title:  const Text('My Wallet'),
                      onTap: () {
                        if (!validSession) {
                          callbackNavigate('/noValidSession', {});
                        } else {
                          if (walletCreated) {
                            print('wallet created');
                            callbackNavigate('/wallet', {});
                          } else {
                            print('no wallet created');
                            callbackNavigate('/setupWallet',{});
                          }

                          //
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title:  const Text('About'),
                      onTap: () {
                         callbackNavigate('/about',{});
                      }
                    ),

                  ],
                ),
              ),
              SizedBox( // footer size box
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          const Divider(),
                          Visibility(
                            visible: !validSession,
                             child: ListTile(
                                  leading:const Icon(Icons.login),
                                  title: const Text('Login'),
                                  onTap: () {
                                    // Navigator.pushNamed(context, '/login');
                                    callbackNavigate('/login',{});
                                  },
                              )
                          )
                          ,
                          Visibility(
                              visible: validSession,
                              //visible: true,
                            child:
                            ListTile(
                                  leading: Icon(Icons.logout),
                                  title: Text('Logout'),
                                  onTap: () async  {
                                     bool signout = await userManager.signOut();
                                     if (signout) {
                                       var  snackBar = SnackBar(
                                         content: const Text("Logout Successfully!", style: TextStyle(fontSize: 16)),
                                         backgroundColor: Colors.lightGreenAccent,
                                         behavior: SnackBarBehavior.floating,
                                         margin: const EdgeInsets.all(20),
                                         action: SnackBarAction(
                                           label: 'Dismiss',
                                           onPressed: () {
                                             // Some code to undo the change.
                                           },
                                         ),
                                       );
                                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                       callbackNavigate('/home',{});
                                     }

                                  },
                              )
                          ),

                        ],
                      ))),
            ],

          ),

        ),
      );
  }
}



