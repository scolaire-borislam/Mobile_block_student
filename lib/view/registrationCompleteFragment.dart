import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'appDrawer.dart';
import 'basePage.dart';


class RegistrationCompleteFragment extends BasePageFragment{
  RegistrationCompleteFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;
  @override
  RegistrationCompleteState createState() {
    return RegistrationCompleteState();
  }
}

class RegistrationCompleteState extends BasePageFramentState<RegistrationCompleteFragment> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  const Center(
      child:  Column(
        children: [
          SizedBox(height: 60),
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 150.0,
          ),
          SizedBox(height: 20),
          Text("Registration Completed Successfully", style: TextStyle(
              fontSize: 20,
              color: Colors.greenAccent,
          )),
        ],
      )
    );
  }
}