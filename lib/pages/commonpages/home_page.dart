import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:starbucksapp/constants/dimens/uihelper.dart';
import 'package:starbucksapp/constants/values/colors.dart';
import 'package:starbucksapp/cubit/user_cubit.dart';
import 'package:starbucksapp/data/products_api_client.dart';
import 'package:starbucksapp/pages/account/account_main_page.dart';
import 'package:starbucksapp/pages/product/product_details_page.dart';

import '../../data/carousel_api_client.dart';
import '../../models/carousel.dart';
import '../../models/product.dart';
import '../../widgets/reusable_stars.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  late Future _carouselFuture;
  late Future _featuredProductsFuture;

  @override
  void initState() {
    super.initState();
    _carouselFuture = CarouselsApiClient().fetchCarouselsData();
    _featuredProductsFuture = ProductsApiClient().fetchFeaturedProductsData();
    ;
    //getData();
  }

  getData() async {
    await ProductsApiClient().fetchFeaturedProductsData();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Welcome Text & Profile Picture
                Container(
                  height: height * 0.08,
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/splash_bg.png'), fit: BoxFit.cover)),
                  child: Padding(
                    padding: UiHelper.horizontalSymmetricPadding3x,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: height * 0.06,
                          height: height * 0.06,
                          padding: UiHelper.rightPadding2x,
                          child: Image.asset('assets/images/starbucks_logo.png'),
                        ),

                        Text('Starbucks', style: textTheme.headline6),
                        const Spacer(),
                        //Profile Image
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: AccountMainPage(),
                              ),
                            );
                          },
                          child: Container(
                            width: height * 0.05,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: UiHelper.borderRadiusProfilePicture,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Container(
                              width: height * 0.04,
                              height: height * 0.04,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: UiHelper.borderRadiusProfilePicture,
                                border: Border.all(
                                  color: UiColorHelper.mainGreen.withAlpha(200),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: UiHelper.borderRadiusProfilePicture,
                                child: Builder(builder: (context) {
                                  final userState = context.watch<UserCubit>().state;
                                  if (userState is UserSignIn) {
                                    if (userState.user.imageUrl != null) {
                                      return Image.network(userState.user.imageUrl!, fit: BoxFit.cover);
                                    } else {
                                      String userName = userState.user.name ?? 'User Name';
                                      List<String> names = userName.split(" ");
                                      String initials = "${names[0].substring(0, 1)}${names[1].substring(0, 1)}";
                                      return Center(
                                          child: Text(
                                        initials,
                                        style: textTheme.subtitle2!.copyWith(color: UiColorHelper.mainGreen),
                                      ));
                                    }
                                  }
                                  return const Icon(
                                    MdiIcons.account,
                                    color: Colors.white,
                                  );
                                }),
                                //Image.network(Constants.testUserImage),
                                //TODO: Eğer user login değilse icon göster, login değilse image göster
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 2, thickness: 1, color: Colors.black12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Reward Counter Area
                        BlocBuilder<UserCubit, UserState>(
                          bloc: UserCubit(),
                          builder: (context, state) {
                            if (state is UserSignIn) {
                              return Container(
                                color: UiColorHelper.darkGreen,
                                width: width,
                                height: height * 0.15,
                                child: Column(
                                  children: [
                                    Container(
                                      color: UiColorHelper.mainGreen,
                                      width: width,
                                      padding: UiHelper.horizontalSymmetricPadding3x,
                                      child: Text(
                                        state.user.memberType!,
                                        style: textTheme.button!.copyWith(color: Colors.white),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Circular Progress of Drinks
                                        Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            CircularPercentIndicator(
                                              radius: 28.0,
                                              lineWidth: 4.0,
                                              percent: (state.user.totalStars! % 15) / 15,
                                              reverse: true,
                                              center: const Icon(
                                                MdiIcons.coffee,
                                                color: UiColorHelper.backgroundColor,
                                              ),
                                              footer: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text('${(state.user.totalStars! % 15)} / 15', style: textTheme.button!.copyWith(color: Colors.white)),
                                              ),
                                              progressColor: UiColorHelper.mainGreen,
                                              backgroundColor: Colors.white,
                                              circularStrokeCap: CircularStrokeCap.round,
                                            ),
                                          ],
                                        ),
                                        // Star Balance And Free Drinks
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                // star balance
                                                Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('${(state.user.totalStars! % 15)}', style: textTheme.headline6!.copyWith(color: Colors.white)),
                                                        const SizedBox(width: 5),
                                                        const Icon(Icons.star, size: 26, color: UiColorHelper.starColor),
                                                      ],
                                                    ),
                                                    Text('stars balance', style: textTheme.caption!.copyWith(color: Colors.white))
                                                  ],
                                                ),
                                                const SizedBox(width: 10),
                                                // free drinks
                                                Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          '${state.user.freeDrinks!}',
                                                          style: textTheme.headline6!.copyWith(color: Colors.white),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        const Icon(MdiIcons.coffee, size: 24, color: Colors.white)
                                                      ],
                                                    ),
                                                    Text('free drinks', style: textTheme.caption!.copyWith(color: Colors.white))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(state.user.totalStars.toString(), style: textTheme.button!.copyWith(color: Colors.white)),
                                                const Icon(Icons.star_outline, size: 16, color: UiColorHelper.starColor),
                                                Text('you\'ve earned so far', style: textTheme.button!.copyWith(color: Colors.white))
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 10),
                        //Promotional Products
                        FutureBuilder(
                          future: _carouselFuture,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(color: UiColorHelper.buttonColor),
                                );
                              case ConnectionState.done:
                                List<Carousel> carouselList = snapshot.data;
                                return Padding(
                                  padding: UiHelper.horizontalSymmetricPadding3x,
                                  child: ClipRRect(
                                    borderRadius: UiHelper.borderRadiusCircular4x,
                                    child: CarouselSlider(
                                      options: CarouselOptions(height: 200, viewportFraction: 1, autoPlay: false, disableCenter: true),
                                      items: carouselList.map((carousel) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return InkWell(
                                              onTap: () async {
                                                /* Product? product = await ProductsApiClient().getProductById(carousel.productId!);
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.bottomToTop,
                                                child: ProductDetails(product: product!),
                                              ),
                                            );*/
                                              },
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    width: width,
                                                    height: 200,
                                                    child: Image.network(
                                                      carousel.imageUrl!,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context, child, loadingProgress) {
                                                        if (loadingProgress == null) return child;
                                                        return const Center(
                                                          child: CircularProgressIndicator(
                                                            color: UiColorHelper.buttonColor,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      color: UiColorHelper.mainGreen,
                                                      padding: UiHelper.allPadding2x,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            carousel.title!,
                                                            style: textTheme.subtitle1!.copyWith(color: Colors.white),
                                                          ),
                                                          Text(
                                                            carousel.subTitle!,
                                                            style: textTheme.caption!.copyWith(color: Colors.white),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );

                              default:
                                return SizedBox(
                                  height: 200,
                                  width: width,
                                );
                            }
                          },
                        ),
                        Padding(
                          padding: UiHelper.allPadding3x,
                          child: Text('Featured Products', style: textTheme.subtitle1!),
                        ),
                        FutureBuilder(
                            future: _featuredProductsFuture,
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
                                    height: rowCount * width / 3 * 1.4,
                                    child: GridView.builder(
                                      physics: const ScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 1 / 1.3),
                                      itemCount: productsList.length,
                                      padding: EdgeInsets.zero,
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
                                          child: Container(
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: UiHelper.borderRadiusCircular3x,
                                                    side: const BorderSide(color: UiColorHelper.cardBorderColor),
                                                  ),
                                                  child: Padding(
                                                    padding: UiHelper.allPadding1x,
                                                    child: ClipRRect(
                                                      borderRadius: UiHelper.borderRadiusCircular2x,
                                                      child: Image.network(
                                                        product.imageUrl!,
                                                        width: 120,
                                                        height: 150,
                                                        fit: BoxFit.fitHeight,
                                                        loadingBuilder: (context, child, loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return const SizedBox(
                                                            width: 120,
                                                            height: 150,
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
                                                Center(child: ReusableStars(rank: product.rank!, isSmall: true)),
                                                Padding(
                                                  padding: UiHelper.allPadding2x,
                                                  child: SizedBox(
                                                    width: width / 2,
                                                    height: height * 0.05,
                                                    child: Text(
                                                      product.name!,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.button,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                case ConnectionState.none:
                                  return SizedBox.shrink();

                                case ConnectionState.active:
                                  return SizedBox.shrink();
                              }
                            }),
                        SizedBox(height: height * 0.10)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
