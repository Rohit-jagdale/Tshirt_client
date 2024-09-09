import 'package:flutter/material.dart';
import 'package:footwear_client/controller/login_controller.dart';
import 'package:footwear_client/pages/login_page.dart';
import 'package:footwear_client/widgets/otp_txt_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: ctrl.registerNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: ctrl.registerNumberCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                OtpTxtField(
                  otpController:ctrl.otpController,
                  visible: ctrl.otpFieldShown,
                  onComplete: (otp) {
                    ctrl.otpEnter = int.tryParse(otp ?? '0000');
                  },),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (ctrl.otpFieldShown){
                      ctrl.addUser();
                    }else {
                      ctrl.sendOtp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Background color
                    backgroundColor: Colors.indigoAccent, // Text color
                  ),
                  child: Text(ctrl.otpFieldShown ? 'Register' : 'Send OTP'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                  Get.to(const LoginPage());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.indigoAccent, // Text color
                  ),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
