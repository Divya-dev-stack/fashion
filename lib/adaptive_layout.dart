// adaptive_layout.dart
// Put this in lib/ and import it wherever needed:
//   import 'adaptive_layout.dart';
//
// Rule:
//   Website on laptop (kIsWeb + wide screen)  -> WEBSITE layout
//   Installed app / phone / narrow browser    -> APP layout

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// 1. CORE HELPER  (use this everywhere instead of checking width yourself)
// ---------------------------------------------------------------------------
class Adaptive {
  static double width(BuildContext c) => MediaQuery.of(c).size.width;

  /// true  -> show website layout (laptop browser)
  /// false -> show app layout (installed app or phone)
  static bool isWebLayout(BuildContext c) => kIsWeb && width(c) >= 700;

  static bool isAppLayout(BuildContext c) => !isWebLayout(c);

  /// Number of grid columns: app = 2, web = 3 / 4 / 5 by screen width
  static int gridCount(BuildContext c) {
    if (isAppLayout(c)) return 2;
    final w = width(c);
    if (w >= 1300) return 5;
    if (w >= 1000) return 4;
    return 3;
  }

  /// Max width of page content on website
  static double maxWidth(BuildContext c) {
    final w = width(c);
    if (w >= 1300) return 1280;
    if (w >= 1100) return 1100;
    return w;
  }

  /// Use for page AppBar: hides it on website (top navbar is already there)
  ///   appBar: Adaptive.pageAppBar(context, AppBar(title: Text('Cart')))
  static PreferredSizeWidget? pageAppBar(BuildContext c, PreferredSizeWidget bar) {
    return isWebLayout(c) ? null : bar;
  }
}

// ---------------------------------------------------------------------------
// 2. AdaptivePage  -> wrap ANY page body with this
//    App     : returns child as it is (no change)
//    Website : centers content with max width
//
//    body: AdaptivePage(child: YourExistingBody())
// ---------------------------------------------------------------------------
class AdaptivePage extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  const AdaptivePage({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    if (Adaptive.isAppLayout(context)) return child;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: maxWidth ?? Adaptive.maxWidth(context)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. AdaptiveGrid -> columns change automatically (app 2, laptop 4-5)
//
//    AdaptiveGrid(
//      aspectRatio: 0.75,
//      children: products.map((p) => ProductCard(p)).toList(),
//    )
// ---------------------------------------------------------------------------
class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double aspectRatio;
  final double spacing;
  final bool shrinkWrap; // true when placed inside a scroll view / Column
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.aspectRatio = 0.75,
    this.spacing = 12,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: Adaptive.gridCount(context),
      childAspectRatio: aspectRatio,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      children: children,
    );
  }
}

// ---------------------------------------------------------------------------
// 4. AdaptiveBuilder -> totally different UI for web and app (optional)
//
//    AdaptiveBuilder(app: MobileView(), web: WebView())
// ---------------------------------------------------------------------------
class AdaptiveBuilder extends StatelessWidget {
  final Widget app;
  final Widget web;
  const AdaptiveBuilder({super.key, required this.app, required this.web});

  @override
  Widget build(BuildContext context) =>
      Adaptive.isWebLayout(context) ? web : app;
}

// ---------------------------------------------------------------------------
// 5. AdaptiveNavShell -> main navigation
//    Website : top navbar (Home, Shop, Service, Profile, Login, Cart)
//    App     : bottom navigation bar
//    Pages are automatically centered on website.
//
//    Use it inside your MainNavPage build():
//
//    return AdaptiveNavShell(
//      title: "Sumathi's Styles",
//      currentIndex: _index,
//      onChanged: (i) => setState(() => _index = i),
//      destinations: const [
//        NavDest('Home', Icons.home_outlined),
//        NavDest('Shop', Icons.storefront_outlined),
//        NavDest('Service', Icons.design_services_outlined),
//        NavDest('Profile', Icons.person_outline),
//      ],
//      pages: [HomePage(), ShopPage(), ServicePage(), ProfilePage()],
//      onLogin: () {},
//      onCart: () {},
//    );
// ---------------------------------------------------------------------------
class NavDest {
  final String label;
  final IconData icon;
  const NavDest(this.label, this.icon);
}

class AdaptiveNavShell extends StatelessWidget {
  final String title;
  final Widget? logo;
  final Color color;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<NavDest> destinations;
  final List<Widget> pages;
  final VoidCallback? onLogin; // set null if user already logged in
  final VoidCallback? onCart;

  const AdaptiveNavShell({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.onChanged,
    required this.destinations,
    required this.pages,
    this.logo,
    this.color = const Color(0xFF008080),
    this.onLogin,
    this.onCart,
  });

  @override
  Widget build(BuildContext context) {
    final web = Adaptive.isWebLayout(context);

    if (web) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: _webBar(context),
        ),
        body: AdaptivePage(child: pages[currentIndex]),
      );
    }

    // APP layout
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onChanged,
        destinations: [
          for (final d in destinations)
            NavigationDestination(icon: Icon(d.icon), label: d.label),
        ],
      ),
    );
  }

  Widget _webBar(BuildContext context) {
    return Material(
      color: color,
      elevation: 4,
      child: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: Adaptive.maxWidth(context) + 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                logo ??
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.storefront, color: Color(0xFF008080)),
                    ),
                const SizedBox(width: 12),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                for (int i = 0; i < destinations.length; i++)
                  InkWell(
                    onTap: () => onChanged(i),
                    child: Container(
                      height: 68,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: currentIndex == i
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        destinations[i].label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: currentIndex == i
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                if (onLogin != null)
                  TextButton(
                    onPressed: onLogin,
                    child: const Text('Login',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                if (onCart != null)
                  IconButton(
                    onPressed: onCart,
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}