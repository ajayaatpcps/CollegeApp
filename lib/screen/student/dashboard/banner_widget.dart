import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lbef/view_model/banner_view_model.dart';
import 'package:provider/provider.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Fetch banners once after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BannerViewModel >(context, listen: false).fetch(context);
    });

    // Auto-scroll every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;

      final bannerVM = Provider.of<BannerViewModel>(context, listen: false);
      if (_controller.hasClients && bannerVM.banner!.isNotEmpty) {
        int nextPage = (_currentPage + 1) % bannerVM.banner!.length;
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerViewModel>(
      builder: (context, bannerVM, child) {
        final bannerList = bannerVM.banner ?? [];

        // ✅ If loading or empty — show nothing
        if (bannerVM.isLoading || bannerList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _controller,
                itemCount: bannerList.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final imageUrl = bannerList[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                bannerList.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 10 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.green
                        : Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
