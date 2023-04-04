import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

import '../constants/dimens/uihelper.dart';
import '../constants/values/colors.dart';
import '../models/product.dart';
import '../pages/product/product_details_page.dart';

class ProductTabList extends StatefulWidget {
  List<Future> futuresList;
  List<String> tabsList;

  ProductTabList({Key? key, required this.tabsList, required this.futuresList}) : super(key: key);

  @override
  State<ProductTabList> createState() => _ProductTabListState();
}

class _ProductTabListState extends State<ProductTabList> with AutomaticKeepAliveClientMixin {
  late List<int> indexList;

  @override
  void initState() {
    super.initState();
    indexList = List.generate(widget.tabsList.length, (i) => i);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return ScrollableListTabView(
      tabHeight: 45,
      tabs: [
        ...indexList.map(
          (index) => ScrollableListTab(
            tab: ListTab(
              activeBackgroundColor: UiColorHelper.mainGreen,
              label: Text(widget.tabsList[index]),
              borderRadius: UiHelper.borderRadiusCircular6x,
            ),
            body: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FutureBuilder(
                  future: widget.futuresList[index],
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(color: UiColorHelper.mainGreen),
                          ),
                        );

                      case ConnectionState.done:
                        List<Product> productsList = snapshot.data;
                        int rowCount = (productsList.length / 3).ceil();
                        return Container(
                          color: Colors.white,
                          height: rowCount * width / 3 * 1.4 + (index == widget.futuresList.length - 1 ? height * 0.50 : 0),
                          child: GridView.builder(
                            physics: const ScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: width / 3, childAspectRatio: 1 / 1.4, mainAxisSpacing: 0),
                            itemCount: productsList.length,
                            itemBuilder: (context, index) {
                              Product product = productsList[index];
                              return GestureDetector(
                                onTap: () {
                                  debugPrint('tıklandı ${product.id}');
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: ProductDetailsPage(product: product),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: UiHelper.topPadding1x,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: UiHelper.borderRadiusCircular3x,
                                              side: const BorderSide(color: UiColorHelper.cardBorderColor),
                                            ),
                                            child: Padding(
                                              padding: UiHelper.allPadding2x,
                                              child: ClipRRect(
                                                borderRadius: UiHelper.borderRadiusCircular2x,
                                                child: Image.network(
                                                  product.imageUrl!,
                                                  width: 70,
                                                  height: 70,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return const SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: Center(
                                                        child: CircularProgressIndicator(
                                                          color: UiColorHelper.mainGreen,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      /*Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0,
                                                color: UiColorHelper.mainGreen,
                                                child: Padding(
                                                  padding: UiHelper.allPadding1x,
                                                  child: Text(
                                                    //'${product.!.toStringAsFixed(2)} TL',
                                                    '20 TL',
                                                    style: Theme.of(context).textTheme.button!.copyWith(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),*/
                                      Padding(
                                        padding: UiHelper.allPadding1x,
                                        child: Text(
                                          product.name!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      default:
                    }
                    return Text('data ${snapshot.data}');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
