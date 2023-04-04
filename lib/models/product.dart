class Product {
  String? name;
  String? description;
  String? imageUrl;
  double? rank;
  String? cat;
  String? cat2;
  List<SizeOption>? sizeOptions;
  String? id;
  double? price;
  String? calories;
  String? type;

  Product({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rank,
    required this.cat,
    required this.cat2,
    this.sizeOptions,
    this.price,
    this.calories,
    this.type,
  });

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    rank = ((json['rank'] as num)).toDouble();
    cat = json['cat'];
    cat2 = json['cat2'];
    if (json['sizeOptions'] != null) {
      sizeOptions = <SizeOption>[];
      json['sizeOptions'].forEach((v) {
        sizeOptions!.add(SizeOption.fromJson(v));
      });
    }
    if (json['price'] != null) {
      price = ((json['price'] as num)).toDouble();
    }
    if (json['calories'] != null) {
      calories = json['calories'];
    }
    if (json['type'] != null) {
      type = json['type'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['rank'] = rank;
    data['cat'] = cat;
    data['cat2'] = cat2;
    if (sizeOptions != null) {
      data['favs'] = sizeOptions!.map((v) => v.toJson()).toList();
    }
    if (price != null) {
      data['price'] = price;
    }

    if (calories != null) {
      data['calories'] = calories;
    }
    if (type != null) {
      data['type'] = type;
    }

    return data;
  }
}

class SizeOption {
  String? calories;
  double? price;
  String? size;

  SizeOption({required this.calories, required this.price, required this.size});

  SizeOption.fromJson(Map<String, dynamic> json) {
    calories = json['calories'];
    price = ((json['price'] as num)).toDouble();
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['calories'] = calories;
    data['price'] = price;
    data['size'] = size;
    return data;
  }
}
