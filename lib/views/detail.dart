import 'package:flutter/material.dart';

import '../models/data.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({
    super.key,
    required this.menu,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  // Data menu yang sedang dibuka dan ditampilkan detailnya.
  final Menu menu;

  // Status favorit dari menu ini, berasal dari halaman sebelumnya.
  final bool isFavorite;

  // Callback untuk memberi tahu parent bahwa status favorit berubah.
  final ValueChanged<bool> onFavoriteChanged;

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}



class _MenuDetailPageState extends State<MenuDetailPage> {
  // Membuat variabel lokal yang bisa berubah-ubah saat user menekan tombol favorit.
  late bool _isFavorite = widget.isFavorite;

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;

    return Scaffold(
      // AppBar atas halaman detail menu.
      appBar: AppBar(
        title: const Text('Detail Menu'),
        actions: [
          // Tombol favorit di pojok kanan atas.
          IconButton(
            tooltip: _isFavorite ? 'Hapus dari favorit' : 'Tambah favorit',
            onPressed: () {
              // Saat tombol diklik, ubah status favorit dan kirim hasil ke parent.
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

      // Isi halaman yang di-scroll.
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          // Gambar utama menu.
          MenuImage(
            image: menu.image,
            width: double.infinity,
            height: 250,
            borderRadius: 22,
          ),
          const SizedBox(height: 22),

          // Kategori menu, ditulis uppercase agar lebih menarik.
          Text(
            menu.category.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFC92836),
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 7),

          // Nama menu.
          Text(
            menu.name,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),

          // Harga yang ditampilkan lebih besar dan berwarna merah.
          Text(
            menu.price,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFFC92836),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),

          // Judul deskripsi menu.
          Text(
            'Tentang menu',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),

          // Deskripsi lengkap menu.
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

  // URL gambar yang akan ditampilkan.
  final String image;

  // Ukuran lebar dan tinggi gambar yang ingin dipakai.
  final double width;
  final double height;

  // Radius sudut agar gambar terlihat lebih rapi dan rounded.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        // Menambahkan parameter query agar gambar lebih rapi saat di-fetch.
        '$image?auto=format&fit=crop&w=800&q=80',
        width: width,
        height: height,
        fit: BoxFit.cover,

        // Jika gambar gagal dimuat, tampilkan placeholder dengan ikon restoran.
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
