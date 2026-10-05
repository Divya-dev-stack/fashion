import 'package:flutter/material.dart';
import 'responsive.dart';
import 'home_page.dart';

class WebShell extends StatelessWidget {
  const WebShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _WebHeader(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: const HomePage(),
        ),
      ),
    );
  }
}

class _WebHeader extends StatelessWidget implements PreferredSizeWidget {
  const _WebHeader();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final desktop = Responsive.isDesktop(context);
    return Material(
      color: const Color(0xFF008080),
      elevation: 2,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Image.asset('assets/images/cir.png', height: 40),
                const SizedBox(width: 24),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for sarees, blouses, custom stitching...',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                if (desktop)
                  TextButton(
                    onPressed: () {},
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}