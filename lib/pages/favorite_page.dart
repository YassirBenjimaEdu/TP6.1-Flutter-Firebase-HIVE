import 'package:flutter/material.dart';

import '../services/hive_service.dart';
import '../models/product.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favIds = HiveService.getFavoritesIds();
    final favProducts = favIds
        .map((id) => HiveService.getProductById(id))
        .whereType<Product>()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: favProducts.isEmpty
          ? const Center(child: Text('Aucun favori'))
          : ListView.builder(
              itemCount: favProducts.length,
              itemBuilder: (_, i) {
                final p = favProducts[i];
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
                        // Ajouter au panier
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
                        // Retirer des favoris
                        IconButton(
                          icon:
                              const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            HiveService.toggleFavorite(p.id);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}


