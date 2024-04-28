import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'appDrawer.dart';


// Create a Form widget.
class ProgrammeFragment extends StatefulWidget {

  const ProgrammeFragment({super.key});

  @override
  ProgrammeFragmentState createState() {
    return ProgrammeFragmentState();
  }
}

class ProgrammeFragmentState extends State<ProgrammeFragment> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<String> programmeOptions = ['Master Degree', 'Bachelor Degree', 'Higher Diploma','Diploma','Others'];
  List<String> facultyOptions = ['Computer Science', 'Business', 'Art','Education','Others'];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Container(
        width: MediaQuery.of(context).size.width *0.9 ,
        height: MediaQuery.of(context).size.height *0.7  ,
        child:  FormBuilder(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children : <Widget> [
                  const SizedBox(height: 20),
                  FormBuilderDropdown<String>(
                    name: 'faculty',
                    decoration: InputDecoration(
                      labelText: 'faculty',
                      suffix: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _formKey.currentState!.fields['faculty']
                              ?.reset();
                        },
                      ),
                      hintText: 'Select Programme Type',
                    ),
                    items: facultyOptions
                        .map((faculty) => DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: faculty,
                      child: Text(faculty),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  FormBuilderDropdown<String>(
                    name: 'programme',
                    decoration: InputDecoration(
                      labelText: 'Programme',
                      suffix: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _formKey.currentState!.fields['programme']
                              ?.reset();
                        },
                      ),
                      hintText: 'Select Programme Type',
                    ),
                    items: programmeOptions
                        .map((programme) => DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: programme,
                      child: Text(programme),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                ]
            )

        ),
      ) ;

  }

}