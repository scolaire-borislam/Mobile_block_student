import 'dart:convert';
import 'dart:developer';
import 'package:mobile_block_student_adm/common/CommonSetting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_block_student_adm/model/promramme.dart';
import 'package:mobile_block_student_adm/view/basePage.dart';
import 'package:mobile_block_student_adm/viewmodel/UserManager.dart';
import 'package:path/path.dart' as p;

import '../model/application.dart';

class ApplicationViewModel with ChangeNotifier, CommonSetting {
      late Application _currApplication;
      late List<Application> _currAppList;

      Application get currApplication => _currApplication;
      List<Application>  get currAppList => _currAppList;

      set currApplication(Application value) {
        _currApplication = value;
        notifyListeners();
      }

      set currAppList(List<Application>  value) {
        _currAppList = value;
        notifyListeners();
      }

      late UserManager _userManager;
      //late List<Programme> featuredProgramList;

      UserManager get userManager => _userManager;


      set userManager(UserManager value) {
        _userManager = value;
        notifyListeners();
      }

      ApplicationViewModel(BuildContext context) {
        //_userManager = Provider.of<UserManager>(context);
      }


      void startApplication() {
        _currApplication = Application(
            uid: userManager!.user!.uid ?? "",
            surname: userManager!.user!.surname ?? "",
            givenName: userManager.user!.givenName ?? "",
            idDocNo: "", gender: "",
            dob: DateTime.now(),
            email: userManager.user!.email,
            mobileContact: userManager.user!.mobile ?? "",
            contractAddress: "",
            SEN: false, progCode: "", progName: "",
            progProvider: "",
            modeOfStudy: "", entryYear: "2024");
        notifyListeners();
      }

      final ImagePicker _picker = ImagePicker();

      Future <XFile?> getImage(String imageType) async {
        debugPrint('pick image file 1');
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        switch(imageType) {
          case "idDoc" :
            currApplication!.idDocPath = image?.name;
            break; // The switch statement must be told to exit, or it will execute every case.
          case "photoDoc":
            currApplication!.photoPath = image?.name;
            break;
          case "quali1":
            currApplication!.educationQualification1 = image?.name;
            break;
          case "quali2":
            currApplication!.educationQualification2 = image?.name;
            break;
          case "quali3":
            currApplication!.educationQualification3 = image?.name;
            break;
          case "pro1":
            currApplication!.professionalQualification1 = image?.name;
            break;
          case "pro2":
            currApplication!.professionalQualification2 = image?.name;
            break;
          case "pro3":
            currApplication!.professionalQualification3 = image?.name;
            break;
          default:
            print('choose a different type!');
        }
        debugPrint('pick image file 2');
        notifyListeners();
        return image;
      }



