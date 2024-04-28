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
class AdmissionApplicationFragment extends BasePageFragment {
  AdmissionApplicationFragment({super.key, required callbackNavigate})
      : super(callbackNavigate: callbackNavigate);

  @override
  AdmissionApplicationFragmentState createState() {
    return AdmissionApplicationFragmentState();
  }
}

class AdmissionApplicationFragmentState
    extends BasePageFramentState<AdmissionApplicationFragment> {
  late ApplicationViewModel applicationViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    applicationViewModel = Provider.of<ApplicationViewModel>(context);
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    //applicationViewModel.getApplicationList();
    //applicationViewModel.currAppList;
    Function(String, Map<String, dynamic>) callbackNavigate =
        widget.callbackNavigate;
    final parentState =
        context.findAncestorStateOfType<AdmissionApplicationFragmentState>();

    ListTile makeListTile(Application app) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.school, color: Colors.white),
          ),
          title: Text(
            app.progName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                app.progProvider,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(app.status ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.red, size: 30.0),
          onTap: () async {
            print('tap');
            applicationViewModel.currApplication = app;
            Programme prog = await applicationViewModel.getProgramme(app.progCode, app.progProvider);
            Map<String, dynamic> param = Map();
            param['program'] = prog;
            callbackNavigate("/applicationDetail",param);
            //callbackNavigate("/applicationDetail",null);

          },
        );

    Card makeCard(Application app) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(app),
          ),
        );

    return FutureBuilder<void>(
      future: applicationViewModel.getApplicationList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is loading, you can show a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print("Constant ");
          // If an error occurred while fetching data, you can display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          //List<Programme>? programs = snapshot.data;
          // If the data was successfully fetched, you can use it in your UI

          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text("Your Application",
                      style: TextStyle(fontSize: 25, color: Colors.purple)),
                  const SizedBox(height: 5),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount:
                        applicationViewModel.currAppList!.length, // your List
                    itemBuilder: (context, index) {
                      return makeCard(applicationViewModel.currAppList![index]);
                    },
                  ),
                  const SizedBox(height: 60),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
