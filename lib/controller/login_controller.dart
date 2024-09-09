import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

import '../model/user/user.dart';

class LoginController extends GetxController{

  GetStorage box = GetStorage();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();

  TextEditingController loginNumberCtrl = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
bool otpFieldShown = false;
int? otpSend;
int? otpEnter;

User? loginUser;

@override
  void onReady() {
    Map<String, dynamic>? user = box.read('loginUser');
    if(user != null){
      loginUser = User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }


  addUser(){
    try {
      if(otpSend == otpEnter) {
        DocumentReference doc = userCollection.doc();
        User user = User(
          id: doc.id,
          name: registerNameCtrl.text,
          number: int.parse(registerNumberCtrl.text),
        );
        final userJson = user.toJson();
        doc.set(userJson);
        Get.snackbar("success", "user added successfully", colorText: Colors.green);
        registerNameCtrl.clear();
        registerNumberCtrl.clear();
        otpController.clear();
      }else{
        Get.snackbar("error", "OTP doesn't match", colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar("error", e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  sendOtp() async {
    try {
      if (registerNumberCtrl.text.isEmpty || registerNameCtrl.text.isEmpty){
        Get.snackbar('error', 'Please fill the all fields', colorText: Colors.red);
        return; //to stop the code
      }
      final random = Random();
      int otp = 1000 + random.nextInt(9000);

      // String mobileNumber = registerNumberCtrl.text;
      // String url = 'values=$otp&&numbers=$mobileNumber';
      // Response response = await GetConnect().get(url);
// THIS IS FOR ADDING SMS GATEWAY (FAST2SMS)

      print(otp);
      Get.snackbar("success $otp", "OTP $otp", colorText: Colors.blue);
      // will send opt and check success or not
      if (otp != null){   //change if condition when sms gateway added
            otpFieldShown = true;
            otpSend = otp;
            Get.snackbar("success", "OTP sended", colorText: Colors.green);
          }else{
            Get.snackbar("error", 'OTP not send', colorText: Colors.red);
          }
    } catch (e) {
      print(e);
    }finally{
      update();
    }
  }

  Future<void> loginWithPhone() async {
    String phoneNumber = loginNumberCtrl.text;
    try {
      if(phoneNumber.isNotEmpty){
              var querySnapshot = await userCollection.where('number', isEqualTo: int.tryParse(phoneNumber)).limit(1).get();
              if (querySnapshot.docs.isNotEmpty){
                var userDoc = querySnapshot.docs.first;
                var userData = userDoc.data() as Map<String, dynamic>;
                box.write("loginUser", userData);
                loginNumberCtrl.clear();
                Get.to(HomePage());
                Get.snackbar("success", "Login Successful", colorText: Colors.green);
              }else{
                Get.snackbar("error", 'User not found please Register first!!', colorText: Colors.red);
              }
            }else{
              Get.snackbar("error", 'Enter a Number', colorText: Colors.red);
            }
    } catch (e) {
      Get.snackbar("error", e.toString(), colorText: Colors.red);
    }finally{
      update();
    }
    }



}