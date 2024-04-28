
import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
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
//class RegistrationFragment extends StatefulWidget {
class ApplicationStartFragment extends BasePageFragment {

  // final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type
  // const RegistrationFragment({super.key, required this.callbackNavigate});

  ApplicationStartFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  ApplicationStartFragmentState createState() {
    return ApplicationStartFragmentState();

  }
}


//class RegistrationFragmentState extends State<RegistrationFragment> {
class ApplicationStartFragmentState extends BasePageFramentState<ApplicationStartFragment> {

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

    return Center(
        child:
              SizedBox(
                  width: MediaQuery.of(context).size.width *0.9 ,
                  child: Column (

                    children: [

                      const SizedBox(height: 10),
                      const Text("Programme Application" , style: TextStyle(fontSize: 25, color: Colors.purple)),
                      const SizedBox(height: 10),
                      Text(prog.progProvider, style: const TextStyle(fontSize: 20, color: Colors.greenAccent) ),
                      const SizedBox(height: 5),
                      Text(prog.progName, style: const TextStyle(fontSize: 18) ),
                      const SizedBox(height: 15),
                      Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text("To apply this programme, you are required to upload some supplementary documents. Please prepare the following documents before submitting the application:", style:  TextStyle(fontSize: 18,color: Colors.blueGrey) ),
                          const SizedBox(height: 10),
                          const Text("⚈ a copy of the Hong Kong Identity Card and",style:  TextStyle(fontSize: 15) ),
                          const Text("⚈ a copy of your photo",style:  TextStyle(fontSize: 15) ),
                          const Text("⚈ a copy of the transcript(s) / award(s) / public examination result(s)",style:  TextStyle(fontSize: 15) ),
                          const SizedBox(height: 15),
                          const Text("Personal Data Collection Statement:", style:  TextStyle(fontSize: 18,color: Colors.blueGrey) ),
                          const SizedBox(height: 5),
                          const Text("The personal data provided will be used by Hong Kong Institute of Technology (HKIT) for purposes related to application, enrolment and student administration. I authorize the HKIT / University of West London / Wrexham University to use my data for issues related to my application or for statistical and research purpose.",style:  TextStyle(fontSize: 15) ),
                          const SizedBox(height: 15),
                        ],
                      ),
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
                          applicationViewModel.startApplication();
                          callbackNavigate("/applicationDetail",param);
                        },
                        child: const Text('Agree Terms and Start Application'),
                      ),
                    ],
                  ),
              ),
    );
  }
}