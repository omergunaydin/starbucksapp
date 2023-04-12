import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:starbucksapp/pages/cart/cart_payment_page.dart';
import 'package:starbucksapp/widgets/reusable_button.dart';
import 'package:starbucksapp/widgets/reusable_top_bar.dart';

import '../../constants/dimens/uihelper.dart';
import '../../constants/values/colors.dart';
import '../../constants/values/constants.dart';
import '../../data/products_api_client.dart';
import '../../data/user_api_client.dart';
import '../../models/product.dart';
import '../../models/user.dart';
import '../../widgets/reusable_alert_dialog.dart';
import '../../widgets/reusable_snackbar.dart';
import '../product/product_details_page.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  List<CartItem> cartItems = [];
  double cartTotal = 0;
  bool loading = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  changeLoadingState() {
    setState(() {
      loading = !loading;
    });
  }

  getUserData() async {
    changeLoadingState();
    cartItems = [];
    StarUser? user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
    cartItems = user!.cart!;
    calculateCartTotal();
    changeLoadingState();
  }

  calculateCartTotal() {
    cartTotal = 0;
    for (var cartItem in cartItems) {
      cartTotal = cartTotal + cartItem.price! * cartItem.quantity!;
    }
  }

  updateCartItem(CartItem cartItem, int index, String fnc) {
    setState(() {
      if (fnc == 'add') {
        cartItems[index].quantity = cartItems[index].quantity! + 1;
        cartItems[index].totalPrice = cartItems[index].totalPrice! + cartItems[index].price!;
      } else {
        cartItems[index].quantity = cartItems[index].quantity! - 1;
        cartItems[index].totalPrice = cartItems[index].totalPrice! - cartItems[index].price!;
      }
      calculateCartTotal();
      if (cartItems[index].quantity == 0) {
        showSnackBar(context: context, msg: 'Product has been deleted from the cart!', type: 'success');
        UserApiClient().deleteProductFromUserCart(mAuth.currentUser!.uid, cartItems[index]);
        cartItems.removeAt(index);
      } else {
        UserApiClient().updateProductsOnUserCart(mAuth.currentUser!.uid, cartItems);
      }
    });
  }

  deleteCartItems() {
    setState(() {
      cartItems = [];
      calculateCartTotal();
      UserApiClient().updateProductsOnUserCart(mAuth.currentUser!.uid, cartItems);
      Navigator.of(context).pop();
      showSnackBar(context: context, msg: 'The items in your cart have been deleted!', type: 'success');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: cartItems.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: UiHelper.allPadding4x,
              child: ReusableButton(
                  text: 'Proceed To Payment',
                  color: UiColorHelper.mainGreen.withAlpha(225),
                  onPressed: () {
                    if (cartTotal >= 10) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: CartPaymentPage(cartTotal: cartTotal, cartItems: cartItems),
                        ),
                      );
                    } else {
                      showSnackBar(context: context, msg: 'Cart total cannot be less than 10\$!', type: 'error');
                    }
                  }),
            ),
      body: SafeArea(
        child: Column(
          children: [
            ReusableTopBar(text: 'Your Cart', iconData: MdiIcons.cartOutline),
            //List of CartItems!!!!

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      width: width,
                      height: 40,
                      color: UiColorHelper.mainGreen.withAlpha(210),
                      child: Center(
                        child: Text(
                          'The minimum total cart amount should be over 10\$.',
                          style: textTheme.button!.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    loading == true
                        ? SizedBox(
                            width: width,
                            height: height * 0.75,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: UiColorHelper.mainGreen,
                              ),
                            ),
                          )
                        : cartItems.isEmpty
                            ? SizedBox(
                                height: height * 0.75,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(MdiIcons.cartOff),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('There are no items in your cart!')
                                  ],
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  CartItem cartItem = cartItems[index];
                                  return InkWell(
                                    onTap: () async {
                                      Product? product = await ProductsApiClient().getProductById(cartItem.id!);
                                      Future(() {
                                        scheduleMicrotask(() {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.bottomToTop,
                                              child: ProductDetailsPage(
                                                product: product!,
                                              ),
                                            ),
                                          ).then((value) => getUserData());
                                        });
                                      });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      padding: UiHelper.allPadding2x,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  side: const BorderSide(color: UiColorHelper.cardBorderColor),
                                                ),
                                                child: Padding(
                                                  padding: UiHelper.allPadding1x,
                                                  child: Image.network(
                                                    cartItem.imageUrl!,
                                                    width: 70,
                                                    height: 70,
                                                    loadingBuilder: (context, child, loadingProgress) {
                                                      if (loadingProgress == null) return child;
                                                      return const Center(
                                                        child: CircularProgressIndicator(
                                                          color: UiColorHelper.mainGreen,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: UiHelper.allPadding2x,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: width * 0.40, child: Text(cartItem.name!, style: textTheme.button)),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Card(
                                                          elevation: 0,
                                                          color: UiColorHelper.mainGreen.withAlpha(225),
                                                          margin: EdgeInsets.zero,
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                                            child: Text(
                                                              '${cartItem.price!.toStringAsFixed(2)} \$',
                                                              style: Theme.of(context).textTheme.button!.copyWith(
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Colors.white,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 15),
                                                        cartItem.size != null
                                                            ? Image.asset(
                                                                'assets/images/cup.png',
                                                                height: 20,
                                                                fit: BoxFit.contain,
                                                              )
                                                            : const SizedBox.shrink(),
                                                        const SizedBox(width: 5),
                                                        cartItem.size != null
                                                            ? Text(
                                                                '${cartItem.size}',
                                                                style: textTheme.button,
                                                              )
                                                            : const SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              //Add Remove Buttons & Total Price
                                              Padding(
                                                padding: UiHelper.allPadding2x,
                                                child: Column(
                                                  children: [
                                                    //Add Remove Buttons
                                                    Container(
                                                      padding: UiHelper.allPadding1x,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors.white,
                                                        ),
                                                        borderRadius: UiHelper.borderRadiusCircular4x,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.5),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: const Offset(0, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            InkWell(
                                                              onTap: () => updateCartItem(cartItem, index, 'remove'),
                                                              child: const Icon(
                                                                Icons.remove,
                                                                color: UiColorHelper.mainGreen,
                                                                size: 15,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: UiHelper.horizontalSymmetricPadding2x,
                                                              child: Text(
                                                                '${cartItem.quantity}',
                                                                style: Theme.of(context).textTheme.button!.copyWith(color: UiColorHelper.mainGreen, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () => updateCartItem(cartItem, index, 'add'),
                                                              child: const Icon(
                                                                Icons.add,
                                                                color: UiColorHelper.mainGreen,
                                                                size: 15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Text(
                                                      'Total Price',
                                                      style: textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${cartItem.totalPrice!.toStringAsFixed(2)} \$',
                                                      style: textTheme.button!.copyWith(fontWeight: FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: UiHelper.horizontalSymmetricPadding3x,
                                    child: Container(color: Colors.white, child: const Divider(height: 0, thickness: 1)),
                                  );
                                },
                              ),
                    cartItems.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: UiHelper.horizontalSymmetricPadding4x,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Remove all Products from Cart
                                    if (cartItems.isEmpty) {
                                      showSnackBar(context: context, msg: 'Your cart is already empty!');
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (_) => ReusableAlertDialog(
                                        text: 'Are you sure want to delete all items in your cart?',
                                        type: '2',
                                        onPressed: () => deleteCartItems(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: UiHelper.allPadding1x,
                                    decoration: BoxDecoration(
                                      color: UiColorHelper.mainGreen.withAlpha(225),
                                      borderRadius: UiHelper.borderRadiusCircular5x,
                                    ),
                                    child: Padding(
                                      padding: UiHelper.horizontalSymmetricPadding1x,
                                      child: Row(
                                        children: [
                                          const Icon(MdiIcons.deleteOutline, size: 16, color: Colors.white),
                                          const SizedBox(width: 5),
                                          Text('Remove All', style: textTheme.button!.copyWith(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text('Cart Total : ', style: textTheme.subtitle1!),
                                Text(
                                  '${cartTotal.toStringAsFixed(2)} \$',
                                  style: textTheme.subtitle1!.copyWith(color: UiColorHelper.mainGreen, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
