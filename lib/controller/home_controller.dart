import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/model/product_category/product_category.dart';
import 'package:get/get.dart';

import '../model/product/product.dart';

class HomeController extends GetxController{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products =[];
  List<Product> productShowInUi =[];
  List<ProductCategory> productCategories = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection("products");
    categoryCollection = firestore.collection("category");
    await fetchCategory();
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs.map((doc) =>
          Product.fromJson(doc.data() as Map<String, dynamic>)).toList();
      products.clear();
      products.assignAll(retrievedProducts);
      productShowInUi.assignAll(products);
      Get.snackbar('success', 'product fetch successfully', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('success', e.toString(), colorText: Colors.red);
      print(e);
    }
    finally {
      update();
    }
  }

  fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrievedProductCategories = categorySnapshot.docs.map((doc) =>
          ProductCategory.fromJson(doc.data() as Map<String, dynamic>)).toList();
      productCategories.clear();
      productCategories.assignAll(retrievedProductCategories);
      // Get.snackbar('success', 'category fetch successfully', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('error', e.toString(), colorText: Colors.red);
      print(e);
    }
    finally {
      update();
    }
  }

  filterByCategory(String category){
    productShowInUi.clear();
    productShowInUi = products.where((product) => product.category == category).toList();
    update();
  }

  clearCategoryFilter(){
    productShowInUi = products.toList();
    update();
  }

  void filterByBrands(List<String> brands) {
    if (brands.isEmpty) {
      productShowInUi = products;
    } else {
     List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase()).toList();
     productShowInUi = products.where((product) {
       return product.brand != null && lowerCaseBrands.contains(product.brand!.toLowerCase());
     }).toList();
    }
    update();  // Notify the UI to update
  }

  sortByPrice({required bool ascending}){
    List<Product> sortedProducts = List<Product>.from(productShowInUi);
    sortedProducts.sort((a,b) => ascending ? a.price!.compareTo(b.price!) : b.price!.compareTo(a.price!));
    productShowInUi = sortedProducts;
    update();
  }


}