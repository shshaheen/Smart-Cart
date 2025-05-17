import 'package:flutter/material.dart';
import 'package:smart_cart/controllers/product_controller.dart';
import 'package:smart_cart/models/product.dart';
import 'package:smart_cart/views/screens/details/screens/widgets/product_item_widget.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductController _productController = ProductController();

  List<Product> _searchResults = [];
  bool _isLoading = false;

  void _searchProducts() async {
    setState(() {
      _isLoading = true;
    });


    try {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
        });
        return;
      }
      final results = await _productController.searchProduct(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print("Error searching products: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
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
        // automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Search for products",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Handle search action here
                _searchProducts();
              },
            ),
          ),
          onChanged: (value) {
            // Handle search logic here
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_searchResults.isEmpty)
            const Center(child: Text("No products found"))
          else
            Expanded(
              child: GridView.builder(
                  itemCount: _searchResults.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final product = _searchResults[index];
                    return ProductItemWidget(product: product);
                  }),
            ),
        ],
      )
    );
  }
}