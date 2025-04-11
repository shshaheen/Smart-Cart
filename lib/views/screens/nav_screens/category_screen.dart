import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_cart/controllers/category_controller.dart';
import 'package:smart_cart/controllers/subcategory_controller.dart';
import 'package:smart_cart/models/category.dart';
import 'package:smart_cart/models/subcategory.dart';
import 'package:smart_cart/views/screens/details/screens/widgets/subcategory_tile_widget.dart';
// import 'package:smart_cart/views/screens/nav_screens/widgets/category_item_widget.dart';
import 'package:smart_cart/views/screens/nav_screens/widgets/header_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // A future that will hold the list of categories once loaded from the API

  late Future<List<Category>> futureCategories;
  Category? _selectedCategory;
  List<Subcategory> _subcategories = [];
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCateegories();
    //once the categories are loaded process then
    futureCategories.then((categories) {
      // iterate through the categories to find the "Fashion" category
      for (var category in categories) {
        if (category.name == 'Fashion') {
          // If  fashion category is found then set it as the selected category
          setState(() {
            _selectedCategory = category;
          });
          // load subcategories for the "Fashion" category
          _loadsubcategory(category.name);
        }
      }
      _selectedCategory = categories.first;
      _loadsubcategory(_selectedCategory!.name);
    });
  }

  //this will load subcategories based on the categoryName
  Future<void> _loadsubcategory(String categoryName) async {
    final subcategories = await _subcategoryController
        .getSubcategoriesByCategoryName(categoryName);
    setState(() {
      _subcategories = subcategories;
      // print(subcategories);
      // print(categoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: SizedBox(height: 120, child: HeaderWidget()),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //left-side - Display categories
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.grey.shade200,
                child: FutureBuilder(
                    future: futureCategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else {
                        final categories = snapshot.data!;
                        return ListView.builder(
                            // scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                  _loadsubcategory(category.name);
                                },
                                title: Text(
                                  category.name,
                                  style: GoogleFonts.quicksand(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: category == _selectedCategory
                                          ? Colors.blue
                                          : Colors.black),
                                ),
                              );
                            });
                      }
                    }),
              )),
          //right-side - Display selected category details
          Expanded(
            flex: 5,
            child: _selectedCategory != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _selectedCategory!.name,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.7,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(_selectedCategory!.banner),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        _subcategories.isNotEmpty
                            ? GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _subcategories.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 4,
                                        childAspectRatio: 2 / 3),
                                itemBuilder: (context, index) {
                                  final subcategory = _subcategories[index];
                                  return SubcategoryTileWidget(
                                    image: subcategory.image, 
                                    title: subcategory.subCategoryName
                                  );
                                })
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "No SubCategories",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.7,
                                  ),
                                )),
                              ),
                      ],
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
