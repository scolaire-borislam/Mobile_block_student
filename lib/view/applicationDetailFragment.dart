
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

//https://github.com/flutter-form-builder-ecosystem/flutter_form_builder/blob/main/example/lib/sources/complete_form.dart

// Create a Form widget.
class ApplicationDetailFragment extends BasePageFragment {

  // final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type
  // const RegistrationFragment({super.key, required this.callbackNavigate});

  ApplicationDetailFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  ApplicationDetailFragmentState createState() {
    return ApplicationDetailFragmentState();

  }
}


//class RegistrationFragmentState extends State<RegistrationFragment> {
class ApplicationDetailFragmentState extends BasePageFramentState<ApplicationDetailFragment> {

  final _formKey = GlobalKey<FormBuilderState>();
  late ApplicationViewModel applicationViewModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    applicationViewModel = Provider.of<ApplicationViewModel>(context);
  }


  final ImagePicker _picker = ImagePicker();

  Future getImage(String doc) async {
    log('pick image file 1');
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    log('pick image file 2');
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
    const List<String> genderOptions = <String>['Male', 'Female'];
    const List<String> modeOfStudy = <String>['Full-Time', 'Part-time'];
    Application curApp = applicationViewModel.currApplication;
    debugPrint(curApp.email);
    debugPrint(curApp.surname);
    curApp.dob = DateTime.now().subtract(Duration(days: 17 * 365));
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
            const Text("Programme Application" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 5),
            Text(prog.progProvider, style: const TextStyle(fontSize: 20, color: Colors.greenAccent) ),
            const SizedBox(height: 5),
            Text(prog.progName, style: const TextStyle(fontSize: 18) ),
            const SizedBox(height: 10),
            const Text("Personal Details (Step1)" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 5),
            FormBuilder(
                key: _formKey,
                child: Column (
                  children: <Widget>[
                    Text(refNo?? "" , style: TextStyle(fontSize: 16, color: Colors.yellow))  ,
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'surname',
                      initialValue: curApp.surname,
                      style :Theme.of(context).textTheme.bodyLarge,
                      readOnly:  isReadOnly ,
                      decoration: InputDecoration(
                        labelText: 'Surname',
                        labelStyle :Theme.of(context).textTheme.bodyLarge,
                        // suffixIcon: _surNameError
                        //     ? const Icon(Icons.error, color: Colors.red)
                        //     : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        print(val); // Print the text value write into TextField
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'givenName',
                      initialValue: curApp.givenName,
                      style :Theme.of(context).textTheme.bodyLarge,
                      readOnly:  isReadOnly ,
                      decoration: InputDecoration(
                        labelText: 'Given Name',
                        labelStyle :Theme.of(context).textTheme.bodyLarge,
                      ),
                      onChanged: (val) {
                        print(val); // Print the text value write into TextField
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderDropdown<String>(
                      name: 'gender',
                      style :Theme.of(context).textTheme.bodyLarge,
                      initialValue: curApp.gender,
                      enabled:  !isReadOnly ,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        // suffix: _genderHasError
                        //     ? const Icon(Icons.error)
                        //     : const Icon(Icons.check),
                        hintText: 'Select Gender',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: genderOptions
                          .map((gender) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: gender,
                        child: Text(gender),
                      ))
                          .toList(),
                      onChanged: (val) {
                        // setState(() {
                        //   _genderHasError = !(_formKey
                        //       .currentState?.fields['gender']
                        //       ?.validate() ??
                        //       false);
                        // });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderTextField(
                      maxLength: 4,
                      name: 'idDoc',
                      initialValue: curApp.idDocNo,
                      style :Theme.of(context).textTheme.bodyLarge,
                      readOnly:  isReadOnly ,
                      decoration: InputDecoration(
                        labelText: 'First 4 digits of ID Document :',
                        labelStyle :Theme.of(context).textTheme.bodyLarge,
                      ),

                      onChanged: (val) {
                        print(val); // Print the text value write into TextField
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'dob',
                      format: DateFormat('yyyy-MM-dd'),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialValue: curApp.dob,
                      inputType: InputType.date,
                      enabled:  !isReadOnly ,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['dob']?.didChange(null);
                          },
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      // locale: const Locale.fromSubtags(languageCode: 'fr'),
                    ),
                    FormBuilderTextField(
                      name: 'email',
                      initialValue: curApp.email,
                      style :Theme.of(context).textTheme.bodyLarge,
                      readOnly:  isReadOnly ,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle :Theme.of(context).textTheme.bodyLarge,
                      ),
                      onChanged: (val) {
                        print(val); // Print the text value write into TextField
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email()
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'mobile',
                      style :Theme.of(context).textTheme.bodyLarge,
                      initialValue: curApp.mobileContact,
                      readOnly:  isReadOnly ,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        labelStyle :Theme.of(context).textTheme.bodyLarge,
                        // suffixIcon: _mobileError
                        //     ? const Icon(Icons.error, color: Colors.red)
                        //     : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        print(val); // Print the text value write into TextField
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric()
                      ]),
                    ),
                    // Expanded(
                    //   child :
                      FormBuilderTextField(
                        name: 'address',
                        initialValue: curApp.contractAddress,
                        keyboardType: TextInputType.multiline ,
                        readOnly:  isReadOnly ,
                        //expands: true,
                        maxLines: null,
                        // minLines: 1, // <-- SEE HERE
                        // maxLines: 3, // <-- SEE HERE
                        style :Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle :Theme.of(context).textTheme.bodyLarge,
                          border: OutlineInputBorder(),

                          // suffixIcon: _mobileError
                          //     ? const Icon(Icons.error, color: Colors.red)
                          //     : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (val) {
                          print(val); // Print the text value write into TextField
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),

                        ]),
                      ),
                    // ),
                  ],
                )

            ),


            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child:
                   Visibility(
                    visible: !isReadOnly,
                    child: OutlinedButton(
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
                        callbackNavigate("/application",param);
                      },
                      child: const Text('Back'),
                    )
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
                          callbackNavigate("/applicationProgram", param);
                          return;
                        }

                        if ( _formKey.currentState!.saveAndValidate()) {
                          print('Not readonly app - save and go to next page');
                          var formData = _formKey.currentState!.value;
                          print(formData.toString());

                          print(curApp);
                          curApp.email= formData['email'];
                          curApp.surname= formData['surname'];
                          curApp.givenName= formData['givenName'];
                          curApp.gender= formData['gender'];
                          curApp.dob= formData['dob'];
                          curApp.idDocNo= formData['idDoc'];
                          curApp.mobileContact= formData['mobile'];
                          curApp.contractAddress= formData['address'];
                          curApp.progCode=prog.progCode;
                          curApp.progName=prog.progName;
                          curApp.progProvider=prog.progProvider;
                          print(jsonEncode(curApp.toJsonMap()));
                          curApp.status="IN PROGRESS";
                          curApp = await applicationViewModel.saveApplication(curApp);
                          callbackNavigate("/applicationProgram", param);
                          return;
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
