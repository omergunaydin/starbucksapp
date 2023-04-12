import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:starbucksapp/constants/dimens/uihelper.dart';
import 'package:starbucksapp/constants/values/colors.dart';
import 'package:starbucksapp/pages/cart/cart_change_pickup_time_page.dart';
import 'package:starbucksapp/widgets/reusable_button_outlined.dart';
import 'package:starbucksapp/widgets/reusable_top_bar.dart';
import '../../data/orders_api_client.dart';
import '../../data/user_api_client.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../widgets/reusable_snackbar.dart';
import '../../widgets/reusable_textfield.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CartPaymentPage extends StatefulWidget {
  List<CartItem> cartItems = [];
  double cartTotal;
  CartPaymentPage({Key? key, required this.cartTotal, required this.cartItems}) : super(key: key);

  @override
  State<CartPaymentPage> createState() => _CartPaymentPageState();
}

class _CartPaymentPageState extends State<CartPaymentPage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  final TextEditingController _noteTextController = TextEditingController();
  String _selectedDate = '';
  String _selectedHour = '';
  bool checked = false;
  late String hourText;
  bool orderResult = false;

  @override
  void initState() {
    calculateDate();
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    calculateDeliveryHour(currentHour);

    super.initState();
  }

  calculateDate() async {
    await initializeDateFormatting('tr_TR', null);
    setState(() {
      DateTime currentDate = DateTime.now();
      DateTime dateToday = DateTime(currentDate.year, currentDate.month, currentDate.day);
      _selectedDate = DateFormat('d MMMM yyyy, EEEE').format(currentDate);
      if (currentDate.hour >= 21) {
        DateTime second = currentDate.add(const Duration(days: 1));
        _selectedDate = DateFormat('d MMMM yyyy, EEEE').format(second);
      }
    });
  }

  calculateDeliveryHour(int currentHour) {
    if (currentHour >= 0 && currentHour < 9) {
      hourText = 'Today 09:00-10:00';
      _selectedHour = '09:00-10:00';
    } else if (currentHour >= 9 && currentHour <= 20) {
      hourText = 'Today $currentHour:00-${currentHour + 1}:00';
      _selectedHour = '$currentHour:00-${currentHour + 1}:00';
      if (currentHour == 9) {
        hourText = 'Today 0$currentHour:00-${currentHour + 1}:00';
        _selectedHour = '0$currentHour:00-${currentHour + 1}:00';
      }
    } else if (currentHour >= 0 && currentHour < 9) {
      hourText = 'Today $currentHour:00-${currentHour + 1}:00';
      _selectedHour = '$currentHour:00-${currentHour + 1}:00';
      if (currentHour == 9) {
        hourText = 'Today 0$currentHour:00-${currentHour + 1}:00';
        _selectedHour = '0$currentHour:00-${currentHour + 1}:00';
      }
    }
  }

  showDateTimeData(String sDate, String sHour) {
    setState(() {
      _selectedDate = sDate;
      _selectedHour = sHour;
      if (_selectedHour.startsWith('0')) {
        String char = _selectedHour.substring(1, 2);
        int hour = int.parse(char);
        calculateDeliveryHour(hour);
      } else {
        String s = _selectedHour.substring(0, 2);
        int hour = int.parse(s);
        calculateDeliveryHour(hour);
      }
    });
  }

  addOrder() async {
    if (checked) {
      StarUser? user = await UserApiClient().fetchUserData(mAuth.currentUser!.uid);
      if (user != null) {
        StarOrder newOrder = StarOrder(
          userid: user.id,
          pickUpState: 'Preparing',
          pickUpDate: _selectedDate,
          pickUpTime: _selectedHour,
          pickUpNote: _noteTextController.text,
          cart: widget.cartItems,
          cartTotal: widget.cartTotal,
          orderDateTime: DateTime.now(),
        );

        //send order to db
        orderResult = await OrdersApiClient().addOrder(newOrder);

        if (orderResult) {
          //remove cartItems from cart!
          showSnackBar(context: context, msg: 'Your order has been successfully received!', type: 'success');
          widget.cartItems = [];
          UserApiClient().updateProductsOnUserCart(mAuth.currentUser!.uid, widget.cartItems);
          Future.delayed(
            const Duration(seconds: 3),
            () => Navigator.of(context).popUntil(ModalRoute.withName("/MainWrapper")),
          );
        } else {
          showSnackBar(context: context, msg: 'Something went wrong!', type: 'error');
        }
      }
    } else {
      showSnackBar(context: context, msg: 'You have to confirm the contract!', type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () => orderResult ? null : addOrder(),
        child: Container(
          color: UiColorHelper.mainGreen,
          width: width,
          height: height * 0.10,
          child: Center(
            child: Container(
              width: width * 0.90,
              height: height * 0.06,
              padding: UiHelper.horizontalSymmetricPadding3x,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: UiHelper.borderRadiusCircular2x,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.cartTotal.toStringAsFixed(2)} \$', style: textTheme.subtitle1!.copyWith(color: UiColorHelper.mainGreen, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('Complete Order', style: textTheme.subtitle1!.copyWith(color: UiColorHelper.mainGreen, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableTopBar(text: 'Complete Order', iconData: MdiIcons.cartOutline),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Select Store Area Demo
                    Padding(
                      padding: UiHelper.allPadding3x,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: UiHelper.verticalSymmetricPadding2x,
                            child: Text(
                              'Select Your Store',
                              style: textTheme.subtitle2!.copyWith(color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            width: width,
                            height: height * 0.20,
                            child: Image.asset(
                              'assets/images/map.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.store, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                'San Mateo and Haines',
                                style: textTheme.button!.copyWith(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(MdiIcons.navigationOutline, size: 16, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                '2104 San Mateo Blvd NE, Alburquerque',
                                style: textTheme.button!.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Pick Up From Store Time
                    Container(
                      color: Colors.grey.shade100,
                      width: width,
                      child: Padding(
                        padding: UiHelper.allPadding3x,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: UiHelper.verticalSymmetricPadding1x,
                              child: Text(
                                'Pick up from Store Time',
                                style: textTheme.subtitle2!.copyWith(color: Colors.grey),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedDate,
                                      style: textTheme.subtitle2,
                                    ),
                                    Text(hourText, style: textTheme.button!.copyWith(color: UiColorHelper.mainGreen))
                                  ],
                                ),
                                ReusableButtonOutlined(
                                  text: 'Change',
                                  widthPercent: 0.30,
                                  color: UiColorHelper.mainGreen,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: CartChangePickUpTimePage(selectedDate: _selectedDate, selectedHour: _selectedHour, function: showDateTimeData),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Payment Method
                    Container(
                      color: Colors.grey.shade100,
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: UiHelper.verticalSymmetricPadding3x,
                            child: Padding(
                              padding: UiHelper.horizontalSymmetricPadding3x,
                              child: Text(
                                'Payment Method',
                                style: textTheme.subtitle2!.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          RadioListTile(
                            value: 0,
                            groupValue: 0,
                            onChanged: (value) {},
                            activeColor: UiColorHelper.mainGreen,
                            title: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'My Credit Card',
                                      style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '543081**********12',
                                      style: textTheme.button!.copyWith(color: Colors.grey),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Container(
                                  width: 35,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(
                                    'assets/images/mastercard.png',
                                  ),
                                ),
                                const Spacer(),
                                ReusableButtonOutlined(
                                  text: 'Change',
                                  onPressed: () {},
                                  widthPercent: 0.30,
                                  color: UiColorHelper.mainGreen,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Add Note
                    Container(
                      color: Colors.grey.shade100,
                      width: width,
                      child: Padding(
                        padding: UiHelper.allPadding3x,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Note',
                              style: textTheme.subtitle2!.copyWith(color: Colors.grey),
                            ),
                            ReusableTextField(controller: _noteTextController),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Summary
                    Container(
                      color: Colors.grey.shade100,
                      width: width,
                      child: Padding(
                        padding: UiHelper.allPadding3x,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Summary',
                              style: textTheme.subtitle2!.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: UiHelper.verticalSymmetricPadding2x,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Products'),
                                  Text('${widget.cartTotal.toStringAsFixed(2)} \$'),
                                ],
                              ),
                            ),
                            const Divider(height: 2),
                            Padding(
                              padding: UiHelper.verticalSymmetricPadding2x,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Service Fee'),
                                  Text(
                                    'Free',
                                    style: TextStyle(color: UiColorHelper.mainGreen),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 2),
                            Padding(
                              padding: UiHelper.verticalSymmetricPadding2x,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Amount'),
                                  Text(
                                    '${widget.cartTotal.toStringAsFixed(2)} \$',
                                    style: const TextStyle(color: UiColorHelper.mainGreen),
                                  )
                                ],
                              ),
                            ),
                            const Divider(height: 2),
                            Padding(
                              padding: UiHelper.verticalSymmetricPadding4x,
                              child: CheckboxListTile(
                                value: checked,
                                onChanged: (value) {
                                  setState(() {
                                    checked = value!;
                                  });
                                },
                                activeColor: UiColorHelper.mainGreen,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: const EdgeInsets.all(0),
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: 'I have read and approved the', style: textTheme.button!),
                                      TextSpan(text: ' Information Form and the Distance Sales Agreement.', style: textTheme.button!.copyWith(color: UiColorHelper.mainGreen)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100)
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
