import 'package:starbucksapp/models/user.dart';

class StarOrder {
  String? id;
  String? userid;
  String? pickUpState;
  String? pickUpDate;
  String? pickUpTime;
  String? pickUpNote;
  List<CartItem>? cart;
  double? cartTotal;
  DateTime? orderDateTime;

  StarOrder({
    this.id,
    required this.userid,
    required this.pickUpState,
    required this.pickUpDate,
    required this.pickUpTime,
    required this.pickUpNote,
    required this.cart,
    required this.cartTotal,
    required this.orderDateTime,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; //Map<String, dynamic>()
    data['id'] = id;
    data['userid'] = userid;
    data['pickUpState'] = pickUpState;
    data['pickUpDate'] = pickUpDate;
    data['pickUpTime'] = pickUpTime;
    data['pickUpNote'] = pickUpNote;
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    data['cartTotal'] = cartTotal;
    data['orderDateTime'] = orderDateTime?.millisecondsSinceEpoch;
    return data;
  }

  StarOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    pickUpState = json['pickUpState'];
    pickUpDate = json['pickUpDate'];
    pickUpTime = json['pickUpTime'];
    pickUpNote = json['pickUpNote'];
    if (json['cart'] != null) {
      cart = <CartItem>[];
      json['cart'].forEach((v) {
        cart!.add(CartItem.fromJson(v));
      });
    }
    cartTotal = json['cartTotal'];
    orderDateTime = DateTime.fromMillisecondsSinceEpoch(json['orderDateTime']);
  }
}
