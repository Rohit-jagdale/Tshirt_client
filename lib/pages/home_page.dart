import 'package:flutter/material.dart';
import 'package:footwear_client/controller/home_controller.dart';
import 'package:footwear_client/model/product/product.dart';
import 'package:footwear_client/pages/login_page.dart';
import 'package:footwear_client/pages/product_description_page.dart';
import 'package:footwear_client/widgets/drop_down_btn.dart';
import 'package:footwear_client/widgets/multi_select_drop_down.dart';
import 'package:footwear_client/widgets/product_card.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: ()async{
          ctrl.fetchProducts();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "T-shirts",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      GetStorage box = GetStorage();
                      box.erase();
                      Get.offAll(LoginPage());
                    },
                    icon: Icon(Icons.logout))
              ],
            ),
            body: Column(children: [
              SizedBox(
                height: 50,
                child: Row(children: [
                  InkWell(
                    onTap: () {
                      ctrl.clearCategoryFilter();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Chip(
                        label: Text('All'),
                      ),
                    ),
                  ),
                  // Category List
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: ctrl.productCategories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              ctrl.filterByCategory(
                                  ctrl.productCategories[index].name ?? '');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Chip(
                                  label: Text(
                                      ctrl.productCategories[index].name ??
                                          'error')),
                            ),
                          );
                        }),
                  ),
                ]),
              ),
              Row(
                children: [
                  Flexible(
                    child: DropDownBtn(
                      items: [ "Rs. Low to High", "Rs. High to Low"],
                      selectedItemText: "sort",
                      onSelected: (selected) {
                        ctrl.sortByPrice(ascending: selected == "Rs. Low to High" ? true : false );
                        print(selected);
                      },
                    ),
                  ),
                  Flexible(
                      child: MultiSelectDropDown(
                        selectedItemText: "Brand",
                        items: ['Nike', 'Adidas', 'Puma'],
                        onSelectionChanged: (selectedItems) {
                          print(selectedItems);
                          ctrl.filterByBrands(selectedItems);
                        },
                      )),
                ],
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    itemCount: ctrl.productShowInUi.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.productShowInUi[index].name ?? 'no name',
                        imageUrl: ctrl.productShowInUi[index].image ?? 'no name',
                        price: ctrl.productShowInUi[index].price ?? 0,
                        offerTag: '30% off',
                        onTap: () {
                          Get.to(ProductDescriptionPage(), arguments: {'data': ctrl.productShowInUi[index]});
                        },
                      );
                    }),
              )
            ])),
      );
    });
  }
}
