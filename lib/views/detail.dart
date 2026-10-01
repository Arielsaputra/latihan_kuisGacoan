import 'package:flutter/material.dart';

import '../models/data.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({
    super.key,
    required this.menu,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  final Menu menu;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  late bool _isFavorite = widget.isFavorite;

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Menu'),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Hapus dari favorit' : 'Tambah favorit',
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              widget.onFavoriteChanged(_isFavorite);
            },
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? const Color(0xFFC92836) : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          MenuImage(
            image: menu.image,
            width: double.infinity,
            height: 250,
            borderRadius: 22,
          ),
          const SizedBox(height: 22),
          Text(
            menu.category.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFC92836),
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            menu.name,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            menu.price,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFFC92836),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tentang menu',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            menu.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}

class MenuImage extends StatelessWidget {
  const MenuImage({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.borderRadius = 14,
  });

  final String image;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        '$image?auto=format&fit=crop&w=800&q=80',
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: width,
          height: height,
          color: const Color(0xFFFFE9E4),
          child: const Icon(
            Icons.restaurant,
            color: Color(0xFFC92836),
            size: 34,
          ),
        ),
      ),
    );
  }
}
