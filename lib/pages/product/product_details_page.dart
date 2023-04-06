import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:starbucksapp/constants/dimens/uihelper.dart';
import 'package:starbucksapp/constants/values/colors.dart';
import 'package:starbucksapp/models/product.dart';
import 'package:starbucksapp/widgets/reusable_button.dart';
import 'package:starbucksapp/widgets/reusable_size_selector.dart';
import 'package:starbucksapp/widgets/reusable_stars.dart';

import '../../data/user_api_client.dart';
import '../../models/user.dart';

class ProductDetailsPage extends StatefulWidget {
  Product product;
  ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> with TickerProviderStateMixin {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late List<Fav> favsList;
  late List<CartItem> cartItemsList;
  late Product product;
  late CartItem cartItem;
  bool isFav = false;
  bool isOnCart = false;
  int selectedSizeIndex = 0;
  int quantity = 1;
  int cartId = 0;
  late AnimationController animateController;
  late AnimationController animateController2;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    print(product.cat);
    animateController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animateController2 = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    if (mAuth.currentUser != null) {
      checkUserCartItems();
    }
    cartItem = CartItem(
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
    );
  }

  changeSelectedSizeIndex(int index) {
    setState(() {
      checkUserCartItems();
      selectedSizeIndex = index;
      playAnimation();
    });
  }

  void playAnimation() {
    animateController.reset();
    animateController.forward();
    animateController2.reset();
    animateController2.forward();
  }

  void changeIsOnCart() {
    isOnCart = !isOnCart;
  }

  checkUserCartItems() async {
    StarUser? user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
    cartItemsList = user!.cart ?? [];
  }

