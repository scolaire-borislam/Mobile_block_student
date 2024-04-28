//import 'dart:html';
import 'dart:io';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class StudentCard {
  String? imageUrl;
  int? tokenId;
  String? contractAddress;
  String? hashValue;
  String? studentNo;
  String? validUntil;
  String? description;



  StudentCard({
    this.imageUrl,
    this.tokenId,
    this.contractAddress,
    this.hashValue,
    this.studentNo,
    this.validUntil,
    this.description
  });

  factory StudentCard.fromMetadata(Map<String, dynamic> json,
                {String studentNo ='',
                String validUntil ='',
                String contractAddress ='',
                String hashValue=''}) {
    return StudentCard(
        imageUrl: json['image'] as String,
        tokenId: json['tokenId'] as int,
        contractAddress: contractAddress,
        hashValue: hashValue,
        studentNo: json['studentId'] as String,
        validUntil: validUntil,
        description: json['description'] as String,
    );
  }

}