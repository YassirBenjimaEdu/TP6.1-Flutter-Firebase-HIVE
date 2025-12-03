import 'package:flutter/material.dart';

import '../services/hive_service.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = HiveService.getCartItems();
    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Panier vide'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, i) {
                final item = cartItems[i];
                final product =
                    HiveService.getProductById(item.productId);
                if (product == null) return const SizedBox();
                return ListTile(
                  leading: product.image.isEmpty
                      ? const Icon(Icons.image)
                      : Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                        ),
                  title: Text(product.name),
                  subtitle: Text('Quantité: ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      HiveService.removeFromCart(i);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.clear),
        onPressed: () {
          HiveService.clearCart();
          setState(() {});
        },
      ),
    );
  }
}


