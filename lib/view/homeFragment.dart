import 'package:flutter/material.dart';
import 'package:mobile_block_student_adm/model/promramme.dart';

import 'package:mobile_block_student_adm/viewmodel/HomeViewModel.dart';
import 'package:provider/provider.dart';
import 'appDrawer.dart';
import 'basePage.dart';

// Create a Form widget.
class HomeFragment extends  BasePageFragment {

  HomeFragment({super.key, required callbackNavigate}) : super(callbackNavigate: callbackNavigate) ;

  @override
  HomeFragmentState createState() {
    return HomeFragmentState();
  }
}

class HomeFragmentState extends  BasePageFramentState<HomeFragment> {
//class HomeFragment extends StatelessWidget {

  late HomeViewModel homeViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    homeViewModel = Provider.of<HomeViewModel>(context);
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String? userEmail = homeViewModel.userManager?.user?.email ?? '';
    String? givenName = homeViewModel.userManager?.user?.givenName ?? '';
    String? name = homeViewModel.userManager?.user?.surname ?? '';
    Function(String, Map<String, dynamic>) callbackNavigate = widget.callbackNavigate;

    bool validSession = homeViewModel.userManager.checkValidSession();
    return FutureBuilder<List<Programme>>(
      future: homeViewModel.getFeaturedProgramList(programmeUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is loading, you can show a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print("Constant ");
          // If an error occurred while fetching data, you can display an error message
          return Text('Error: ${snapshot.error}');
        } else {
            List<Programme>? programs = snapshot.data;
            // If the data was successfully fetched, you can use it in your UI
            return
              Center(
                child:
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  child: Column(
                      children: <Widget>[
                        //Text("Home Fragment 1 ${userEmail!} ${name!} ${givenName!}"),
                        const Text('Top Programme for you', style: TextStyle(fontSize: 30, color: Colors.white),),
                        const SizedBox(height: 5),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: programs!.length, // your List
                          itemBuilder: (context, index) {
                            return
                              Card(
                                color: Colors.brown,
                                child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(programs![index].progName),
                                        subtitle: Text(programs![index].progProvider),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print('press!!' + programs![index].progCode);
                                          Map<String, dynamic> param = { 'program': programs![index] };
                                          callbackNavigate("/programmeDetail",param);
                                          },
                                        child: Image.network(
                                          (programs[index].img1 ) as String,
                                         // width: 200,

                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ]
                                )
                            );
                          },
                        ),






                      ]
                  ),
                ),
              );


        }
      },
    );


    return  Center(
      child:  Text("Home Fragment 1 ${userEmail!} ${name!} ${givenName!}"),
    );
  }

}