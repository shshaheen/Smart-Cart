import 'package:flutter/material.dart';
import 'package:smart_cart/views/screens/details/screens/widgets/top_rated_widget.dart';
import 'package:smart_cart/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:smart_cart/views/screens/nav_screens/widgets/category_item_widget.dart';
import 'package:smart_cart/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:smart_cart/views/screens/nav_screens/widgets/popular_product_widget.dart';
import 'package:smart_cart/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.2,
          ), 
          child: HeaderWidget()),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            BannerWidget(),
            CategoryItemWidget(),
            ReusableTextWidget(
              title: 'Popular Products', 
              subtitle: 'view all'
            ),
            PopularProductWidget(),
            SizedBox(
              height: 30,
            ),
            ReusableTextWidget(
              title: 'Top Rated Products', 
              subtitle: 'view all'
            ),
            
            TopRatedProductWidget(),
          ],
        ),
      ),
    );
  }
}
