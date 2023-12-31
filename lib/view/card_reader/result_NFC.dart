import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:mobile/view/card_reader/id_provider.dart';

class ResultNFC extends StatefulWidget {
  static String rout = '/resultUEAIDScreen';


  ///////////////////////
  final Map<String,dynamic> tempData ;
  final String tempHandel ;

  ResultNFC(this.tempData, this.tempHandel);

  @override
  State<StatefulWidget> createState() {
    return _ResultNFCState();
  }
}

class _ResultNFCState extends State<ResultNFC> {
  String fullName = 'Please re-scan more clearly';
  String docNumber = 'Please re-scan more clearly';
  String sex = 'Please re-scan more clearly';
  String nationality = 'Please re-scan more clearly';
  String birth = 'Please re-scan more clearly';
  String age = 'Please re-scan more clearly';
  String expiry = 'Please re-scan more clearly';
  String expiryPermanent = 'Please re-scan more clearly';
  String idNumber = 'Please re-scan more clearly';
  String idText = 'Please re-scan more clearly';

  ///////////////////////
  Map<String,dynamic> _testData = {
    "Last name"  :'t',
    "Full name"  :'t',
    "Document number" : 't',
    "Sex":'t',
    "Nationality":'t',
    "Date of birth":'t',
    "Age":'t',
    "Date of expiry":'t',
    "Date of expiry permanent":'t',
    "Personal Id Number":'t',
    "Text":'t'
  };
  String _testHandel='t' ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splitResult();
  }

  void splitResult() {
    fullName = IdProvider.resultString!['Full name'];
    docNumber = IdProvider.resultString!['Document number'];
    sex = IdProvider.resultString!['Sex'];
    nationality = IdProvider.resultString!['Nationality'];
    birth = IdProvider.resultString!['Date of birth'];
    age = IdProvider.resultString!['Age'];
    expiry = IdProvider.resultString!['Date of expiry'];
    expiryPermanent = IdProvider.resultString!['Date of expiry permanent'];
    idNumber = IdProvider.resultString!['Personal Id Number'];
    idText = IdProvider.resultString!['Text'];
    _testData = widget.tempData;
    _testHandel = widget.tempHandel;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextStyle infoTextStyle =
    TextStyle(color: Colors.black45, fontSize: width * 0.03);
    TextStyle infoTitleStyle = TextStyle(
        color: Colors.black45,
        fontSize: width * 0.04,
        fontWeight: FontWeight.bold);
    var paddingInfo = height * 0.01;

    Widget fullDocumentFrontImage = Container();
    if (IdProvider.fullDocumentFrontImageBase64 != null &&
        IdProvider.fullDocumentFrontImageBase64 != "") {
      fullDocumentFrontImage = Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.white70,
          child: Container(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Document Front Image:",
                      style: infoTitleStyle,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: paddingInfo)),
                Image.memory(
                  const Base64Decoder()
                      .convert(IdProvider.fullDocumentFrontImageBase64!),
                )
              ],
            ),
          ));
    }
    //This widget will show the user image obtained from the passport or national id
    Widget faceImage = Container();
    if (IdProvider.faceImageBase64 != null &&
        IdProvider.faceImageBase64 != "") {
      faceImage = Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.white70,
          child: Container(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Face Image:",
                      style: infoTitleStyle,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: paddingInfo)),
                Image.memory(
                  const Base64Decoder().convert(IdProvider.faceImageBase64!),
                )
              ],
            ),
          ));
    }

    Widget signatureImage = Container();
    if (IdProvider.signatureImageBase64 != null &&
        IdProvider.signatureImageBase64 != "") {
      signatureImage = Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.white70,
          child: Container(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Signature Image:",
                      style: infoTitleStyle,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: paddingInfo)),
                Image.memory(
                  const Base64Decoder()
                      .convert(IdProvider.signatureImageBase64!),
                )
              ],
            ),
          ));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 50,
            shadowColor: Colors.black,
            color: Colors.white70,
            child: Container(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*Text(
                    'data : ',
                    style: infoTitleStyle,
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Text(
                    _testData.toString(),
                    style: infoTextStyle,
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo*2)),
*/
                  Text(
                    'handel data : ',
                    style: infoTitleStyle,
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Text(
                    _testHandel,
                    style: infoTextStyle,
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo*2)),

                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: paddingInfo * 2)),

        ],
      ),
    );
  }
}