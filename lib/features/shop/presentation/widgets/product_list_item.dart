import 'package:flutter/material.dart';
import '../../../product/domain/entities/product_entity.dart';

class ProductListItem extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback onLovePressed;
  final VoidCallback onCartPressed;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onLovePressed,
    required this.onCartPressed,
  });

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product name and price row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Rs.${widget.product.basePrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Love/Favorite button
                IconButton(
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    widget.onLovePressed();
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  tooltip: 'Add to favorites',
                ),
                const SizedBox(width: 8),
                // Cart button
                IconButton(
                  onPressed: widget.onCartPressed,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  tooltip: 'Add to cart',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
