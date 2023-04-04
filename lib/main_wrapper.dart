import 'package:flutter/material.dart';
import 'package:starbucksapp/pages/cart/cart_page.dart';
import 'pages/commonpages/home_page.dart';
import 'widgets/custom_nav_bar.dart';
import 'pages/product/product_list_page.dart';

class MainWrapper extends StatefulWidget {
  MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _selectedIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    void changeSelectedIndex(int i) {
      setState(() {
        _pageController.jumpToPage(i);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (value) {
              CustomNavBar.globalKey.currentState!.changeIndex(value);
            },
            children: [
              HomePage(),
              ProductListPage(initialIndex: 0, page: 'Drinks'),
              ProductListPage(initialIndex: 0, page: 'Foods'),
              ProductListPage(initialIndex: 0, page: 'Goods'),
              CartPage(),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: CustomNavBar(selectedIndex: _selectedIndex, function: changeSelectedIndex))
        ],
      ),
    );
  }
}
