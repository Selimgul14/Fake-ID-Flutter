/*import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/view/card_reader/id_provider.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:dmrtd/dmrtd.dart';

class ReadID extends StatefulWidget {
  @override
  State<ReadID> createState() => _ReadIDState();
}

class _ReadIDState extends State<ReadID> {
  @override
  void initState() {
    isAvailable = false;
    listenerRunning = false;
    IdProvider.successResult = Future<bool>.value(false);
    IdProvider.tempResultHandel = 'test empty';
    _listenForNFCEvents();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    NfcManager.instance.stopSession();
    print('NFC stopSession');
  }

  Future<void> _listenForNFCEvents() async {
    try {
  final nfc = NfcProvider();
  await nfc.connect(iosAlertMessage: "Hold your iPhone near Passport");

  final passport = Passport(nfc);

  nfc.setIosAlertMessage("Reading EF.CardAccess ...");
  final cardAccess = await passport.readEfCardAccess();

  nfc.setIosAlertMessage("Initiating session ...");
  final bacKeySeed = DBAKeys(passportNum, dateOfBirth, dateOfExpiry);
  await passport.startSession(bacKeySeed);

  nfc.setIosAlertMessage(formatProgressMsg("Reading EF.COM ...", 0));
  final efcom = await passport.readEfCOM();

  nfc.setIosAlertMessage(formatProgressMsg("Reading Data Groups ...", 20));
  EfDG1 dg1;
  if(efcom.dgTags.contains(EfDG1.TAG)) {
    dg1 = await passport.readEfDG1();
  }

  EfDG2 dg2;
  if(efcom.dgTags.contains(EfDG2.TAG)) {
    dg2 = await passport.readEfDG2();
  }

  EfDG14 dg14;
  if(efcom.dgTags.contains(EfDG14.TAG)) {
    dg14 = await passport.readEfDG14();
  }

  EfDG15 dg15;
  Uint8List sig;
  if(efcom.dgTags.contains(EfDG15.TAG)) {
    dg15 = await passport.readEfDG15();
    nfc.setIosAlertMessage(formatProgressMsg("Doing AA ...", 60));
    sig  = await passport.activeAuthenticate(Uint8List(8));
  }

  nfc.setIosAlertMessage(formatProgressMsg("Reading EF.SOD ...", 80));
  final sod = await passport.readEfSOD();
}  
on Exception catch(e) {
  final se = e.toString().toLowerCase();
  String alertMsg = "An error has occurred while reading Passport!";
  if(e is PassportError) {
    if(se.contains("security status not satisfied")) {
      alertMsg = "Failed to initiate session with passport.\nCheck input data!";
    }
  }

  if(se.contains('timeout')){
    alertMsg = "Timeout while waiting for Passport tag";
  }
  else if(se.contains("tag was lost")){
    alertMsg = "Tag was lost. Please try again!";
  }
  else if(se.contains("invalidated by user")){
    alertMsg = "";
  }
  errorAlertMsg = alertMsg;
}
finally {
  if(errorAlertMsg?.isNotEmpty){
    await _nfc.disconnect(iosErrorMessage: errorAlertMsg);
    if(!Platform.isIOS) {
      // Show error to the user
    }
  }
  else {
    await _nfc.disconnect(iosAlertMessage: formatProgressMsg("Finished", 100);
  }
}

    /*print('_listenForNFCEvents');
    //Always run this for ios but only once for android
    if (Platform.isAndroid && listenerRunning == false || Platform.isIOS) {
      //Android supports reading nfc in the background, starting it one time is all we need
      if (Platform.isAndroid) {
        print('NFC listener running in background now, approach tag(s)');
        //Update button states
        setState(() {
          listenerRunning = true;
        });
      }

      debugPrint('NFC Start');
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          bool succses = false;
          //Try to convert the raw tag data to NDEF
          final ndefTag = Ndef.from(tag);
          //If the data could be converted we will get an object
          if (ndefTag != null) {
            //The NDEF Message was already parsed, if any
            if (ndefTag.cachedMessage != null) {
              var ndefMessage = ndefTag.cachedMessage!;
              //Each NDEF message can have multiple records, we will use the first one in our example
              if (ndefMessage.records.isNotEmpty &&
                  ndefMessage.records.first.typeNameFormat ==
                      NdefTypeNameFormat.nfcWellknown) {
                //If the first record exists as 1:Well-Known we consider this tag as having a value for us
                final wellKnownRecord = ndefMessage.records.first;

                ///Payload for a 1:Well Known text has the following format:
                ///[Encoding flag 0x02 is UTF8][ISO language code like en][content]
                if (wellKnownRecord.payload.first == 0x02) {
                  //Now we know the encoding is UTF8 and we can skip the first byte
                  final languageCodeAndContentBytes =
                      wellKnownRecord.payload.skip(1).toList();
                  //Note that the language code can be encoded in ASCI, if you need it be carfully with the endoding
                  final languageCodeAndContentText =
                      utf8.decode(languageCodeAndContentBytes);
                  print('languageCodeAndContentText');
                  print(languageCodeAndContentText);
                  //Cutting of the language code
                  final payload = languageCodeAndContentText.substring(2);
                  print('payload');
                  print(payload);
                  //Parsing the content to int
                  //final storedCounters = int.tryParse(payload);
                  final storedCounters = payload;
                  if (storedCounters != null) {
                    succses = true;
                    print('Data restored from tag');
                    setState(() {
                      IdProvider.tempResultHandel = storedCounters;
                      IdProvider.successResult = Future<bool>.value(true);
                    });
                  }
                }
              }
            }
          }
          //Due to the way ios handles nfc we need to stop after each tag
          if (Platform.isIOS) {
            NfcManager.instance.stopSession();
            print('nfc stopSession');
          }
          if (succses == false) {
            print('Tag was not valid');
          }
        },
        // Required for iOS to define what type of tags should be noticed
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
      );
    }*/
  }

  bool isAvailable = false;
  bool listenerRunning = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    void _tagRead() {
      debugPrint('NFC Start');
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        IdProvider.tempResultData = tag.data;
        IdProvider.tempResultHandel = tag.handle;

        //////////////////////////
        print('tag.data');
        print(tag.data);
        print('tag.handle');
        print(tag.handle);
        print(tag.runtimeType);
        ////////////////////////

        NfcManager.instance.stopSession();
        debugPrint('NFC Stop');
        setState(() {
          IdProvider.successResult = Future<bool>.value(true);
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.yellow[350],
      appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            "Read NFC ID",
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.amber,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back))),
      body: FutureBuilder<bool>(
        future: IdProvider.successResult,
        builder: (context, ss) => ss.data != true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome in Read NFC ID',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.only(top: height * 0.1)),
                    Padding(
                      padding: EdgeInsets.all(width * 0.05),
                      child: Text(
                        'NFC is now activated, please swipe the ID to read the information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: width * 0.05,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ReadID(),
      ),
    );
  }
}
*/