import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mobile_block_student_adm/model/studentCard.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import '../model/promramme.dart';
import '../viewmodel/WalletViewModel.dart';
import 'appDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:developer';
import 'basePage.dart';
import 'homepage.dart';
import 'package:carousel_slider/carousel_slider.dart';

//https://www.waldo.com/blog/flutter-card
// Create a Form widget.
class Walletragment extends BasePageFragment {
  Walletragment({super.key, required callbackNavigate})
      : super(callbackNavigate: callbackNavigate);

  @override
  WalletragmentFragmentState createState() {
    return WalletragmentFragmentState();
  }
}

class WalletragmentFragmentState extends BasePageFramentState<Walletragment> {
  late WalletViewModel walletViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    walletViewModel = Provider.of<WalletViewModel>(context);
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Function(String, Map<String, dynamic>) callbackNavigate =
        widget.callbackNavigate;
    final parentState = context.findAncestorStateOfType<MyHomePageState>();
    walletViewModel.getStudentCardList();

    // Map<String, dynamic>? param =parentState?.argumentMap;
    // Programme prog = param?["program"] ;
    // debugPrint(prog.progDesc);
    // const List<String> genderOptions = <String>['Male', 'Female'];
    // const List<String> modeOfStudy = <String>['Full-Time', 'Part-time'];
    //https://medium.com/podiihq/generating-qr-code-in-a-flutter-app-50de15e39830
    return FutureBuilder<void>(
        future: walletViewModel.getOwnedTokens(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading, you can show a loading indicator
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print("Error ");
            // If an error occurred while fetching data, you can display an error message
            return Text('Error: ${snapshot.error}');
          } else {
            //List<Programme>? programs = snapshot.data;
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.97,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text("Student Cards Wallet",
                        style: TextStyle(fontSize: 25, color: Colors.purple)),
                    const SizedBox(height: 40),
                    Visibility(
                        visible: walletViewModel.currCardList.length <1,
                        child:
                        const Text("No student card in your wallet",
                            style: TextStyle(fontSize: 20, color: Colors.yellow)),

                    ),
                    CarouselSlider(
                      items: walletViewModel.currCardList.map((studentCard) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child:
                                SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      // Image.network(
                                      //     studentCard.imageUrl ?? "",
                                      //     //fit: BoxFit.cover,
                                      // ),
                                      CachedNetworkImage(
                                        progressIndicatorBuilder: (context, url, progress) => Center(
                                          child: CircularProgressIndicator(
                                            value: progress.progress,
                                          ),
                                        ),
                                        imageUrl: studentCard.imageUrl ?? "" ,

                                      ),
                                      const SizedBox(height: 25),
                                      Row(children: [
                                        const Expanded(
                                            child: Text(
                                          'Student Number : ',
                                          style: TextStyle(fontSize: 16),
                                        )),
                                        Expanded(
                                            child: Text(
                                          studentCard.studentNo ?? '',
                                          style: const TextStyle(fontSize: 16),
                                        )),
                                      ]),
                                      const SizedBox(height: 10),
                                      Row(children: [
                                        const Expanded(
                                            child: Text(
                                          'Valid Until : ',
                                          style: TextStyle(fontSize: 16),
                                        )),
                                        Expanded(
                                            child: Text(
                                          studentCard.validUntil ?? '',
                                          style: TextStyle(fontSize: 16),
                                        )),
                                      ]),
                                      const SizedBox(height: 25),
                                      Container(
                                          child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          backgroundColor: Colors.white,
                                          side: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onPressed: () {
                                          print('Show QR code');
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 500,
                                                color: Colors.white,
                                                child: Center(
                                                  child: QrImageView(
                                                    data: studentCard.studentNo ??
                                                        '',
                                                    version: QrVersions.auto,
                                                    size: 320,
                                                    gapless: false,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('Show QR code'),
                                      )),
                                    ],
                                  ),
                                )
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 400,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: false,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          }
        });
  }
}
