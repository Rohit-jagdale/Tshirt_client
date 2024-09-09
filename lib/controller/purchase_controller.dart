import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/controller/login_controller.dart';
import 'package:footwear_client/model/order/orderr.dart';
import 'package:footwear_client/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/user/user.dart';

class PurchaseController extends GetxController{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  List<Orderr> orders =[];


  TextEditingController addressController = TextEditingController();


  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';


  @override
  void onInit() {
   orderCollection = firestore.collection('orders');
    super.onInit();
  }

  submitOrder({
  required double price,
    required String item,
    required String description,
  }){
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    // print('$orderPrice');
    // print('$itemName');
    // print('$orderAddress');

   Razorpay razorpay = Razorpay();
    var options = {
      'key': '<YOUR_KEY_HERE>',
      'amount': price * 100 , // 10 = 10.00
      'name': item,
      'description': description,
    };

    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // razorpay.open(options);
    // when payment gateway is added uncomment this above 3 lines and comment below line

    orderSuccess(transactionId: 'testTransactionId');
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId: response.paymentId);
  Get.snackbar("Success", 'payment is successfully Complete', colorText: Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Fail", '${response.message}', colorText: Colors.green);
  }



  // Future<void> orderSuccess({required String? transactionId}) async {
  //   User? loginUser = Get.find<LoginController>().loginUser;
  //   try {
  //     if (transactionId != null){
  //           DocumentReference docRef = await orderCollection.add({
  //             'customer': loginUser?.name ?? '',
  //             'phone' : loginUser?.number ?? '',
  //             'item' : itemName,
  //             'price' : orderPrice,
  //             'address' : orderAddress,
  //             'transactionId' : transactionId,
  //             'dateTime' : DateTime.now().toString(),
  //           });
  //           print("Order create Successfully: ${docRef.id}");
  //           showOrderSuccessDailog(docRef.id);
  //           Get.snackbar("Success", "Order Create Successfully", colorText: Colors.green);
  //           addressController.clear();
  //         }else{
  //           Get.snackbar("Error", 'Please fill All fields', colorText: Colors.red);
  //         }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString(), colorText: Colors.red);
  //     print(e);
  //   }
  // }

  addOrder({required String? transactionId}){
    User? loginUser = Get.find<LoginController>().loginUser;
    try {
      DocumentReference doc =  orderCollection.doc();
      Orderr order = Orderr(
        id: doc.id,
        customer: loginUser?.name,
        phone: double.tryParse(loginUser!.number.toString()),
        item: itemName,
        price: orderPrice,
        address: orderAddress,
        transactionId: transactionId,
        dateTime: DateTime.now().toString()
      );
      final orderJson = order.toJson();
      doc.set(orderJson);
      Get.snackbar("success", "order added successfully", colorText: Colors.green);
      orders.add(order);
    } catch (e) {
      Get.snackbar("error", e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  Future<void> orderSuccess({required String? transactionId}) async {
    // User? loginUser = Get.find<LoginController>().loginUser;
    try {
      if (transactionId != null){
            addOrder(transactionId: transactionId);
            addressController.clear();
          }else{
            Get.snackbar("Error", 'Please fill All fields', colorText: Colors.red);
          }
    } catch (e) {
      Get.snackbar("Error", e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  void showOrderSuccessDailog(String orderId){
    Get.defaultDialog(
      title: "Order Success",
      content :  Text("Your Order is $orderId"),
      confirm: ElevatedButton(
          onPressed: (){
            Get.off(const HomePage());
          },
          child: const Text("Close")
      )
    );
  }
}