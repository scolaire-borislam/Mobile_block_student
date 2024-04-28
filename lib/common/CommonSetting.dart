import 'package:flutter_dotenv/flutter_dotenv.dart';


mixin CommonSetting {
  final publicUrl = dotenv.get('PUBLIC_URL', fallback: '');
  final appDir = dotenv.get('APP_DIR', fallback: '');
  final appIdDocDir = dotenv.get('APP_IDOC_DIR', fallback: '');
  final appPhotoDir = dotenv.get('APP_PHOTO_DIR', fallback: '');
  final appQual1Dir = dotenv.get('APP_QUAL1_DIR', fallback: '');
  final appQual2Dir = dotenv.get('APP_QUAL2_DIR', fallback: '');
  final appQual3Dir = dotenv.get('APP_QUAL3_DIR', fallback: '');
  final appPro1Dir = dotenv.get('APP_PRO1_DIR', fallback: '');
  final appPro2Dir = dotenv.get('APP_PRO2_DIR', fallback: '');
  final appPro3Dir = dotenv.get('APP_PRO3_DIR', fallback: '');


  final admissionAppListUrl = dotenv.get('ADMISSION_LIST_URL', fallback: '');
  final admissionAppUrl = dotenv.get('ADMISSION_APP_URL', fallback: '');

  final getDocUrl = dotenv.get('GET_DOC_URL', fallback: '');

  final programmeSingleUrl = dotenv.get('PROGRAMME_SINGLE_URL', fallback: '');
  final programmeUrl = dotenv.get('PROGRAMME_INFO_URL', fallback: '');
  final updateContractStatusUrl = dotenv.get('UPDATE_CONTRACT_STATUS_URL', fallback: '');
  final startReqCheckUrl = dotenv.get('START_REQ_CHECK_URL', fallback: '');
  final getParameterUrl = dotenv.get('GET_PARAMETER_URL', fallback: '');



}