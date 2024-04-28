import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import '../viewmodel/ProfileViewModel.dart';
import '../viewmodel/UserManager.dart';
import 'appDrawer.dart';
import 'basePage.dart';


// Create a Form widget.
class ProfileFragment extends   BasePageFragment {

  ProfileFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  ProfileFragmentState createState() {
    return ProfileFragmentState();
  }
}


class ProfileFragmentState extends BasePageFramentState<ProfileFragment> {

  final _formKey = GlobalKey<FormBuilderState>();

  late ProfileViewModel profileViewModel;
  bool _ageHasError = false;
  bool _emailHasError = false;
  bool _surnameHasError =false;
  bool _givenNameHasError =false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileViewModel = Provider.of<ProfileViewModel>(context);
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    UserManager userManager = context.watch<UserManager>();
    User? user = userManager?.user;
    print('user : ' + user!.email);
    print('user : ' + (user!.surname?? "")  );


    return FutureBuilder<String>(
        future: profileViewModel.getAvatarImageUrl(),
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is loading, you can show a loading indicator
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              print("Constant ");
              // If an error occurred while fetching data, you can display an error message
            return Text('Error: ${snapshot.error}');
            } else {
              String? imageUrl = snapshot.data;

              return Center(
                child:
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: MediaQuery
                              .of(context)
                              .size
                              .width * 0.2,
                          backgroundImage: NetworkImage(
                              imageUrl!),
                          child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.white70,
                                    child: RawMaterialButton(
                                        onPressed: () {
                                          print("change photo");
                                        },
                                        elevation: 2.0,
                                        fillColor: const Color(0xFFF5F6F9),
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.blue,),
                                        shape: const CircleBorder()
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormBuilder(
                          key: _formKey,
                          child:
                          Column(
                              children: <Widget>[
                                FormBuilderTextField(
                                  name: 'email',
                                  enabled: false,
                                  initialValue: user!.email,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge,
                                    suffixIcon: _emailHasError
                                        ? const Icon(
                                        Icons.error, color: Colors.red)
                                        : const Icon(
                                        Icons.check, color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    print(
                                        val); // Print the text value write into TextField
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                                FormBuilderTextField(
                                  name: 'surname',
                                  initialValue: (user!.surname ?? ""),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Surname',
                                    labelStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge,
                                    suffixIcon: _surnameHasError
                                        ? const Icon(
                                        Icons.error, color: Colors.red)
                                        : const Icon(
                                        Icons.check, color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    print(
                                        val); // Print the text value write into TextField
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'given_name',
                                  initialValue: user!.givenName,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Given Name',
                                    labelStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge,
                                    suffixIcon: _givenNameHasError
                                        ? const Icon(
                                        Icons.error, color: Colors.red)
                                        : const Icon(
                                        Icons.check, color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    print(
                                        val); // Print the text value write into TextField
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                FormBuilderTextField(
                                  name: 'mobile',
                                  initialValue: (user!.mobile ?? "NA"),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Mobile Number',
                                    labelStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge,
                                    suffixIcon: _ageHasError
                                        ? const Icon(
                                        Icons.error, color: Colors.red)
                                        : const Icon(
                                        Icons.check, color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    print(
                                        val); // Print the text value write into TextField
                                  },
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                                const SizedBox(height: 20),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  onPressed: () {
                                    //_formKey.currentState?.saveAndValidate();
                                    if ( _formKey.currentState!.saveAndValidate()) {
                                      print('Save Profile');
                                      var formData = _formKey.currentState!.value;
                                      profileViewModel.saveProfile(formData);
                                    }
                                  },
                                  child: Text('Save'),
                                )
                              ]
                          ),
                        )

                      ]
                  ),
                ),
              );
            }
        }
    );
  }

}

