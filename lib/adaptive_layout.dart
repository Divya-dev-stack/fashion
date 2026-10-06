// adaptive_layout.dart
//
// Central responsive layout system for the whole app.
//
// Website:
//   Flutter Web + screen width >= 700
//
// App:
//   Installed app / phone / narrow browser
//
// Use this file only where Adaptive / AdaptivePage / AdaptiveGrid
// is actually needed.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class Adaptive {
  /// Current screen width.
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// True when running as a wide website.
  static bool isWebLayout(BuildContext context) {
    return kIsWeb && width(context) >= 700;
  }

  /// True for mobile / installed app / narrow browser.
  static bool isAppLayout(BuildContext context) {
    return !isWebLayout(context);
  }

  /// Grid columns.
  ///
  /// App:
  ///   2 columns
  ///
  /// Website:
  ///   3 columns -> smaller laptop
  ///   4 columns -> medium desktop
  ///   5 columns -> large desktop
  static int gridCount(BuildContext context) {
    if (isAppLayout(context)) {
      return 2;
    }

    final w = width(context);

    if (w >= 1400) {
      return 5;
    }

    if (w >= 1050) {
      return 4;
    }

    return 3;
  }

  /// Main website content width.
  ///
  /// This is intentionally wider so pages don't get trapped
  /// inside a small ~800px desktop container.
  static double maxWidth(BuildContext context) {
    final w = width(context);

    if (w >= 1600) {
      return 1400;
    }

    if (w >= 1300) {
      return 1250;
    }

    if (w >= 1000) {
      return 1100;
    }

    return w;
  }

  /// App pages can keep their own AppBar.
  /// Website already has the top navigation bar.
  static PreferredSizeWidget? pageAppBar(
    BuildContext context,
    PreferredSizeWidget bar,
  ) {
    return isWebLayout(context) ? null : bar;
  }
}

// ---------------------------------------------------------------------------
// AdaptivePage
// ---------------------------------------------------------------------------

class AdaptivePage extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const AdaptivePage({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (Adaptive.isAppLayout(context)) {
      return child;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Adaptive.maxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AdaptiveGrid
// ---------------------------------------------------------------------------

class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double aspectRatio;
  final double spacing;
  final bool shrinkWrap;

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
      physics: shrinkWrap
          ? const NeverScrollableScrollPhysics()
          : null,
      children: children,
    );
  }
}

// ---------------------------------------------------------------------------
// AdaptiveBuilder
// ---------------------------------------------------------------------------

class AdaptiveBuilder extends StatelessWidget {
  final Widget app;
  final Widget web;

  const AdaptiveBuilder({
    super.key,
    required this.app,
    required this.web,
  });

  @override
  Widget build(BuildContext context) {
    return Adaptive.isWebLayout(context) ? web : app;
  }
}

// ---------------------------------------------------------------------------
// Navigation
// ---------------------------------------------------------------------------

class NavDest {
  final String label;
  final IconData icon;

  const NavDest(
    this.label,
    this.icon,
  );
}

// ---------------------------------------------------------------------------
// AdaptiveNavShell
// ---------------------------------------------------------------------------

class AdaptiveNavShell extends StatelessWidget {
  final String title;
  final Widget? logo;
  final Color color;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<NavDest> destinations;
  final List<Widget> pages;
  final VoidCallback? onLogin;
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
          preferredSize: const Size.fromHeight(72),
          child: _webBar(context),
        ),
        body: AdaptivePage(
          maxWidth: Adaptive.maxWidth(context),
          child: pages[currentIndex],
        ),
      );
    }

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onChanged,
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              label: d.label,
            ),
        ],
      ),
    );
  }

  Widget _webBar(BuildContext context) {
    return Material(
      color: color,
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
                logo ??
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.storefront,
                        color: Color(0xFF008080),
                      ),
                    ),

                const SizedBox(width: 14),

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                for (int i = 0; i < destinations.length; i++)
                  InkWell(
                    onTap: () => onChanged(i),
                    child: Container(
                      height: 72,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
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
                          fontSize: 17,
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
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                if (onCart != null)
                  IconButton(
                    onPressed: onCart,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}