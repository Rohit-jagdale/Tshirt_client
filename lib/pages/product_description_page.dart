import 'package:flutter/material.dart';
import 'package:footwear_client/controller/purchase_controller.dart';
import 'package:footwear_client/model/product/product.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProductDescriptionPage extends StatelessWidget {
  const ProductDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    print(product);
    return GetBuilder<PurchaseController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Product Detail', style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.image ?? '', // Placeholder image of the product
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.name ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.description ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Rs. ${product.price ?? ''}", // Price of the product
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: ctrl.addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Shipping Address',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, // Full width button
                  height: 50, // Button height
                  child: ElevatedButton(
                    onPressed: () {
                     ctrl.submitOrder(price: product.price ?? 0, item: product.name ?? '', description: product.description ?? '') ;// Handle buy action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
