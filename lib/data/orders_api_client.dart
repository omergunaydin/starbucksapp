import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart';

class OrdersApiClient {
  final CollectionReference _ordersRef = FirebaseFirestore.instance.collection('starorders');
  List<StarOrder> ordersList = [];

  Future<bool> addOrder(StarOrder order) async {
    try {
      final docMyOrder = _ordersRef.doc(order.id);
      order.id = docMyOrder.id;
      final json = order.toJson();
      await docMyOrder.set(json);

      return true;
    } catch (e) {
      print('Error adding order: $e');
      return false;
    }
  }

  Future<List<StarOrder>> fetchOrdersData(String userId) async => await _ordersRef.where('userid', isEqualTo: userId).orderBy('orderDateTime', descending: true).get().then((snapshot) {
        ordersList.clear();
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          StarOrder order = StarOrder.fromJson(data);
          order.id = document.id;
          ordersList.add(order);
        }
        return ordersList;
      });
}
