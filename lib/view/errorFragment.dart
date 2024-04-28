import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_block_student_adm/model/user.dart';
import 'package:provider/provider.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';

class ErrorFragment extends StatelessWidget {

  const ErrorFragment({super.key});

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
                  Icons.error,
                  color: Colors.yellow,
                  size: 150.0,
                ),
                const SizedBox(height: 20),
                const Text("There is some error in the system. Please try again later!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ))
                ,
                const SizedBox(height: 10),

              ],
            )
        ),
      );
  }
}