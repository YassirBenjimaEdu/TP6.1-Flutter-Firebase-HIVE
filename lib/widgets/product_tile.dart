import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAddCart;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;
  final VoidCallback? onTap;

  const ProductTile({
    super.key,
    required this.product,
    required this.onAddCart,
    required this.onToggleFavorite,
    required this.isFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: product.image.isNotEmpty
          ? Image.network(
              product.image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            )
          : Container(width: 56, height: 56, color: Colors.grey),
      title: Text(product.name),
      subtitle: Text('${product.price.toStringAsFixed(2)} MAD'),
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: onToggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: onAddCart,
          ),
        ],
      ),
    );
  }
}


