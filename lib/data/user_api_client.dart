import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starbucksapp/models/user.dart';

class UserApiClient {
  final CollectionReference _usersRef = FirebaseFirestore.instance.collection('starusers');

  Future addUserToDatabase(StarUser user) async {
    final docUser = _usersRef.doc(user.id);
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json).then((value) => debugPrint('New User added!')).catchError((error) => debugPrint('Error!!!'));
  }

  Future<StarUser?> fetchUserData(String id) async {
    final docUser = _usersRef.doc(id);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return StarUser.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUserData(StarUser user) async {
    final docUser = _usersRef.doc(user.id);
    final updatedData = user.toJson();
    docUser.update(updatedData);
  }

  addProductToUserCart(String id, CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance.collection('starusers').doc(id).get();
    final myUser = StarUser.fromJson(snapshot.data()!);
    myUser.cart ??= [];
    myUser.cart!.add(cartItem);
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('starusers').doc(id).update({'cart': updatedData['cart']});
  }

  updateProductsOnUserCart(String id, List<CartItem> cartItems) async {
    final snapshot = await FirebaseFirestore.instance.collection('starusers').doc(id).get();
    final myUser = StarUser.fromJson(snapshot.data()!);
    myUser.cart = cartItems;
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('starusers').doc(id).update({'cart': updatedData['cart']});
  }

  updateProductOnUserCart(String id, CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance.collection('starusers').doc(id).get();
    final myUser = StarUser.fromJson(snapshot.data()!);
    myUser.cart ??= [];

    for (int i = 0; i < myUser.cart!.length; i++) {
      //print('${cartItem.cartId} ${myUser.cart![i].cartId}');
      if (cartItem.id == myUser.cart![i].id && cartItem.cartId == myUser.cart![i].cartId) {
        myUser.cart![i] = cartItem;
        print('updated!!!');
      }
    }
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('starusers').doc(id).update({'cart': updatedData['cart']});
  }

  deleteProductFromUserCart(String id, CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance.collection('starusers').doc(id).get();
    final myUser = StarUser.fromJson(snapshot.data()!);
    myUser.cart ??= [];
    //myUser.cart!.removeAt(index);
    for (int i = 0; i < myUser.cart!.length; i++) {
      if (cartItem.id == myUser.cart![i].id) {
        myUser.cart!.removeAt(i);
        print('deleted!!!');
      }
    }
    final updatedData = myUser.toJson();
    await FirebaseFirestore.instance.collection('starusers').doc(id).update({'cart': updatedData['cart']});
  }
}
