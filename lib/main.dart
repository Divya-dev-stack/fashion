import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------------------------------
// COLORS
// ---------------------------------------------------------------------------
const kTeal = Color(0xFF008080);
const kTealDark = Color(0xFF006B6B);
const kCopper = Color(0xFFB87333);
const kBg = Color(0xFFF0FFF4);

// ---------------------------------------------------------------------------
// RESPONSIVE HELPER
// ---------------------------------------------------------------------------
class Responsive {
  static double width(BuildContext c) => MediaQuery.of(c).size.width;

  static bool isMobile(BuildContext c) => width(c) < 700;
  static bool isTablet(BuildContext c) => width(c) >= 700 && width(c) < 1100;
  static bool isDesktop(BuildContext c) => width(c) >= 1100;

  static int gridCount(BuildContext c) {
    final w = width(c);
    if (w >= 1300) return 5;
    if (w >= 1000) return 4;
    if (w >= 700) return 3;
    return 2;
  }

  static double maxContentWidth(BuildContext c) {
    final w = width(c);
    if (w >= 1300) return 1280;
    if (w >= 1100) return 1100;
    return w;
  }
}

// ---------------------------------------------------------------------------
// APP
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sumathi's Styles",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kTeal),
        scaffoldBackgroundColor: kBg,
      ),
      home: const MainShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// PAGE CONTAINER (centers content + max width on laptop)
// ---------------------------------------------------------------------------
class PageContainer extends StatelessWidget {
  final Widget child;
  const PageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 12 : 32,
            vertical: 16,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MAIN SHELL (navbar on laptop, bottom nav on mobile)
// ---------------------------------------------------------------------------
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _titles = ['Home', 'Shop', 'Service', 'Profile'];
  static const _icons = [
    Icons.home_outlined,
    Icons.storefront_outlined,
    Icons.design_services_outlined,
    Icons.person_outline,
  ];

  final _pages = const [HomePage(), ShopPage(), ServicePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: mobile ? _mobileAppBar() : _webNavBar(context),
      body: _pages[_index],
      bottomNavigationBar: mobile
          ? NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: List.generate(
                4,
                (i) => NavigationDestination(
                  icon: Icon(_icons[i]),
                  label: _titles[i],
                ),
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _mobileAppBar() {
    return AppBar(
      backgroundColor: kTeal,
      foregroundColor: Colors.white,
      title: const Text("Sumathi's Styles",
          style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined)),
      ],
    );
  }

  PreferredSizeWidget _webNavBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68),
      child: Material(
        color: kTeal,
        elevation: 4,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: Responsive.maxContentWidth(context) + 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.checkroom, color: kTeal),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Sumathi's Styles",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  for (int i = 0; i < _titles.length; i++)
                    _NavItem(
                      label: _titles[i],
                      selected: _index == i,
                      onTap: () => setState(() => _index = i),
                    ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Login',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? Colors.white : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DEMO DATA  (unga real product data vechu replace pannunga)
// ---------------------------------------------------------------------------
class Product {
  final String name;
  final double price;
  final IconData icon;
  const Product(this.name, this.price, this.icon);
}

const demoProducts = [
  Product('Silk Saree', 2499, Icons.checkroom),
  Product('Cotton Kurti', 799, Icons.dry_cleaning),
  Product('Blouse Design', 1299, Icons.style),
  Product('Lehenga', 4999, Icons.auto_awesome),
  Product('Anarkali Set', 1899, Icons.checkroom),
  Product('Kids Frock', 599, Icons.child_care),
  Product('Dupatta', 399, Icons.dry_cleaning),
  Product('Palazzo Set', 999, Icons.style),
  Product('Party Gown', 3499, Icons.auto_awesome),
  Product('Casual Top', 499, Icons.checkroom),
];

// ---------------------------------------------------------------------------
// PRODUCT CARD
// ---------------------------------------------------------------------------
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: kTeal.withOpacity(0.08),
                child: Icon(product.icon, size: 56, color: kTeal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: kCopper,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget productGrid(BuildContext context, List<Product> items) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: Responsive.gridCount(context),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.78,
    ),
    itemCount: items.length,
    itemBuilder: (_, i) => ProductCard(items[i]),
  );
}

// ---------------------------------------------------------------------------
// HOME PAGE
// ---------------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return SingleChildScrollView(
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(mobile ? 20 : 48),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [kTeal, kTealDark]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Collections Are Here',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: mobile ? 22 : 38,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Custom stitching, designer wear and more.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: mobile ? 14 : 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kCopper,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                    ),
                    onPressed: () {},
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text('Featured Products',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            productGrid(context, demoProducts.take(5).toList()),
            const SizedBox(height: 32),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SHOP PAGE
// ---------------------------------------------------------------------------
class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shop',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            productGrid(context, demoProducts),
            const SizedBox(height: 32),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SERVICE PAGE
// ---------------------------------------------------------------------------
class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    const services = [
      ('Custom Stitching', Icons.content_cut),
      ('Alterations', Icons.straighten),
      ('Embroidery', Icons.brush),
      ('Bridal Wear', Icons.favorite_border),
    ];
    return SingleChildScrollView(
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Our Services',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: Responsive.isMobile(context) ? 1.1 : 1.4,
              children: [
                for (final s in services) QuickCard(icon: s.$2, label: s.$1),
              ],
            ),
            const SizedBox(height: 32),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PROFILE PAGE (unga screenshot maadhiri)
// ---------------------------------------------------------------------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return SingleChildScrollView(
      child: PageContainer(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [kTeal, kTealDark]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white24,
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 34),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Guest User',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Not logged in',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kCopper,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick cards
            GridView.count(
              crossAxisCount: mobile ? 2 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: mobile ? 1.2 : 1.8,
              children: const [
                QuickCard(icon: Icons.inventory_2_outlined, label: 'Orders'),
                QuickCard(icon: Icons.favorite_border, label: 'Wishlist'),
                QuickCard(
                    icon: Icons.monetization_on_outlined,
                    label: 'Super Coins',
                    color: kCopper),
                QuickCard(icon: Icons.headset_mic_outlined, label: 'Drop Your Idea'),
              ],
            ),
            const SizedBox(height: 20),

            _SectionCard(title: 'MY SHOPPING', items: const [
              _Item(Icons.inventory_2_outlined, 'My Orders', kTeal),
              _Item(Icons.favorite_border, 'My Wishlist', Colors.red),
            ]),
            const SizedBox(height: 16),
            _SectionCard(title: 'ACCOUNT SETTINGS', items: const [
              _Item(Icons.phone_android, 'Manage Devices', kTeal),
              _Item(Icons.edit, 'Edit Profile', kTeal),
              _Item(Icons.notifications_none, 'Notification Settings', kCopper),
            ]),
            const SizedBox(height: 32),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

class QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const QuickCard(
      {super.key, required this.icon, required this.label, this.color = kTeal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final String title;
  final Color color;
  const _Item(this.icon, this.title, this.color);
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<_Item> items;
  const _SectionCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey)),
            ),
            for (final it in items)
              ListTile(
                leading: Icon(it.icon, color: it.color),
                title: Text(it.title),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () {},
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FOOTER (website feel)
// ---------------------------------------------------------------------------
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kTeal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Text("Sumathi's Styles",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('© 2026 Sumathi\'s Styles. All rights reserved.',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}