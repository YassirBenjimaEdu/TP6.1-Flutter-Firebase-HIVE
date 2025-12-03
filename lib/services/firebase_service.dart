import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class FirebaseService {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  // Stream des produits en temps réel
  Stream<List<Product>> streamProducts() {
    return productsRef.snapshots().map((snap) {
      return snap.docs
          .map(
            (d) => Product.fromMap(
              d.id,
              d.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Future<void> addProduct(Product p) => productsRef.add(p.toMap());

  Future<void> deleteProduct(String id) => productsRef.doc(id).delete();
}


