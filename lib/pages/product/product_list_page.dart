import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:starbucksapp/constants/dimens/uihelper.dart';
import 'package:starbucksapp/constants/values/colors.dart';
import 'package:starbucksapp/constants/values/constants.dart';
import '../../widgets/products_tab_list.dart';

class ProductListPage extends StatefulWidget {
  int initialIndex;
  String page;
  ProductListPage({Key? key, required this.initialIndex, required this.page}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> with SingleTickerProviderStateMixin {
  Constants constants = Constants();
  late final TabController _tabController;
  late final List<List<Future>> _futuresList;
  late final List<ProductTabList> _productList = [];
  late final List<String> mainTabs;
  late final List<List<String>> listOfTabList;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    if (widget.page == 'Drinks') {
      mainTabs = constants.mainTabsDrinks;
      listOfTabList = constants.listOfTabListDrinks;
    } else if (widget.page == 'Foods') {
      mainTabs = constants.mainTabsFoods;
      listOfTabList = constants.listOfTabListFoods;
    } else if (widget.page == 'Goods') {
      mainTabs = constants.mainTabsGoods;
      listOfTabList = constants.listOfTabListGoods;
    }

    _tabController = TabController(length: mainTabs.length, vsync: this, initialIndex: widget.initialIndex);
    _futuresList = Constants().getFutureList(mainTabs, listOfTabList);
    for (int i = 0; i < mainTabs.length; i++) {
      _productList.add(ProductTabList(tabsList: listOfTabList[i], futuresList: _futuresList[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: height * 0.08,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/splash_bg.png'), fit: BoxFit.cover)),
            child: Padding(
              padding: UiHelper.allPadding3x,
              child: Row(
                children: [
                  () {
                    if (widget.page == 'Drinks') {
                      return const Icon(MdiIcons.coffeeOutline, size: 30);
                    } else if (widget.page == 'Foods') {
                      return const Icon(MdiIcons.foodOutline, size: 30);
                    } else if (widget.page == 'Goods') {
                      return const Icon(MdiIcons.beerOutline, size: 30);
                    } else {
                      return const SizedBox.shrink();
                    }
                  }(),
                  const SizedBox(width: 10),
                  Text(widget.page, style: textTheme.headline5),
                ],
              ),
            ),
          ),
          Container(
            color: UiColorHelper.backgroundColor,
            child: TabBar(
              onTap: (value) {
                _tabController.index = value;
              },
              controller: _tabController,
              isScrollable: true,
              indicatorColor: UiColorHelper.mainGreen,
              tabs: [
                ...mainTabs.map(
                  (label) => Tab(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: _productList),
          ),
        ],
      ),
    );
  }
}
