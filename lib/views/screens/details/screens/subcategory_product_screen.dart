import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cart/controllers/product_controller.dart';
import 'package:smart_cart/models/subcategory.dart';
import 'package:smart_cart/providers/subcategory_product_provider.dart';
import 'package:smart_cart/views/screens/details/screens/widgets/product_item_widget.dart';


class SubcategoryProductScreen extends ConsumerStatefulWidget {
  final Subcategory subcategory;

  const SubcategoryProductScreen({super.key, required this.subcategory});

  @override
  ConsumerState<SubcategoryProductScreen> createState() =>
      _SubcategoryProductScreenState();
}

class _SubcategoryProductScreenState
    extends ConsumerState<SubcategoryProductScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // final products = ref.read(subcategoryProductProvider);
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController
          .loadProductsBySubcategory(widget.subcategory.subCategoryName);
      ref.read(subcategoryProductProvider.notifier).setProducts(products);
    } catch (e) {
      print("$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(subcategoryProductProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    //set the number of columns in grid base on the screen width
    //if the screen with is less than 600 pixels(e.g.. a phone), use 2 columns
    //if the screen is 600 pixels are more (e.g .. a table ),use 4 column
    final crossAxisCount = screenWidth < 600 ? 2 : 4;

    //set the aspect ratio(width-to-heigth ratio) of each grid item base on the screen width

    //for smaller screen(<600 pixels) use a ration of 3.4(taller items)

    //for larger screen(>=600 pixels), use a ratio of 4.5(more square-shaped items)

    final childAspectRatio = screenWidth < 600 ? 3 / 4 : 4 / 5;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subcategory.subCategoryName,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(6.0),
              child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductItemWidget(product: product);
                  }),
            ),
    );
  }
}