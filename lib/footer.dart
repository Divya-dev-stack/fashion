import 'package:flutter/material.dart';

import 'shop_page.dart';
import 'class_page.dart';
import 'custom_order_page.dart';
import 'catering_page.dart';
import 'contact.dart';

class Footer extends StatelessWidget {
  /// Home page-la laptop-la mattum footer kaatta true kudunga.
  final bool hideOnMobile;

  const Footer({super.key, this.hideOnMobile = false});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;

    if (hideOnMobile && !isDesktop) {
      return const SizedBox(height: 24);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 35,
      ),
      color: const Color(0xff0F766E),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _brand(CrossAxisAlignment.start)),
                        Expanded(flex: 2, child: _quickLinks(context)),
                        Expanded(flex: 2, child: _categoryLinks(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _brand(CrossAxisAlignment.center),
                        const SizedBox(height: 25),
                        _quickLinks(context, center: true),
                      ],
                    ),
              const SizedBox(height: 25),
              const Divider(color: Colors.white38),
              const SizedBox(height: 15),
              const Text(
                "© 2026 Sumathi's Styles. All Rights Reserved.",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brand(CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image.asset(
              "assets/images/app.png",
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.storefront, color: Color(0xff0F766E)),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Sumathi's Styles",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Fashion Designing Boutique",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        // TODO: inga phone / address add pannalaam
      ],
    );
  }

  Widget _quickLinks(BuildContext context, {bool center = false}) {
    return _column(
      context,
      'Quick Links',
      {
        'Shop': () => _go(context, const ShopPage()),
        'Classes': () => _go(context, const ClassPage()),
        'Custom Order': () => _go(context, const CustomOrderPage()),
        'Catering': () => _go(context, const CateringPage()),
        'Contact': () => _go(context, const ContactPage()),
      },
      center: center,
    );
  }

  Widget _categoryLinks(BuildContext context) {
    const cats = [
      'Kids Wear',
      'Uniform',
      'Blouse',
      'Aari Work',
      'Lehenga',
      'Kurthi',
    ];
    return _column(
      context,
      'Categories',
      {
        for (final c in cats)
          c: () => _go(context, ShopPage(initialFilter: c)),
      },
    );
  }

  Widget _column(
    BuildContext context,
    String title,
    Map<String, VoidCallback> links, {
    bool center = false,
  }) {
    final links0 = links.entries.map((e) {
      return InkWell(
        onTap: e.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Text(
            e.key,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
    }).toList();

    if (center) {
      return Wrap(alignment: WrapAlignment.center, spacing: 12, children: links0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ...links0,
      ],
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}