  addToCart() {
    //isOncArt ise güncelleme yapılacak!
    //değilse ilk ekleme yapılacak!
    bool willUpdate = false;
    if (product.type == 'drink') {
      String size = product.sizeOptions![selectedSizeIndex].size!;
      double price = product.sizeOptions![selectedSizeIndex].price!;

      //Eğer varsa size da aynıysa rakam update edilmeli!
      cartItemsList.asMap().forEach((index, cartItem) {
        final id = cartItem.id;
        if (product.id == id && cartItem.size == product.sizeOptions![selectedSizeIndex].size!) {
          print('CartItem Match found at index $index');
          cartItem = cartItem.copyWith(cartId: index, size: size, price: price, quantity: cartItem.quantity! + quantity, totalPrice: cartItem.totalPrice! + (quantity * price));
          willUpdate = true;
          UserApiClient().updateProductOnUserCart(mAuth.currentUser!.uid, cartItem);
        }
      });

      if (!willUpdate) {
        cartItem = cartItem.copyWith(cartId: cartItemsList.length, size: size, price: price, quantity: quantity, totalPrice: (quantity * price));
      }
    } else {
      double price = product.price!;
      cartItem = cartItem.copyWith(cartId: cartItemsList.length, price: price, quantity: quantity, totalPrice: (quantity * price));
    }

    if (!willUpdate) {
      UserApiClient().addProductToUserCart(mAuth.currentUser!.uid, cartItem);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: UiColorHelper.darkGreen,
      appBar: AppBar(
        title: SlideInDown(
          duration: const Duration(milliseconds: 1300),
          child: Text(
            'Starbucks',
            style: textTheme.subtitle1!.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: UiColorHelper.darkGreen,
        centerTitle: true,
        elevation: 0,
        leading: SlideInDown(
          duration: const Duration(milliseconds: 1300),
          child: IconButton(
            icon: const Icon(
              MdiIcons.chevronDown,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          SlideInDown(
            duration: const Duration(milliseconds: 1300),
            child: IconButton(
              icon: const Icon(
                MdiIcons.heartOutline,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Stack(
                  children: [
                    SlideInUp(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        color: UiColorHelper.darkGreen,
                        padding: UiHelper.bottomPadding3x,
                        width: width,
                        height: height * 0.25,
                        child: Center(
                          child: Image.network(
                            product.imageUrl!,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SlideInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: UiHelper.allPadding3x,
                          child: Text(
                            product.name!,
                            style: textTheme.subtitle1!.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    /* Positioned(top: 10, left: 10, child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(MdiIcons.chevronDown, size: 30, color: Colors.white))),
                    Positioned(top: 10, right: 10, child: IconButton(onPressed: () {}, icon: const Icon(MdiIcons.heartOutline, size: 28, color: Colors.white))),
                  */
                  ],
                ),

                //TODO:Expanded ekliydi
                SlideInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    width: width,
                    //height: height * 0.70,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: UiHelper.allPadding5x,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SlideInUp(
                            duration: const Duration(milliseconds: 600),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableStars(
                                  rank: product.rank!,
                                  isSmall: false,
                                ),
                                ZoomIn(
                                  manualTrigger: true,
                                  controller: (controller) => animateController = controller,
                                  child: Text(
                                    product.type == 'drink' ? '${product.sizeOptions![selectedSizeIndex].price!.toStringAsFixed(2)} \$' : '${product.price!.toStringAsFixed(2)} \$',
                                    style: textTheme.headline6!.copyWith(color: UiColorHelper.mainGreen, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SlideInUp(duration: const Duration(milliseconds: 700), child: Text('Description', style: textTheme.subtitle1!.copyWith(color: UiColorHelper.mainGreen))),
                          const SizedBox(height: 10),
                          SlideInUp(
                            duration: const Duration(milliseconds: 800),
                            child: Text(
                              product.description!,
                              style: textTheme.button!,
                              maxLines: product.type != 'goods' ? 4 : 10,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(height: 10),
                          product.type != 'goods'
                              ? SlideInUp(duration: const Duration(milliseconds: 900), child: Text('Nutrition', style: textTheme.subtitle1!.copyWith(color: UiColorHelper.mainGreen)))
                              : const SizedBox.shrink(),
                          const SizedBox(height: 10),
                          product.type != 'goods'
                              ? SlideInUp(
                                  duration: const Duration(milliseconds: 1000),
                                  child: ZoomIn(
                                      manualTrigger: true,
                                      controller: (controller) => animateController2 = controller,
                                      child: Text(product.type == 'drink' ? product.sizeOptions![selectedSizeIndex].calories! : product.calories!, style: textTheme.button!)))
                              : const SizedBox.shrink(),
                          const SizedBox(height: 10),
                          product.type == 'drink'
                              ? SlideInUp(duration: const Duration(milliseconds: 1200), child: Center(child: Text('Select Size', style: textTheme.headline6!.copyWith(color: UiColorHelper.mainGreen))))
                              : const SizedBox.shrink(),
                          product.type == 'drink'
                              ? SlideInUp(
                                  duration: const Duration(milliseconds: 1200),
                                  child: ReusableSizeSelector(sizeOptions: product.sizeOptions!, selectedSizeIndex: selectedSizeIndex, changeSelectedSizeIndex: changeSelectedSizeIndex))
                              : const SizedBox.shrink(),
                          SizedBox(height: product.type == 'drink' ? height * 0.20 : height * 0.40),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: width,
                height: height * 0.20,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/splash_bg.png'), fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideInUp(
                duration: const Duration(milliseconds: 1400),
                child: Padding(
                  padding: UiHelper.allPadding3x,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Quantity', style: textTheme.subtitle1),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (quantity != 1) quantity--;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: UiHelper.borderRadiusCircular1x,
                                    color: UiColorHelper.mainGreen,
                                  ),
                                  padding: UiHelper.allPaddingmin,
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: UiHelper.horizontalSymmetricPadding3x,
                                child: Text(
                                  '$quantity',
                                  style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.black),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (quantity < 10) quantity++;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: UiHelper.borderRadiusCircular1x,
                                    color: UiColorHelper.mainGreen,
                                  ),
                                  padding: UiHelper.allPaddingmin,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ReusableButton(
                          text: 'Add To Cart',
                          color: UiColorHelper.mainGreen,
                          widthPercent: 0.50,
                          onPressed: () {
                            addToCart();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
