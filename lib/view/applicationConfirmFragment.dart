
import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import '../model/promramme.dart';
import 'appDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:developer';
import 'basePage.dart';
import 'homepage.dart';

//https://github.com/flutter-form-builder-ecosystem/flutter_form_builder/blob/main/example/lib/sources/complete_form.dart

// Create a Form widget.
class ApplicationConfirmFragment extends BasePageFragment {


  ApplicationConfirmFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  ApplicationConfirmFragmentState createState() {
    return ApplicationConfirmFragmentState();

  }
}


class ApplicationConfirmFragmentState extends BasePageFramentState<ApplicationConfirmFragment> {

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Function(String, Map<String, dynamic>) callbackNavigate = widget
        .callbackNavigate;
    final parentState = context.findAncestorStateOfType<MyHomePageState>();
    Map<String, dynamic>? param =parentState?.argumentMap;
    Programme prog = param?["program"] ;
    debugPrint(prog.progDesc);
    const List<String> genderOptions = <String>['Male', 'Female'];
    const List<String> modeOfStudy = <String>['Full-Time', 'Part-time'];
    return Center(
      child:
      SizedBox(
        width: MediaQuery.of(context).size.width *0.9 ,
        child: Column (

          children: [
            const SizedBox(height: 5),
            const Text("Programme Application" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 5),
            Text(prog.progProvider, style: const TextStyle(fontSize: 20, color: Colors.greenAccent) ),
            const SizedBox(height: 5),
            Text(prog.progName, style: const TextStyle(fontSize: 18) ),
            const SizedBox(height: 10),
            const Text("Submitted" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 10),
            SizedBox(height: 60),
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 150.0,
            ),
            SizedBox(height: 20),
            const Text("Application submitted successfully", style: TextStyle(
              fontSize: 20,
              color: Colors.greenAccent,
            )),


            const SizedBox(height: 15),


          ],
        ),
      ),
    );
  }
}
