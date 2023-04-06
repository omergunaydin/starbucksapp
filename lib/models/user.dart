// ignore_for_file: public_member_api_docs, sort_constructors_first
class StarUser {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? imageUrl;
  bool? userAgreement;
  bool? offers;
  DateTime? createdAt;
  DateTime? birthDate;
  String? gender;
  String? memberType;
  int? totalStars;
  int? freeDrinks;
  List<Fav>? fav;
  List<CartItem>? cart;

  StarUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.imageUrl,
    required this.userAgreement,
    required this.offers,
    required this.createdAt,
    this.birthDate,
    this.gender,
    required this.memberType,
    required this.totalStars,
    required this.freeDrinks,
    this.fav,
    this.cart,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; //Map<String, dynamic>()
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['imageUrl'] = imageUrl;
    data['userAgreement'] = userAgreement;
    data['offers'] = offers;
    data['memberType'] = memberType;
    data['totalStars'] = totalStars;
    data['freeDrinks'] = freeDrinks;
    data['createdAt'] = createdAt?.millisecondsSinceEpoch;
    if (birthDate != null) {
      data['birthDate'] = birthDate?.millisecondsSinceEpoch;
    }
    data['gender'] = gender;
    if (fav != null) {
      data['favs'] = fav!.map((v) => v.toJson()).toList();
    }
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  StarUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    imageUrl = json['imageUrl'];
    userAgreement = json['userAgreement'];
    offers = json['offers'];
    memberType = json['memberType'];
    totalStars = json['totalStars'];
    freeDrinks = json['freeDrinks'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']);
    if (json['birthDate'] != null) {
      birthDate = DateTime.fromMillisecondsSinceEpoch(json['birthDate']);
    }
    gender = json['gender'];

    if (json['favs'] != null) {
      fav = <Fav>[];
      json['favs'].forEach((v) {
        fav!.add(Fav.fromJson(v));
      });
    }

    if (json['cart'] != null) {
      cart = <CartItem>[];
      json['cart'].forEach((v) {
        cart!.add(CartItem.fromJson(v));
      });
    }
  }

  StarUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? imageUrl,
    bool? userAgreement,
    bool? offers,
    DateTime? createdAt,
    DateTime? birthDate,
    String? gender,
    List<Fav>? fav,
    List<CartItem>? cart,
  }) {
    return StarUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      userAgreement: userAgreement ?? this.userAgreement,
      offers: offers ?? this.offers,
      memberType: memberType ?? this.memberType,
      totalStars: totalStars ?? this.totalStars,
      freeDrinks: freeDrinks ?? this.freeDrinks,
      createdAt: createdAt ?? this.createdAt,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      fav: fav ?? this.fav,
      cart: cart ?? this.cart,
    );
  }
}

class Fav {
  String? id;
  String? name;
  String? imageUrl;

  Fav({this.id, this.name, this.imageUrl});

  Fav.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class CartItem {
  int? cartId;
  String? id;
  String? name;
  String? imageUrl;
  double? price;
  int? quantity;
  double? totalPrice;
  String? size;

  CartItem({
    this.cartId,
    required this.id,
    required this.name,
    required this.imageUrl,
    this.price,
    this.quantity,
    this.totalPrice,
    this.size,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    price = ((json['price'] as num)).toDouble();
    quantity = json['quantity'];
    totalPrice = ((json['totalPrice'] as num)).toDouble();
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartId'] = cartId;
    data['id'] = id;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['price'] = price;
    data['quantity'] = quantity;
    data['totalPrice'] = totalPrice;
    data['size'] = size;
    return data;
  }

  CartItem copyWith({
    int? cartId,
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    double? totalPrice,
    String? size,
  }) {
    return CartItem(
      cartId: cartId ?? this.cartId,
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      size: size ?? this.size,
    );
  }
}
