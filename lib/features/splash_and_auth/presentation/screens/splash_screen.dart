import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/database/hive_keys.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../child/data/repositories/child_repository.dart';
import '../../../child/presentation/screens/world_map_screen.dart';
import 'user_selection_screen.dart';

/// Splash screen displaying port_logo.svg with the exact smile line animated.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final bool _hasLaunchedBefore;
  late final AnimationController _smileController;

  @override
  void initState() {
    super.initState();
    _hasLaunchedBefore = HiveService.getSetting<bool>(
          HiveKeys.hasLaunchedBeforeKey,
          defaultValue: false,
        ) ||
        ChildRepository.isProfileSetupComplete();

    // Fast, smooth loading loop on the exact smile line
    _smileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    if (_hasLaunchedBefore) {
      _navigateToNextScreen();
    }
  }

  @override
  void dispose() {
    _smileController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      final isRegistered = ChildRepository.isProfileSetupComplete();
      final targetScreen =
          isRegistered ? const WorldMapScreen() : const UserSelectionScreen();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => targetScreen),
      );
    });
  }

  void _onStartPressed() async {
    await HiveService.saveSetting(HiveKeys.hasLaunchedBeforeKey, true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const UserSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoWidth = MediaQuery.of(context).size.width * 0.78;
    final logoHeight = logoWidth / (1280 / 853);
    final logoColorFilter = isDark
        ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
        : null;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(),

              // The exact SVG Logo with animated smile line
              Center(
                child: SizedBox(
                  width: logoWidth,
                  height: logoHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Static base logo (everything except the smile line)
                      SvgPicture.asset(
                        'assets/images/port_logo_base.svg',
                        width: logoWidth,
                        height: logoHeight,
                        fit: BoxFit.contain,
                        colorFilter: logoColorFilter,
                      ),

                      // 2. Faint baseline track for the smile line
                      Opacity(
                        opacity: 0.15,
                        child: SvgPicture.asset(
                          'assets/images/port_logo_smile.svg',
                          width: logoWidth,
                          height: logoHeight,
                          fit: BoxFit.contain,
                          colorFilter: logoColorFilter,
                        ),
                      ),

                      // 3. Fast smooth loading sweep precisely along the SVG smile line
                      AnimatedBuilder(
                        animation: _smileController,
                        builder: (context, _) {
                          return ClipRect(
                            clipper: _SmileLineSpanClipper(
                              _smileController.value,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/port_logo_smile.svg',
                              width: logoWidth,
                              height: logoHeight,
                              fit: BoxFit.contain,
                              colorFilter: logoColorFilter,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Start button on first launch
              if (!_hasLaunchedBefore) ...[
                AppButton(
                  text: 'ابدأ',
                  variant: AppButtonVariant.primary,
                  height: 56,
                  onPressed: _onStartPressed,
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Precisely clips only across the horizontal bounds of the smile curve
/// (Smile curve occupies X: 31.5% -> 68.5% of the SVG canvas width)
class _SmileLineSpanClipper extends CustomClipper<Rect> {
  final double progress;

  _SmileLineSpanClipper(this.progress);

  // Exact normalized horizontal bounds of the smile path in port_logo.svg
  static const double smileStartX = 0.315;
  static const double smileEndX = 0.685;

  @override
  Rect getClip(Size size) {
    final currentRight = smileStartX + (smileEndX - smileStartX) * progress.clamp(0.0, 1.0);
    return Rect.fromLTRB(
      0,
      0,
      size.width * currentRight,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant _SmileLineSpanClipper oldClipper) =>
      oldClipper.progress != progress;
}
