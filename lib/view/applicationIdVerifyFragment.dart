
import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/application.dart';
import '../model/promramme.dart';
import '../viewmodel/ApplicationViewModel.dart';
import 'appDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:developer';
import 'basePage.dart';
import 'homepage.dart';

//https://medium.com/@onuaugustine07/pick-any-file-file-picker-flutter-f82c0144e27c
// Create a Form widget.
class ApplicationIdVerifyFragment extends BasePageFragment {

  // final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type
  // const RegistrationFragment({super.key, required this.callbackNavigate});

  ApplicationIdVerifyFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  ApplicationIdVerifyFragmentState createState() {
    return ApplicationIdVerifyFragmentState();

  }
}


class ApplicationIdVerifyFragmentState extends BasePageFramentState<ApplicationIdVerifyFragment> {

  final _formKey = GlobalKey<FormBuilderState>();
  late ApplicationViewModel applicationViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    applicationViewModel = Provider.of<ApplicationViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Function(String, Map<String, dynamic>) callbackNavigate = widget
        .callbackNavigate;
    final parentState = context.findAncestorStateOfType<MyHomePageState>();
    Map<String, dynamic>? param =parentState?.argumentMap;
    Programme prog = param?["program"] ;
    debugPrint(prog.progDesc);
    String certName1 ="no file selected";
    String certName2 ="no file selected";
    String certName3 ="no file selected";
    String qualiName1 ="no file selected";
    String qualiName2 ="no file selected";
    String qualiName3 ="no file selected";
    Application currApp= applicationViewModel.currApplication;
    bool isReadOnly =isReadOnlyApplication(currApp);
    return Center(
      child:
      SizedBox(
        width: MediaQuery.of(context).size.width *0.9 ,
        child: Column (

          children: [
            const Text("Programme Application" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 5),
            Text(prog.progProvider, style: const TextStyle(fontSize: 18) ),
            const SizedBox(height: 5),
            Text(prog.progProvider, style: const TextStyle(fontSize: 20, color: Colors.greenAccent) ),



            const SizedBox(height: 10),
            const Text("ID Verification (Step4)" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 30),
            SizedBox(
              height: 150.0,
              width: MediaQuery.of(context).size.width *0.9,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  textStyle: const TextStyle(fontSize: 25),
                  padding: const EdgeInsets.all(50.0),
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: const Icon(Icons.portrait_rounded),
                onPressed: () {},
                label: const Text('Upload your ID'),
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
                height: 150.0,
                width: MediaQuery.of(context).size.width *0.9,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 25),

                    padding: const EdgeInsets.all(50.0),
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: const Icon(Icons.photo_camera_outlined),
                  onPressed: () {},
                  label: const Text('Verify ID by Selfie'),
                )
            ),

            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child:
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color:  Colors.red,
                      ),
                    ),
                    onPressed: () {
                      Map<String, dynamic> param = Map();
                      param['program'] = prog;

                      if  (isReadOnly ) {
                        print('readonly app - go back page');
                        callbackNavigate("/applicationDocument",param);
                        return;
                      }
                      callbackNavigate("/applicationDocument",param);
                    },
                    child: const Text('Back'),
                  )
                  ,
                ),
                Expanded(
                  child:
                  Visibility (
                    visible: !isReadOnly,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color:  Colors.red,
                        ),
                      ),
                      onPressed: () async {

                        Map<String, dynamic> param = Map();
                        param['program'] = prog;
                        currApp.status = "SUBMITTED";
                        currApp = await applicationViewModel.saveApplication(currApp);

                        callbackNavigate("/applicationConfirmFragment",param);
                      },
                      child: const Text('Submit'),
                    )
                  )
                  ,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
