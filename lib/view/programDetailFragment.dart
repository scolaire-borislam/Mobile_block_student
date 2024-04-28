import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile_block_student_adm/viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';
import '../model/promramme.dart';
import '../viewmodel/ApplicationViewModel.dart';
import 'appDrawer.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'basePage.dart';
import 'homepage.dart';

// Create a Form widget.
class ProgrammeDetailFragment extends  BasePageFragment {

  ProgrammeDetailFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  ProgrammeDetailFragmentState createState() {
    return ProgrammeDetailFragmentState();
  }
}

class ProgrammeDetailFragmentState extends  BasePageFramentState<ProgrammeDetailFragment> {

  // ScrollController _scrollController = ScrollController();
  late ApplicationViewModel applicationViewModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    applicationViewModel = Provider.of<ApplicationViewModel>(context);
  }


  //this._argumentMap
  @override
  Widget build(BuildContext context) {
    Function(String, Map<String, dynamic>) callbackNavigate = widget.callbackNavigate;
    final parentState = context.findAncestorStateOfType<MyHomePageState>();
    Map<String, dynamic>? param =parentState?.argumentMap;
    Programme prog = param?["program"] ;
    debugPrint(prog.progDesc);
    bool validSession = applicationViewModel.userManager.checkValidSession();
    // if (_scrollController.hasClients) {
    //   _scrollController.jumpTo(0);
    // }
    // TODO: implement build
    return   Center(
      child:  SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.8,
          child:  Column(
              children: <Widget>[
                Image.network(
                  (prog.img2 ) as String,
                  //width: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text("${prog.progName}", style: const TextStyle(fontSize: 25, color: Colors.white),),
                const SizedBox(height: 10),
                Image.network(
                  (prog.img1 ) as String,
                  //width: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Program Description", style:  TextStyle(fontSize: 18, color: Colors.purple),),
                    const SizedBox(height: 5),
                    Text(prog.progDesc ?? ""),
                    const SizedBox(height: 15),
                    const Text("Program Duration", style:  TextStyle(fontSize: 18, color: Colors.purple),),
                    const SizedBox(height: 5),
                    Text(prog.duration ?? ""),
                    const SizedBox(height: 15),
                    const Text("Mode of Study", style:  TextStyle(fontSize: 18, color: Colors.purple),),
                    const SizedBox(height: 5),
                    Text(prog.modeOfStudy ?? ""),
                    const SizedBox(height: 15),
                    const Text("Entry Requirement", style:  TextStyle(fontSize: 18, color: Colors.purple),),
                    const SizedBox(height: 5),
                    Text(prog.entryReqEng ?? ""),
                    const SizedBox(height: 15),
                    const Text("Other Requirement", style:  TextStyle(fontSize: 18, color: Colors.purple),),
                    const SizedBox(height: 5),
                    Text(prog.entryReqGeneral ?? ""),
                    const SizedBox(height: 15),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color:  Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Map<String, dynamic> param = Map();
                        param['program'] = prog;
                        if (!validSession) {
                          callbackNavigate('/noValidSession', {});
                        } else {
                          callbackNavigate("/application", param);
                        }
                      },
                      child: const Text('Start Application'),
                    ),
                    const SizedBox(height: 15),
                  ],


                ),

              ]
          )

      )
    );
  }

}