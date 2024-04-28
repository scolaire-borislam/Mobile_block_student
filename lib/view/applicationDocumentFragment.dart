
import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dotted_border/dotted_b\order.dart';
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
import 'package:image_picker/image_picker.dart';
//https://www.youtube.com/watch?v=dhKRflZUicU
//https://github.com/afgprogrammer/Flutter-file-select-upload/blob/master/lib/main.dart
//https://medium.com/@onuaugustine07/pick-any-file-file-picker-flutter-f82c0144e27c
// Create a Form widget.

class ApplicationDocumentFragment extends BasePageFragment {

  // final Function(String, Map<String, dynamic>) callbackNavigate; // Notice the variable type
  // const RegistrationFragment({super.key, required this.callbackNavigate});

  ApplicationDocumentFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  ApplicationDocumentFragmentState createState() {
    return ApplicationDocumentFragmentState();

  }
}


class ApplicationDocumentFragmentState extends BasePageFramentState<ApplicationDocumentFragment> {

  //final _formKey = GlobalKey<FormBuilderState>();
  final ImagePicker _picker = ImagePicker();

  bool photoPathError = false;
  bool certPathError = false;
  bool proQualPathError = false;
  bool isLoading = false;
  late ApplicationViewModel applicationViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    applicationViewModel = Provider.of<ApplicationViewModel>(context);
  }

  Future<void> uploadFile(context, XFile? file, String fileType) async {
    // Simulating file upload delay
    await applicationViewModel.uploadDocument(file, fileType);

    if (context.mounted) {

      setState(() {
        isLoading = false; // Set isLoading to false when uploading completes
      });
      Navigator.pop(context);
      var  snackBar = SnackBar(
        content: const Text("Uploaded Successfully!", style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.lightGreenAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(isLoading);
      print("upload completed");
    }
  }

  void confirmUploadModal(BuildContext context, XFile? file, String fileType){
    showModalBottomSheet<void>(
      isDismissible : false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,StateSetter setState)
        {
          return Container(
            height: 600,
            color: Colors.grey,
            child: Center(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Center(
                  // child:
                  Text('Upload the file ${file!.name} ?',style:
                        TextStyle(fontSize:18),),
                  // ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    child: isLoading ?  Text('Uploading ... ') :
                    Text('Yes, start Upload'),
                    onPressed:
                        isLoading ? null :
                        () async {
                              setState(() {
                                isLoading =  true; // Set isLoading to true when uploading starts
                              });
                              print(isLoading);
                              await uploadFile(context,file, fileType);

                          },
                  ),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: isLoading,
                    child: const CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
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
    Application currApp= applicationViewModel.currApplication;
    String photoPath =currApp.photoPath ?? "";
    String certName1 =currApp.educationQualification1 ?? "";
    String certName2 =currApp.educationQualification2 ?? "";
    String certName3 =currApp.educationQualification3 ?? "";
    String proQualName1 =currApp.professionalQualification1 ?? "";
    String proQualName2 =currApp.professionalQualification2 ??"";
    String proQualName3 =currApp.professionalQualification3 ?? "";

    bool isReadOnly =isReadOnlyApplication(currApp);

    bool validateInput(){
      if (currApp.photoPath ==null) {
        print('no photo uploaded');
        setState(() {
          photoPathError = true;
        });
      }  else {
        setState(() {
          photoPathError = false;
        });
      }
      if (currApp.educationQualification1 ==null &&
              currApp.educationQualification2 ==null &&
              currApp.educationQualification3 ==null ) {
        print('no edu cert uploaded');
        setState(() {
          certPathError = true;
        });
      }else {
        setState(() {
          certPathError = false;
        });
      }
      //check photo
      print(photoPathError);
      print(certPathError);
      if (photoPathError || certPathError) {
        print('Missing files');
        return false;
      } else {
        print('No Missing files');
        return true;
      }
    }
    String? refNo ;
    if (currApp!.appId !=null) {
      refNo = "App No : ${currApp.appId}" ;
    }
    debugPrint(currApp.email);
    debugPrint(currApp.surname);

    return Center(
      child:
      SizedBox(
        width: MediaQuery.of(context).size.width *0.9 ,
        child:

          Column (

          children: [
            const SizedBox(height: 10),
            const Text("Programme Application" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 5),
            Text(prog.progProvider, style: const TextStyle(fontSize: 20, color: Colors.greenAccent) ),
            const SizedBox(height: 5),
            Text(prog.progName, style: const TextStyle(fontSize: 18) ),


            const SizedBox(height: 10),
            const Text("Upload Documents (Step3)" , style: TextStyle(fontSize: 25, color: Colors.purple)),
            const SizedBox(height: 10),
            Text(refNo?? "" , style: TextStyle(fontSize: 16, color: Colors.yellow))  ,
            const SizedBox(height: 10),
            Row(
                children: [
                  const Text("Upload your photo :" , style:  TextStyle(fontSize: 18))
                ]
            ),

            const SizedBox(height: 10),
            DottedBorder(
                color: Colors.white,
                strokeWidth: 2,
                child:
                Column (
                  children: [
                    Row(
                        children: [
                          const SizedBox(height: 1, width:10),

                          ElevatedButton(

                            onPressed:
                              isReadOnly ? null:
                                () async {
                                XFile? photoFile = await applicationViewModel.getImage("photoDoc");
                                debugPrint(photoFile?.path);
                                if (context.mounted) {
                                  confirmUploadModal(context,photoFile,"photoDoc");
                                }
                              },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,),
                            child: const Text("..."),
                          ),
                          const SizedBox(height: 1, width:20),
                          photoPath =="" ?
                          const Text('No File Selected') :
                          TextButton(
                            onPressed: () async {
                              print('start view file..');
                              String docHttpPath = await applicationViewModel.getDocumentUrl(photoPath);
                              log(docHttpPath);
                              openImagePreviewSheet(docHttpPath);
                              //openInAppBrowser('https://picsum.photos/250?image=9');
                            },
                            child: Text('View file ...'),
                          ),

                        ]
                    ),

                  ],
                ) ,

            ),
            Visibility(
                visible: photoPathError,
                child: Text("Photo cannot be empty", style: TextStyle(color: Colors.red),)
            ),
            const SizedBox(height: 25),
            Row(
                children: [
                  const Text("Upload your education certificate :" , style:  TextStyle(fontSize: 18))
                ]
            ),
            const SizedBox(height: 10),
            Row(
                children: [
                  const Text("(e.g. HKDSE/HKALE/HKCEE)" )
                ]
            ),
            const SizedBox(height: 10),
            DottedBorder(
            color: Colors.white,
            strokeWidth: 2,
            child:
               Row(
                  children: [
                    Text("  "),
                    ElevatedButton(
                      onPressed:
                      isReadOnly ? null:
                      () async {
                        XFile? qualiFile1 = await applicationViewModel.getImage("quali1");
                        debugPrint(qualiFile1?.path);
                        if (context.mounted) {
                          confirmUploadModal(context,qualiFile1,"quali1");
                        }
                      }
                      ,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,),
                      child: const Text("..."),
                    ),
                    const SizedBox(height: 1, width:20),
                    certName1 =="" ?
                    const Text('No File Selected') :
                    TextButton(
                      onPressed: () async {
                        print('start view file..');
                        String docHttpPath = await applicationViewModel.getDocumentUrl(certName1);
                        log(docHttpPath);
                        openImagePreviewSheet(docHttpPath);
                      },
                      child: Text('View file ...'),
                    ),

                  ]
              )

            ),

            const SizedBox(height: 5),
            DottedBorder(
              color: Colors.white,
              strokeWidth: 2,
              child:
                  Row(
                      children: [
                        Text("  "),
                        ElevatedButton(
                          onPressed: isReadOnly ? null:
                              () async  {
                            XFile? qualiFile2 = await applicationViewModel.getImage("quali2");
                            debugPrint(qualiFile2?.path);
                            if (context.mounted) {
                              confirmUploadModal(context,qualiFile2,"quali2");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,),
                          child: const Text("..."),
                        ),
                        const SizedBox(height: 1, width:20),
                        certName2 =="" ?
                        const Text('No File Selected') :
                        TextButton(
                          onPressed: () async {
                            print('start view file..');
                            String docHttpPath = await applicationViewModel.getDocumentUrl(certName2);
                            log(docHttpPath);
                            openImagePreviewSheet(docHttpPath);
                          },
                          child: Text('View file ...'),
                        ),
                      ]
                  ),
            ),
            const SizedBox(height: 5),
            DottedBorder(
                color: Colors.white,
                strokeWidth: 2,
                child:
                    Row(
                        children: [
                          Text("  "),
                          ElevatedButton(
                            onPressed: isReadOnly ? null:
                            () async   {
                              XFile? qualiFile3 = await applicationViewModel.getImage("quali3");
                              debugPrint(qualiFile3?.path);
                              if (context.mounted) {
                                confirmUploadModal(context,qualiFile3,"quali3");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,),
                            child: const Text("..."),
                          ),
                          const SizedBox(height: 1, width:20),
                          certName3 =="" ?
                          const Text('No File Selected') :
                          TextButton(
                            onPressed: () async {
                              print('start view file..');
                              String docHttpPath = await applicationViewModel.getDocumentUrl(certName3);
                              log(docHttpPath);
                              openImagePreviewSheet(docHttpPath);
                            },
                            child: Text('View file ...'),
                          ),
                        ]
                    ),
              ),
            Visibility(
                visible: certPathError,
                child: Text("Please at least upload 1 certificate", style: TextStyle(color: Colors.red),)
            ),
            const SizedBox(height: 25),
            Row(
                children: [
                const Text("Upload your other certificate :" , style:  TextStyle(fontSize: 18))
                ]
            ),


            const SizedBox(height: 10),
            DottedBorder(
              color: Colors.white,
              strokeWidth: 2,
              child:
                  Row(
                    children: [
                      Text("  "),
                      ElevatedButton(
                        onPressed: isReadOnly ? null:
                            () async  {
                            XFile? proFile1 = await applicationViewModel.getImage("pro1");
                            debugPrint(proFile1?.path);
                            if (context.mounted) {
                              confirmUploadModal(context,proFile1,"pro1");
                            }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,),
                        child: const Text("..."),
                      ),
                      const SizedBox(height: 1, width:20),
                      proQualName1 =="" ?
                      const Text('No File Selected') :
                      TextButton(
                        onPressed: () async {
                          print('start view file..');
                          String docHttpPath = await applicationViewModel.getDocumentUrl(proQualName1);
                          log(docHttpPath);
                          openImagePreviewSheet(docHttpPath);
                        },
                        child: Text('View file ...'),
                      ),
                    ]
                  ),
            ),
            const SizedBox(height: 5),
            DottedBorder(
              color: Colors.white,
              strokeWidth: 2,
              child:
                    Row(
                        children: [
                          Text("  "),
                          ElevatedButton(
                            onPressed:
                              isReadOnly ? null:
                                () async  {
                              XFile? proFile2 = await applicationViewModel.getImage("pro2");
                              debugPrint(proFile2?.path);
                              if (context.mounted) {
                                confirmUploadModal(context,proFile2,"pro2");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,),
                            child: const Text("..."),
                          ),
                          const SizedBox(height: 1, width:20),
                          proQualName2 =="" ?
                          const Text('No File Selected') :
                          TextButton(
                            onPressed: () async {
                              print('start view file..');
                              String docHttpPath = await applicationViewModel.getDocumentUrl(proQualName2);
                              log(docHttpPath);
                              openImagePreviewSheet(docHttpPath);
                            },
                            child: Text('View file ...'),
                          ),
                        ]
                    ),
            ),
            const SizedBox(height: 5),
            DottedBorder(
              color: Colors.white,
              strokeWidth: 2,
              child:
                  Row(
                      children: [
                        Text("  "),
                        ElevatedButton(
                          onPressed:
                          isReadOnly ? null:
                              () async {
                            XFile? proFile3 = await applicationViewModel.getImage("pro3");
                            debugPrint(proFile3?.path);
                            if (context.mounted) {
                              confirmUploadModal(context,proFile3,"pro3");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,),
                          child: const Text("..."),
                        ),
                        const SizedBox(height: 1, width:20),
                        proQualName3 =="" ?
                        const Text('No File Selected') :
                        TextButton(
                          onPressed: () async {
                            print('start view file..');
                            String docHttpPath = await applicationViewModel.getDocumentUrl(proQualName3);
                            log(docHttpPath);
                            openImagePreviewSheet(docHttpPath);
                          },
                          child: Text('View file ...'),
                        ),
                      ]
                  ),
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
                    onPressed: () async {
                      Map<String, dynamic> param = Map();
                      param['program'] = prog;

                      if  (isReadOnly ) {
                        print('readonly app - go back page');
                        callbackNavigate("/applicationProgram",param);
                        return;
                      }
                      if (validateInput()) {
                        print(currApp);
                        print(jsonEncode(currApp.toJsonMap()));
                        currApp = await applicationViewModel.saveApplication(currApp);
                        callbackNavigate("/applicationProgram",param);
                      }

                    },
                    child: const Text('Back'),
                  )
                  ,
                ),
                Expanded(
                  child:
                  Visibility (
                    visible: !isReadOnly,
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
                          print('readonly app - go Next page');
                          callbackNavigate("/applicationIdVerify",param);
                          return;
                        }
                        if (validateInput()) {

                          print(currApp);
                          print(jsonEncode(currApp.toJsonMap()));
                          currApp.status = "SUBMITTED";
                          currApp =
                          await applicationViewModel.saveApplication(currApp);
                          await applicationViewModel.sendContractStatusUpdate("SUBMITTED", currApp.appId );
                          await Future.delayed(const Duration(milliseconds: 1000));
                          await applicationViewModel.startRequirementCheck(currApp.email, currApp.appId);
                          callbackNavigate("/applicationConfirmFragment", param);
                        }

                      },
                      child: const Text('Submit'),
                    )
                  ,
                  )
                ),
              ],
            ),

          ],
        ),


      ),
    );
  }
}
