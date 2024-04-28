
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


// Create a Form widget.
class ApplicationProgramDetailFragment extends BasePageFragment {

  // final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type
  // const RegistrationFragment({super.key, required this.callbackNavigate});

  ApplicationProgramDetailFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  ApplicationProgramDetailFragmentState createState() {
    return ApplicationProgramDetailFragmentState();

  }
}


class ApplicationProgramDetailFragmentState extends BasePageFramentState<ApplicationProgramDetailFragment> {

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
    Application curApp = applicationViewModel.currApplication;
    const List<String> modeOfStudyOptions = <String>['Full-Time', 'Part-time'];
    const List<String> intakeTermsList = <String>['January', 'September'];
    const List<String> entryYearOptions = <String>['2024', '2025'];
    String? refNo ;
    if (curApp!.appId !=null) {
      refNo = "App No : ${curApp.appId}" ;
    }
    bool isReadOnly =isReadOnlyApplication(curApp);
    return Center(
      child:
      SizedBox(
        width: MediaQuery.of(context).size.width *0.9 ,
        child: Column (

          children: [
            const SizedBox(height: 10),
            const Text("Programme Application" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 5),
            Text(prog.progProvider, style: const TextStyle(fontSize: 20, color: Colors.greenAccent) ),
            const SizedBox(height: 5),
            Text(prog.progName, style: const TextStyle(fontSize: 18) ),
            const SizedBox(height: 10),
            const Text("Program Details (Step2)" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 5),
            FormBuilder(
                key: _formKey,
                child: Column (
                  children: <Widget>[
                    Text(refNo?? "" , style: TextStyle(fontSize: 16, color: Colors.yellow))  ,
                    const SizedBox(height: 10),
                    FormBuilderCheckbox(
                      name: 'SEN',
                      enabled: !isReadOnly,
                      initialValue: curApp.SEN,
                      //onChanged: _onChanged,
                      title: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Do you have special education needs (SEN)?',
                            ),

                          ],
                        ),
                      ),

                    ),

                    FormBuilderTextField(
                      name: 'senDetail',
                      enabled: !isReadOnly,
                      keyboardType: TextInputType.multiline ,
                      initialValue: curApp.senDetail,
                      maxLines: null,
                      style :Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        //labelText: 'Details of Special Needs:',
                        hintText: 'Details of SEN',
                        labelStyle :Theme.of(context).textTheme.bodyLarge,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        print(val); // Print the text value write into TextField
                      },

                    ),
                    const SizedBox(height: 10),
                    FormBuilderDropdown<String>(
                      name: 'modeOfStudy',
                      initialValue: curApp.modeOfStudy,
                      enabled: !isReadOnly,
                      style :Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: 'Mode of Study',
                        hintText: 'Select Mode of Study',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: modeOfStudyOptions
                          .map((modeOfStudy) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: modeOfStudy,
                        child: Text(modeOfStudy),
                      ))
                          .toList(),
                      onChanged: (val) {

                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDropdown<String>(
                      enabled: !isReadOnly,
                      name: 'entryYear',
                      initialValue: curApp.entryYear,
                      style :Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: 'Entry Year',
                        hintText: 'Entry Year',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: entryYearOptions
                          .map((entryyear) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: entryyear,
                        child: Text(entryyear),
                      )).toList(),
                      onChanged: (val) {

                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDropdown<String>(
                      name: 'intakeTerms',
                      enabled: !isReadOnly,
                      initialValue: curApp.intakeTerms,
                      style :Theme.of(context).textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: 'Intake Terms',
                        hintText: 'Intake Terms',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: intakeTermsList
                          .map((intake) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: intake,
                        child: Text(intake),
                      )).toList(),
                      onChanged: (val) {

                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    const SizedBox(height: 10),




                  ],
                )

            ),


            const SizedBox(height: 15),
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
                    onPressed: () async {
                      Map<String, dynamic> param = Map();
                      param['program'] = prog;

                      if  (isReadOnly ) {
                        print('readonly app - go back page');
                        callbackNavigate("/applicationDetail",param);
                        return;
                      }
                      if (_formKey.currentState!.saveAndValidate()) {
                        var formData = _formKey.currentState!.value;
                        print(formData.toString());

                        curApp.SEN= formData['SEN'];
                        curApp.senDetail= formData['senDetail'];
                        curApp.modeOfStudy= formData['modeOfStudy'];
                        curApp.entryYear= formData['entryYear'];
                        curApp.intakeTerms= formData['intakeTerms'];
                        print(jsonEncode(curApp.toJsonMap()));
                        curApp = await applicationViewModel.saveApplication(curApp);
                        callbackNavigate("/applicationDetail", param);
                      }
                    },
                    child: const Text('Back'),
                  )
                  ,
                ),
                Expanded(
                  child:
                  OutlinedButton(
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

                      if  (isReadOnly ) {
                        print('readonly app - go to next page');
                        callbackNavigate("/applicationDocument",param);
                        return;
                      }
                      if (_formKey.currentState!.saveAndValidate()) {
                        var formData = _formKey.currentState!.value;
                        print(formData.toString());

                        curApp.SEN= formData['SEN'];
                        curApp.senDetail= formData['senDetail'];
                        curApp.modeOfStudy= formData['modeOfStudy'];
                        curApp.entryYear= formData['entryYear'];
                        curApp.intakeTerms= formData['intakeTerms'];
                        print(jsonEncode(curApp.toJsonMap()));
                        curApp = await applicationViewModel.saveApplication(curApp);
                        callbackNavigate("/applicationDocument",param);
                      }

                    },
                    child: const Text('Next'),
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
