import 'package:flutter/material.dart';
import 'package:mobile_block_student_adm/model/user.dart';
import 'package:provider/provider.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';

class LogoutSuccessfulFragment extends StatelessWidget {

  const LogoutSuccessfulFragment({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  const Center(
        child:  Column(
          children: [
            SizedBox(height: 60),
            Icon(
              Icons.logout_rounded,
              color: Colors.green,
              size: 150.0,
            ),
            SizedBox(height: 20),
            Text("You have logout successfully.", style: TextStyle(
              fontSize: 20,
              color: Colors.greenAccent,
            )),
          ],
        )
    );
  }
}