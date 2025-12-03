import 'package:flutter/material.dart';

import '../services/hive_service.dart';
import '../services/firebase_service.dart';
import '../models/product.dart';
import 'cart_page.dart';
import 'favorite_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final firebaseService = FirebaseService(); // Firebase Firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      // --- Affichage en temps réel depuis Firestore
      body: StreamBuilder<List<Product>>(
        stream: firebaseService.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Affiche le message d'erreur Firebase à l'écran
            return Center(
              child: Text(
                'Erreur Firebase : ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(child: Text('Aucun produit'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, i) {
              final p = products[i];
              final isFav = HiveService.isFavorite(p.id);
              return Card(
                child: ListTile(
                  leading: p.image.isEmpty
                      ? const Icon(Icons.image)
                      : Image.network(p.image, width: 50, height: 50),
                  title: Text(p.name),
                  subtitle: Text('${p.price} MAD'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- Favoris
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : null,
                        ),
                        onPressed: () {
                          HiveService.toggleFavorite(p.id);
                          setState(() {});
                        },
                      ),
                      // --- Ajouter au panier
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          HiveService.addToCart(p);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Produit ajouté au panier'),
                            ),
                          );
                        },
                      ),
                      // --- Supprimer produit
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          HiveService.deleteProduct(p.id); // Hive local
                          firebaseService.deleteProduct(p.id); // Firestore
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // --- Ajouter un nouveau produit
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final products = HiveService.getAllProducts();
          final newProduct = Product(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'Produit ${products.length + 1}',
            price: 10 + products.length.toDouble(),
            image: 'https://picsum.photos/200?random=${products.length + 1}',
          );
          HiveService.addProduct(newProduct); // Hive
          await firebaseService.addProduct(newProduct); // Firestore
          setState(() {});
        },
      ),
    );
  }
}
