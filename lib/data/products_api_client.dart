import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductsApiClient {
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection('starproducts');

  List<Product> productList = [];

  Future<List<Product>> fetchProductsData(String cat, String subCat) async => await _productsRef.where('cat', isEqualTo: cat).where('cat2', isEqualTo: subCat).get().then((snapshot) {
        productList.clear();
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Product product = Product.fromJson(data);
          product.id = document.id;
          //print(product.id);
          productList.add(product);
        }
        return productList;
      });

  Future<List<Product>> fetchFeaturedProductsData() async => await _productsRef.where('featured', isEqualTo: true).get().then((snapshot) {
        productList.clear();
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Product product = Product.fromJson(data);
          product.id = document.id;
          print(product.id);
          productList.add(product);
        }
        return productList;
      });
}
