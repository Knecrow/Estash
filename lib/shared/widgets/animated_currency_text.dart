import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';

class AnimatedCurrencyText extends StatelessWidget {
  final double value;
  final String currencySymbol;
  final TextStyle style;
  final Duration duration;
  final Curve curve;

  const AnimatedCurrencyText({
    super.key,
    required this.value,
    required this.currencySymbol,
    required this.style,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, child) {
        return Text(
          CurrencyFormatter.format(animatedValue, symbol: currencySymbol),
          style: style,
        );
      },
    );
  }
}
