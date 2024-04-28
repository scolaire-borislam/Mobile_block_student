import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_block_student_adm/model/user.dart';
import 'package:provider/provider.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';

class NoValidSessionFragment extends StatelessWidget {
  final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type

  const NoValidSessionFragment({super.key, required this.callbackNavigate});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      SizedBox(
        width: MediaQuery.of(context).size.width *0.85 ,
        child:
          Center(
              child:  Column(
              children: [
                const SizedBox(height: 60),
                const Icon(
                  Icons.lock_person_outlined,
                  color: Colors.yellow,
                  size: 150.0,
                ),
                const SizedBox(height: 20),
                const Text("Please login before you access this function. Your session may have expired or you may have logged out.",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ))
                ,
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'If you have not register, please click ',
                    style: TextStyle(
                            fontSize: 18,
                              color: Colors.white,
                            )
                            ,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'here',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Add your button logic here
                            log("tap");
                              callbackNavigate("/registration",{});
                          },
                      ),
                      const TextSpan(
                        text: ' to register.',
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
      );
  }
}