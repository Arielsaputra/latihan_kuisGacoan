class User {
  String username;
  String password;
  String name;

  User({required this.username, required this.password, required this.name});
}

User user1 = User(
  username: "Ariel saputra",
  password: "124240010",
  name: "Ariel saputra",
);

class Menu {
  int id;
  String name;
  String category;
  String description;
  String price;
  String image;

  Menu({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.image,
  });
}

final List<Menu> menus = [
  Menu(
    id: 1,
    name: "Mie Gacoan",
    category: "Mie",
    price: "Rp.12000",
    image: "https://images.unsplash.com/photo-1569718212165-3a8278d5f624",
    description: "Mie pedas dengan pilihan level dan cita rasa khas Gacoan.",
  ),
  Menu(
    id: 2,
    name: "Mie Hompimpa",
    category: "Mie",
    price: "Rp.12000",
    image: "https://images.unsplash.com/photo-1552611052-33e04de081de",
    description: "Mie dengan cita rasa gurih dan pedas.",
  ),
  Menu(
    id: 3,
    name: "Mie Suit",
    category: "Mie",
    price: "Rp.12000",
    image: "https://images.unsplash.com/photo-1569718212165-3a8278d5f624",
    description: "Mie dengan cita rasa gurih yang lebih ringan.",
  ),
  Menu(
    id: 4,
    name: "Udang Keju",
    category: "Dimsum",
    price: "Rp.12000",
    image: "https://images.unsplash.com/photo-1496116218417-1a781b1c416c",
    description: "Dimsum udang dengan isian keju yang gurih.",
  ),
  Menu(
    id: 5,
    name: "Udang Rambutan",
    category: "Dimsum",
    price: "Rp.12000",
    image: "https://images.unsplash.com/photo-1496116218417-1a781b1c416c",
    description: "Dimsum udang dengan balutan kulit renyah.",
  ),
  Menu(
    id: 6,
    name: "Pangsit Goreng",
    category: "Dimsum",
    price: "Rp.12000",
    image: "https://images.unsplash.com/photo-1496116218417-1a781b1c416c",
    description: "Pangsit goreng dengan tekstur renyah dan gurih.",
  ),
  Menu(
    id: 7,
    name: "Es Gobak Sodor",
    category: "Minuman",
    price: "Rp.9000",
    image: "https://images.unsplash.com/photo-1556679343-c7306c1976bc",
    description: "Minuman segar dengan rasa manis dan menyegarkan.",
  ),
  Menu(
    id: 8,
    name: "Es Teklek",
    category: "Minuman",
    price: "Rp.9000",
    image: "https://images.unsplash.com/photo-1556679343-c7306c1976bc",
    description: "Minuman segar yang cocok dinikmati bersama menu Gacoan.",
  ),
  Menu(
    id: 9,
    name: "Es Tea",
    category: "Minuman",
    price: "Rp.6000",
    image: "https://images.unsplash.com/photo-1556679343-c7306c1976bc",
    description: "Es teh segar dengan rasa manis dan menyegarkan.",
  ),
];
