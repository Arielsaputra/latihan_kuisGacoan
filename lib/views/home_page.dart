import 'package:flutter/material.dart';

import '../models/data.dart';
import 'detail.dart';
import 'profile.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.user, required this.onLogout});

  final User user;
  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  final Set<int> _favoriteIds = {};

  @override
  Widget build(BuildContext context) {
    final isProfile = _selectedIndex == 1;

    return Scaffold(
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MenuCatalogPage(
            favoriteIds: _favoriteIds,
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
          ProfilePage(user: widget.user, onLogout: widget.onLogout),
        ],
      ),
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

  final Set<int> favoriteIds;
  final void Function(Menu menu, bool isFavorite) onFavoriteChanged;

  @override
  State<MenuCatalogPage> createState() => _MenuCatalogPageState();
}

class _MenuCatalogPageState extends State<MenuCatalogPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  bool _showFavoritesOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase().trim();
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
              Text(
                'Ada yang bikin ngiler?',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
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

  final Menu menu;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
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
              MenuImage(image: menu.image, width: 76, height: 76),
              const SizedBox(width: 13),
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
              IconButton(
                tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah favorit',
                onPressed: onFavoritePressed,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? const Color(0xFFC92836) : Colors.black45,
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
