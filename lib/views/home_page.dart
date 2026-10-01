import 'package:flutter/material.dart';

import '../models/data.dart';
import 'detail.dart';
import 'profile.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.user, required this.onLogout});

  // Data user yang sudah login.
  final User user;

  // Fungsi untuk logout saat user menekan tombol logout di profil.
  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // Index tab aktif pada bottom navigation.
  int _selectedIndex = 0;

  // Menyimpan ID menu yang disukai. Menggunakan Set agar tidak ada duplikasi.
  final Set<int> _favoriteIds = {};

  @override
  Widget build(BuildContext context) {
    // Jika index 1, artinya sedang menampilkan halaman profil.
    final isProfile = _selectedIndex == 1;

    return Scaffold(
      // AppBar atas menampilkan judul halaman dan avatar user di menu.
      appBar: AppBar(
        title: Text(isProfile ? 'Profil' : 'Katalog'),
        actions: [
          if (!isProfile)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFFFE9E4),
                child: Text(
                  // Ambil huruf pertama username untuk avatar.
                  widget.user.username[0].toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFC92836),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      // body berisi halaman yang dipilih dari bottom nav.
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Halaman katalog menu.
          MenuCatalogPage(
            favoriteIds: _favoriteIds,
            // Callback yang dipanggil saat menu favorit berubah.
            onFavoriteChanged: (menu, isFavorite) {
              setState(() {
                if (isFavorite) {
                  _favoriteIds.add(menu.id);
                } else {
                  _favoriteIds.remove(menu.id);
                }
              });
            },
          ),
          // Halaman profil user.
          ProfilePage(user: widget.user, onLogout: widget.onLogout),
        ],
      ),
      // Navigasi bawah untuk pindah antara menu dan profil.
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class MenuCatalogPage extends StatefulWidget {
  const MenuCatalogPage({
    super.key,
    required this.favoriteIds,
    required this.onFavoriteChanged,
  });

  // Menu yang sedang disukai oleh user.
  final Set<int> favoriteIds;

  // Callback untuk memperbarui status favorit saat user menekan ikon hati.
  final void Function(Menu menu, bool isFavorite) onFavoriteChanged;

  @override
  State<MenuCatalogPage> createState() => _MenuCatalogPageState();
}

class _MenuCatalogPageState extends State<MenuCatalogPage> {
  // Controller untuk membaca input dari field pencarian.
  final _searchController = TextEditingController();

  // Kategori aktif saat ini, defaultnya 'Semua' untuk menampilkan semua menu.
  String _selectedCategory = 'Semua';

  // Jika true, hanya menampilkan menu yang masuk favorit.
  bool _showFavoritesOnly = false;

  @override
  void dispose() {
    // Membersihkan controller agar tidak menyebabkan memory leak.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil input pencarian lalu lowercase agar pencarian tidak sensitif huruf besar/kecil.
    final query = _searchController.text.toLowerCase().trim();

    // Filter menu berdasarkan pencarian, kategori, dan status favorit.
    final filteredMenus = menus.where((menu) {
      final matchesSearch =
          menu.name.toLowerCase().contains(query) ||
          menu.category.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == 'Semua' || menu.category == _selectedCategory;
      final matchesFavorite =
          !_showFavoritesOnly || widget.favoriteIds.contains(menu.id);

      return matchesSearch && matchesCategory && matchesFavorite;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul utama katalog.
              Text(
                'Ada yang bikin ngiler?',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              // Kolom pencarian menu.
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari menu favorit',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: _showFavoritesOnly
                        ? 'Tampilkan semua menu'
                        : 'Tampilkan favorit',
                    onPressed: () => setState(
                      () => _showFavoritesOnly = !_showFavoritesOnly,
                    ),
                    icon: Icon(
                      _showFavoritesOnly
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _showFavoritesOnly
                          ? const Color(0xFFC92836)
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tombol kategori yang bisa dipilih user.
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['Semua', 'Mie', 'Dimsum', 'Minuman'].map((
                    category,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = category),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Daftar menu yang sudah difilter.
        Expanded(
          child: filteredMenus.isEmpty
              ? const Center(child: Text('Menu tidak ditemukan'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: filteredMenus.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final menu = filteredMenus[index];
                    final isFavorite = widget.favoriteIds.contains(menu.id);

                    return MenuTile(
                      menu: menu,
                      isFavorite: isFavorite,
                      onFavoritePressed: () =>
                          widget.onFavoriteChanged(menu, !isFavorite),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          // Saat item menu diklik, buka halaman detailnya.
                          builder: (_) => MenuDetailPage(
                            menu: menu,
                            isFavorite: isFavorite,
                            onFavoriteChanged: (value) =>
                                widget.onFavoriteChanged(menu, value),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.menu,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onTap,
  });

  // Data menu yang ditampilkan dalam satu item list.
  final Menu menu;

  // Apakah menu ini sudah masuk favorit atau belum.
  final bool isFavorite;

  // Fungsi saat tombol hati ditekan.
  final VoidCallback onFavoritePressed;

  // Fungsi saat item card diklik.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Gambar menu di sisi kiri card.
              MenuImage(image: menu.image, width: 76, height: 76),
              const SizedBox(width: 13),

              // Informasi utama menu: nama, kategori, harga.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      menu.category,
                      style: const TextStyle(color: Color(0xFF77716B)),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      menu.price,
                      style: const TextStyle(
                        color: Color(0xFFC92836),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol favorit untuk menambah atau menghapus dari favorit.
              IconButton(
                tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah favorit',
                onPressed: onFavoritePressed,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? const Color(0xFFC92836) : Colors.black45,
                ),
              ),

              // Ikon panah untuk memberi tanda bahwa item dapat dibuka detail.
              const Icon(Icons.chevron_right, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
