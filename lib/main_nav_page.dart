import 'package:flutter/material.dart';

import 'adaptive_layout.dart';
import 'app_colors.dart';
import 'app_state.dart';
import 'home_page.dart';
import 'shop_page.dart';
import 'catering_page.dart';
import 'settings_page.dart';
import 'cart_page.dart';
import 'login_page.dart';

/// Main application navigation.
///
/// Website:
///   Top navigation bar
///
/// App:
///   Bottom navigation bar
///
/// Tabs:
///   Home
///   Shop
///   Service
///   Profile
class MainNavPage extends StatefulWidget {
  const MainNavPage({
    super.key,
  });

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ShopPage(),
    CateringPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final bool website =
            Adaptive.isWebLayout(context);

        return Scaffold(
          backgroundColor: const Color(0xFFF0FFF5),

          appBar: website
              ? _buildDesktopHeader(context)
              : null,

          body: website
              ? _buildWebsiteBody()
              : IndexedStack(
                  index: _currentIndex,
                  children: _pages,
                ),

          bottomNavigationBar: website
              ? null
              : _buildBottomNav(),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // WEBSITE BODY
  // -------------------------------------------------------------------------

  Widget _buildWebsiteBody() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1400,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // DESKTOP HEADER
  // -------------------------------------------------------------------------

  PreferredSizeWidget _buildDesktopHeader(
    BuildContext context,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Material(
        color: AppColors.primary,
        elevation: 3,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1450,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Row(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/cir.png',
                    height: 48,
                    width: 48,
                    fit: BoxFit.contain,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.storefront,
                          color: Color(0xFF008080),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 14),

                  // Website name
                  const Text(
                    "Sumathi's Styles",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  // Navigation
                  _topLink(
                    0,
                    'Home',
                  ),

                  _topLink(
                    1,
                    'Shop',
                  ),

                  _topLink(
                    2,
                    'Service',
                  ),

                  _topLink(
                    3,
                    'Profile',
                  ),

                  // Login
                  if (!AppState.instance.isLoggedIn)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(width: 8),

                  // Cart
                  IconButton(
                    tooltip: 'Cart',
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 27,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CartPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // DESKTOP NAV ITEM
  // -------------------------------------------------------------------------

  Widget _topLink(
    int index,
    String label,
  ) {
    final bool active =
        _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active
                  ? Colors.white
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: active
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // MOBILE / APP BOTTOM NAV
  // -------------------------------------------------------------------------

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: 0.12,
            ),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              _navItem(
                0,
                Icons.home_outlined,
                Icons.home,
                'Home',
              ),
              _navItem(
                1,
                Icons.storefront_outlined,
                Icons.storefront,
                'Shop',
              ),
              _navItem(
                2,
                Icons.design_services_outlined,
                Icons.design_services,
                'Service',
              ),
              _navItem(
                3,
                Icons.person_outline,
                Icons.person,
                'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // MOBILE NAV ITEM
  // -------------------------------------------------------------------------

  Widget _navItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final bool active =
        _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              active ? activeIcon : icon,
              size: 23,
              color: active
                  ? AppColors.primary
                  : AppColors.textLight,
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: active
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: active
                    ? AppColors.primary
                    : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}