      Future<String> uploadDocument( XFile? file, String fileType) async {
        String? uploadPath ;
        String? loginId = userManager.user?.email;
        String? uploadUrl;
        String imagePath =file!.path;
        final extension = p.extension(imagePath); // '.dart'
        log(extension);
        String? appId = currApplication.appId;
        print(appId);
        switch(fileType) {
          case "idDoc" :
            uploadPath= '$appDir/${loginId!}/$appId/$appIdDocDir/idDoc$extension';
            break; // The switch statement must be told to exit, or it will execute every case.
          case "photoDoc":
            uploadPath= '$appDir/${loginId!}/$appId/$appPhotoDir/photoDoc$extension';
            break;
          case "quali1":
            uploadPath= '$appDir/${loginId!}/$appId/$appQual1Dir/quali1$extension';
            break;
          case "quali2":
            uploadPath= '$appDir/${loginId!}/$appId/$appQual2Dir/quali2$extension';
            break;
          case "quali3":
            uploadPath= '$appDir/${loginId!}/$appId/$appQual3Dir/quali3$extension';
            break;
          case "pro1":
            uploadPath= '$appDir/${loginId!}/$appId/$appPro1Dir/pro1$extension';
            break;
          case "pro2":
            uploadPath= '$appDir/${loginId!}/$appId/$appPro2Dir/pro2$extension';
            break;
          case "pro3":
            uploadPath= '$appDir/${loginId!}/$appId/$appPro3Dir/pro3$extension';
            break;
          default:
            print('choose a different type!');
            throw Exception('Wrong File Type');
        }
        Map data = {
          'documentKey': uploadPath,
          "actionType":"put_object"
        };
        final response = await http.post(
          Uri.parse(getDocUrl),
          headers: <String, String>{
            'content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );
        if (kDebugMode) {
          print(response.statusCode );
        }
        log(response.body);

        // upload to presigned url
        if (response.statusCode == 200) {
          log(response.body);
          uploadUrl= response.body;
          final resUp = await http.put(
            Uri.parse(uploadUrl),
            body: await file?.readAsBytes(),
          );
          if (resUp.statusCode == 200) {
            log(resUp.body);
            log(uploadPath);
            switch(fileType) {
              case "idDoc" :
                currApplication.idDocPath =  uploadPath;
                break; // The switch statement must be told to exit, or it will execute every case.
              case "photoDoc":
                currApplication.photoPath =  uploadPath;
                break;
              case "quali1":
                currApplication.educationQualification1 =  uploadPath;
                break;
              case "quali2":
                currApplication.educationQualification2 =  uploadPath;
                break;
              case "quali3":
                currApplication.educationQualification3 =  uploadPath;
                break;
              case "pro1":
                currApplication.professionalQualification1 =  uploadPath;
                break;
              case "pro2":
                currApplication.professionalQualification2 =  uploadPath;
                break;
              case "pro3":
                currApplication.professionalQualification3 =  uploadPath;
                break;
              default:
                print('choose a different type!');
                throw Exception('Wrong File Type');
            }
            notifyListeners();

            return uploadPath;
          } else {
            throw Exception('Failed to upload Document image file. :${resUp.statusCode}');
          }
        } else {
          throw Exception('Failed upload Document :${response.statusCode}');
        }


      }

      Future<String> getDocumentUrl(String docPath) async {
        try {
          log(docPath);
          Map data = {
            'documentKey': docPath,
            "actionType":"get_object"
          };
          final response = await http.post(
            Uri.parse(getDocUrl),
            headers: <String, String>{
              'content-Type': 'application/json',
            },
            body: jsonEncode(data),
          );
          print(response.statusCode );
          if (response.statusCode == 200) {
            log(response.body);
            String imageUrl= response.body;
            notifyListeners();
            return imageUrl;
          } else {
            throw Exception('Failed retrieve document :${response.statusCode}');
          }
        } catch (e) {
          log(e.toString());
          throw Exception('Failed retrieve document url');
        }
      }


      Future<Application>  saveApplication(Application app)  async {
        try {
          Map<String, dynamic>  jsonMap =app.toJsonMap();
          Map data = {
            'item': jsonMap,
          };
          final response = await http.post(
            Uri.parse(admissionAppUrl),
            headers: <String, String>{
              'content-Type': 'application/json',
            },
            body: jsonEncode(data),
          );
          if (response.statusCode == 200) {
            final Map<String, dynamic> resdata = json.decode(response.body);
            if (resdata.containsKey('item')) {
              Map<String, dynamic> itemMap = resdata['item'];
              print(itemMap);
              log("Save successfully!");
              Application updatedItem = Application.fromJson(itemMap);
              _currApplication = updatedItem;
              notifyListeners();
              return updatedItem;
            } else {
              throw Exception('Field "item" not found in response.');
            }
          } else {
            throw Exception('Failed to fetch data: ${response.statusCode}');
          }


        } catch (e) {
          // debugPrintStack();
          print(e);
          log(e.toString());
          throw Exception('Failed in update application');
        }

      }


      Future<void>  sendContractStatusUpdate(String status, String? appNo)  async {
        try {
          //Map<String, dynamic>  jsonMap =app.toJsonMap();
          Map data = {
            'status': status,
            'app_id': appNo,
          };
          final response = await http.post(
            Uri.parse(updateContractStatusUrl),
            headers: <String, String>{
              'content-Type': 'application/json',
            },
            body: jsonEncode(data),
          );
          if (response.statusCode == 200) {
            log("send sqs message for smart contract update") ;
          } else {
            throw Exception('Failed to send status update message: ${response.statusCode}');
          }

        } catch (e) {
          // debugPrintStack();
          print(e);
          throw Exception('Failed in send update message');
        }
      }


      Future<void>  startRequirementCheck(String? email, String? appNo)  async {
        try {
          Map data = {
            'email': email,
            'app_id': appNo,
          };
          final response = await http.post(
            Uri.parse(startReqCheckUrl),
            headers: <String, String>{
              'content-Type': 'application/json',
            },
            body: jsonEncode(data),
          );
          if (response.statusCode == 200) {
            log("Invoke API to start smart contract successfully") ;
          } else {
            throw Exception('Failed to Invoke API to start smart contract: ${response.statusCode}');
          }

        } catch (e) {
          // debugPrintStack();
          print(e);
          throw Exception('Failed to Invoke API to start smart contract');
        }
      }

      void getApplication(String appNo) {

      }

      Future<Programme> getProgramme(String progCode, String progProvider) async {
        try {
          String url = '$programmeSingleUrl?prog_code=${progCode}&prog_provider=${progProvider}';
          url = Uri.encodeFull(url);
          final response = await http.get(
            Uri.parse(url),
          );
          if (response.statusCode == 200) {
            Map<String, dynamic> resdata = json.decode(response.body);
            Programme programme = Programme.fromJson(resdata);
            return programme;
          } else {
            throw Exception('Failed to fetch programme: ${response.statusCode}');
          }
        } catch (e) {
          log("",error: e );
          throw Exception('Failed retrieve a single programme');
        }

      }

      Future<void> getApplicationList() async {

        try {
          var url = '$admissionAppListUrl?email=${userManager.user!.email}';
          print(url);
          final response = await http.get(
            Uri.parse(url),
          );

          if (response.statusCode == 200) {
            //final Map<String, dynamic> resdata = json.decode(response.body);
            List<dynamic> resdata = json.decode(response.body);
            List<Application> applications = [];
            for (var item in resdata) {
              Application application = Application.fromJson(item);
              applications.add(application);
            }
            _currAppList = applications;
            //return applications;

          } else {
            throw Exception('Failed to fetch data: ${response.statusCode}');
          }


            // Application app1 = Application(surname: 'LAM', givenName: 'Boris',
            //     idDocNo: 'H123', gender: 'mail', dob: DateFormat('yyyy-mm-dd').parse('2000-12-12'), email: 'aws4.boris@gmail.com',
            //     mobileContact: '91234562', contractAddress: 'FLAT 123, BLK D, HK', SEN: true, progCode: '20240101_UWL_CS_CYB_SEC', progName: 'BSc (Hons) Cyber Security',
            //     progProvider: 'University of West London', modeOfStudy: 'full-time', entryYear: '2024', status :'REJECTED');
            //
            // Application app2 = Application(surname: 'LAM', givenName: 'Boris',
            //     idDocNo: 'H123', gender: 'mail', dob: DateFormat('yyyy-mm-dd').parse('2000-12-12'), email: 'aws4.boris@gmail.com',
            //     mobileContact: '91234562', contractAddress: 'FLAT 123, BLK D, HK', SEN: true, progCode: '20240102_UWL_BS_BBA', progName: 'BA (Hons) Business Studies',
            //     progProvider: 'University of West London', modeOfStudy: 'part-time', entryYear: '2024', status :'PENDING APPROVAL');
            //
            // // Parse the string as JSON using the jsonDecode function
            // List<Application> appList =  [];
            // appList.add(app1);
            // appList.add(app2);
            // _currAppList = appList;



        } catch (e) {
          log("",error: e );
          throw Exception('Failed retrieve application list');
        }
      }


}
